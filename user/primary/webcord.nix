{pkgs, ...}:
with (pkgs.callPackage ./pkgs.nix {}); {
  home.file = {
    ".config/WebCord/Themes" = let
      # this will only be loaded by calling "webcord --add-css-theme=~/.config/WebCord/Themes"
      theme = (pkgs.callPackage ./themes.nix {}).discordTheme;
    in {
      source = theme;
      # source = (mkFrostedGlass "https://raw.githubusercontent.com/the-argus/wallpapers/main/matte/delorean.png");
      recursive = true;
    };
  };
}
