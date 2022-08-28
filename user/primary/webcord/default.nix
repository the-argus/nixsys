{ pkgs, ... }:
with (pkgs.callPackage ./pkgs.nix { });
{
  home.file = {
    ".config/WebCord/Themes" =
      let
        theme = (pkgs.callPackage ../themes.nix { }).discordTheme;
      in
      {
        source = theme;
        # source = (mkFrostedGlass "https://raw.githubusercontent.com/the-argus/wallpapers/main/matte/delorean.png");
        recursive = true;
      };
  };
}
