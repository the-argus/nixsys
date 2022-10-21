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
    map (value:
      if builtins.typeOf value == "set"
      then
        (parseSubSetString
          availablePkgSets.${value.set}
          value.package)
      else value)
    stringList;

  globalConfig = rec {
    defaults = import ./settings-defaults.nix; # default settings
    mkPkgsInputs = settings: (import ./make-pkgs-inputs.nix {
      inherit settings lib;
    }); # accepts settings as arg
    addOverlays = import ./add-overlays.nix;
    addPkgsToSettings = {
      nixpkgs-unstable,
      nixpkgs,
      settings,
    }: let
      # create the package sets
      unstable =
        # standard nixpkgs but from the rolling release unstable branch
        import nixpkgs-unstable (mkPkgsInputs (
          override settings (settings.unstableOverrides)
        ));
      remotebuild =
        # version of pkgs meant to be compiled on remote aarch64 server
        import nixpkgs
        (override (override (mkPkgsInputs settings) {
            localSystem.system = "aarch64-linux";
            crossSystem.system = "x86_64-linux";
          })
          settings.remotebuildOverrides);
      localbuild =
        # version of pkgs meant to be compiled on my machine
        import nixpkgs
        (override (mkPkgsInputs settings)
          settings.remotebuildOverrides);

      composeOverlays = pkgSetName: prev: let
        pkgSets = {inherit unstable remotebuild localbuild;};
      in
        addOverlays {
          pkgs = pkgSets.${pkgSetName};
          pkgsInputs = prev;
          selections = settings.packageSelections.${pkgSetName};
          inherit override;
        };

      overlayQueue = ["unstable" "remotebuild" "localbuild"];
      pkgs = import nixpkgs (lib.lists.foldr
        composeOverlays
        (mkPkgsInputs settings)
        overlayQueue);
    in (lib.trivial.mergeAttrs settings rec {
      features = ["gccarch-${settings.optimization.arch}"];
      inherit pkgs unstable remotebuild localbuild;
      homeDirectory = "/home/${settings.username}";
    });
  };
}
