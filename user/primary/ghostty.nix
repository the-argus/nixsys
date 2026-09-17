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
        "0=#${ansi00}"
        "1=#${ansi01}"
        "2=#${ansi02}"
        "3=#${ansi03}"
        "4=#${ansi04}"
        "5=#${ansi05}"
        "6=#${ansi06}"
        "7=#${ansi07}"
        "8=#${ansi08}"
        "9=#${ansi09}"
        "10=#${ansi0A}"
        "11=#${ansi0B}"
        "12=#${ansi0C}"
        "13=#${ansi0D}"
        "14=#${ansi0E}"
        "15=#${ansi0F}"
      ];

      background = "${config.banner.palette.base00}";
      foreground = "${config.banner.palette.base05}";
      cursor-color = "${config.banner.palette.base05}";
      selection-background = "${config.banner.palette.base02}";
      selection-foreground = "${config.banner.palette.base05}";
    };
  };
}
