{ pkgs, ... }:
with (pkgs.callPackage ./pkgs.nix {});
{
  home.file = {
    ".config/WebCord/Themes" = {
      source = slate;
      # source = (mkFrostedGlass "https://raw.githubusercontent.com/the-argus/wallpapers/main/matte/delorean.png");
      recursive = true;
    };
  };
}
