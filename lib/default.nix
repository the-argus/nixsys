{lib, ...}: rec {
  override = lib.attrsets.recursiveUpdate;

  debugSetToString = set: setname:
    "Attribute names of ${setname}:"
    + (builtins.concatStringsSep "\n" (builtins.attrNames set));

  debugSetTypes = set: let
    string =
      builtins.concatStringsSep "\n"
      (builtins.attrValues (builtins.mapAttrs
        (name: value: "Value ${name} is of type ${builtins.typeOf value}")
        set));
  in
    builtins.trace string set;

  parseSubSetString = set: string: let
    # from ``pkgs`` and "lib.out" this will grab pkgs.lib.out
    # hello.my.name.is becomes [ "hello" "my" "name" "is" ]
    subsets = lib.lists.reverseList (
      lib.lists.remove []
      (builtins.split "~" (builtins.replaceStrings ["."] ["~"] string))
    );
  in
    lib.lists.foldr
    (current: prev: prev.${current})
    set
    subsets;

  stringsToPkgs = availablePkgSets: stringList:
    map
    (value:
      if builtins.typeOf value == "set"
      then
        (parseSubSetString
          availablePkgSets.${value.set}
          value.package)
      else
        parseSubSetString
        availablePkgSets.pkgs
        value)
    stringList;

  globalConfig = rec {
    # returns a function which will take nixpkgs and unstable and return ANOTHER
    # function which takes settings and returns finalized settings
    mkFinalizer = {
      nixpkgs,
      nixpkgs-unstable,
      ...
    }: inputSettings:
      addPkgsToSettings {
        inherit nixpkgs-unstable nixpkgs;
        settings =
          inputSettings
          // {
            allowedUnfree =
              # merge allowed unfree defaults, so the inputs are in addition to
              # those
              defaults.allowedUnfree
              ++ inputSettings.allowedUnfree;
          };
      };

    # default settings. when passed into mkFinalizer will create the default
    # package sets
    defaults = import ./settings-defaults.nix;

    # function which accepts settings and returns the set that needs to be
    # passed after ``input nixpkgs``. Example usage is:
    # pkgs = import nixpkgs (mkPkgsInputs myCustomSettings);
    mkPkgsInputs = settings: (import ./make-pkgs-inputs.nix {
      inherit settings lib;
    });

    addPkgsToSettings = {
      nixpkgs-unstable,
      nixpkgs,
      settings,
    }: let
      # import nixpkgs unstable
      unstable =
        # standard nixpkgs but from the rolling release unstable branch
        import nixpkgs-unstable (mkPkgsInputs (
          override settings (settings.unstableOverrides)
        ));

      # import nixpkgs with remote build settings (aarch64 localSystem)
      remotebuild =
        # version of pkgs meant to be compiled on remote aarch64 server
        import nixpkgs
        (override
          (override (mkPkgsInputs settings) {
            localSystem.system = "aarch64-linux";
            crossSystem.system = "x86_64-linux";
          })
          settings.remotebuildOverrides);

      # import nixpkgs with localbuild settings (fancy overrides)
      localbuild =
        # version of pkgs meant to be compiled on my machine
        import nixpkgs
        (override (mkPkgsInputs settings)
          settings.remotebuildOverrides);

      # all the weird pkgsets with custom settings. will be used for overlays
      # on the main package set
      miscPkgSets = {inherit unstable remotebuild localbuild;};

      # function that should take a pkg set NAME and find the matching packageSelections entry and pkgsSets entry,
      # then use those to
      applyPackageSelectionsFromMiscPkgs = pkgSetName: prev:
        override prev {
          overlays =
            prev.overlays
            ++ [
              (_: original: (settings.packageSelections.${pkgSetName}
                miscPkgSets.${pkgSetName}
                original))
            ];
        };

      # the names of each package set in the order of precedence of overlays
      overlayQueue = ["unstable" "remotebuild" "localbuild"];

      # import nixpkgs but also overlay the packageSelections from unstable,
      # remotebuild, and localbuild.
      pkgs = import nixpkgs (lib.lists.foldr
        applyPackageSelectionsFromMiscPkgs
        (mkPkgsInputs settings)
        overlayQueue);
      # the last task is to merge the created package sets into the original
      # settings.
    in (lib.trivial.mergeAttrs settings rec {
      features = ["gccarch-${settings.optimization.arch}"];
      inherit pkgs unstable remotebuild localbuild;
      homeDirectory = "/home/${settings.username}";
    });
  };
}
