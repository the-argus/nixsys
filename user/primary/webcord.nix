{
  pkgs,
  config,
  ...
}:
with (pkgs.callPackage ./pkgs.nix {}); {
  home.file = {
    ".config/WebCord/Themes" = let
      # this will only be loaded by calling "webcord --add-css-theme=~/.config/WebCord/Themes"
      theme = let
        systemTheme = config.system.theme;
      in
        pkgs.callPackage systemTheme.discordTheme {inherit config systemTheme;};
    in {
      source = theme;
      # source = (mkFrostedGlass "https://raw.githubusercontent.com/the-argus/wallpapers/main/matte/delorean.png");
      recursive = true;
    };
  };
}
