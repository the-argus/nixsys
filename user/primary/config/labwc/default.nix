{pkgs, ...}: {
  home.file = {
    ".config/labwc" = {
      source = pkgs.callPackage ./config-wrapper.nix {};
      recursive = true;
    };
  };
}
