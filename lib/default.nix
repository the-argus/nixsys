{lib, ...}: rec {
  override = lib.attrsets.recursiveUpdate;

  attrNamesToList = attrs: let
    names = builtins.mapAttrs (name: value: name) attrs;
  in
    lib.attrsets.collect (value: true) attrs;

  debugSetToString = set: setname:
    "Attribute names of ${setname}:"
    + (builtins.concatStringsSep "\n" (attrNamesToList set));

  parseSubSetString = set: string: let
    # hello.my.name.is becomes [ "hello" "my" "name" "is" ]
    subsets =
      lib.lists.remove []
      (builtins.split "~" (builtins.replaceStrings ["."] ["~"] string));
  in
    lib.lists.foldr (current: prev:
      if builtins.hasAttr current prev
      then prev.${current}
      else
        builtins.trace "${debugSetToString prev "previous"}\n current: ${current}"
        (abort "what"))
    set
    subsets;

  stringsToPkgs = pkgs: stringList:
    map (pkgName: (parseSubSetString pkgs pkgName)) stringList;

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
