{
  pkgs,
  config,
  ...
}: {
  programs.ghostty = let
    font = config.system.theme.font.monospace;
    opacity = config.system.theme.opacity;
  in {
    enable = true;
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;

    enableZshIntegration = true;

    settings = {
      background-opacity = opacity;
      background-opacity-cells = true; # even neovim gets background opacity!
      font-family = font.name;
      font-size = font.size;
      window-decoration = "none";

      palette = with config.banner.palette; [
        "0=#${base00}"
        "1=#${base01}"
        "2=#${base02}"
        "3=#${base03}"
        "4=#${base04}"
        "5=#${base05}"
        "6=#${base06}"
        "7=#${base07}"
        "8=#${base08}"
        "9=#${base09}"
        "10=#${base0A}"
        "11=#${base0B}"
        "12=#${base0C}"
        "13=#${base0D}"
        "14=#${base0E}"
        "15=#${base0F}"
      ];

      background = "${config.banner.palette.base00}";
      foreground = "${config.banner.palette.base05}";
      cursor-color = "${config.banner.palette.base05}";
      selection-background = "${config.banner.palette.base02}";
      selection-foreground = "${config.banner.palette.base05}";
    };
  };
}
