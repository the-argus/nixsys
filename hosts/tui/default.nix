{nixpkgs, ...}: let
  override = nixpkgs.lib.attrsets.recursiveUpdate;
in rec {
  system = "x86_64-linux";
  username = "argus";
  useDvorak = false;
  # unfree packages that i explicitly use
  allowedUnfree = [];
  allowBroken = true;
  extraExtraSpecialArgs = {};
  extraSpecialArgs = {};
  additionalModules = [./home-manager];
  additionalOverlays = [];
  packageSelections = {
    # packages to override with their unstable versions
    # all of these are things that i might want to move
    # to remotebuild at some point (so theyre FOSS)
    unstable = unstable: _:
      with unstable; {
        inherit
          alejandra
          solo2-cli
          OVMFFull
          ;
      };
    localbuild = _: _: {};
    remotebuild = _: _: {};
  };
  additionalNixosModules = [];
  optimization = {
    arch = "tigerlake";
    useMusl = false; # use musl instead of glibc
    useFlags = false; # use USE
    useClang = false; # cland stdenv
    useNative = false; # native march
    USE = [];
  };
  name = "pkgs";
  remotebuildOverrides = {
    name = "remotebuild";
  };
  unstableOverrides = {
    name = "unstable";
  };
  localbuildOverrides = override remotebuildOverrides {
    name = "localbuild";
  };
}
