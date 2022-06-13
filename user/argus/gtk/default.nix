{ pkgs, kanagawa-gtk, rose-pine-gtk, ... }:
{
  home.file = {
    ".config/gtk-4.0" = {
      source = "${rose-pine-gtk}/gtk4";
      recursive = true;
    };
  };
  gtk =
    let
      kanagawa = import ./themes/kanagawa.nix {
        inherit kanagawa-gtk;
        stdenv = pkgs.stdenv;
        gtk-engine-murrine = pkgs.gtk-engine-murrine;
      };

      rose-pine = import ./themes/rose-pine.nix {
        inherit rose-pine-gtk;
        stdenv = pkgs.stdenv;
        gtk-engine-murrine = pkgs.gtk-engine-murrine;
      };

      paperIcons = {
        name = "Paper-Mono-Dark";
        package = pkgs.paper-icon-theme;
      };

      rosePineIcons = {
        name = rose-pine.iconName;
        package = rose-pine.pkg;
      };

      rosePineTheme = {
        name = rose-pine.name;
        package = rose-pine.pkg;
      };
    in
    {
      enable = true;

      font = {
        name = "Fira Code";
        size = 11;
        package = pkgs.fira-code;
      };

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
        size = 16;
      };

      iconTheme = rosePineIcons;

      theme = rosePineTheme;

      gtk3 = {
        bookmarks = [
          "file:///home/argus/Downloads"
          "file:///home/argus/Programming"
          "file:///home/argus/Video"
          "file:///home/argus/Music"
          "file:///home/argus/Screenshots"
          "file:///home/argus/Wallpapers"
        ];
      };
    };
}
