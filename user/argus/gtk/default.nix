{ pkgs, kanagawa-gtk, rose-pine-gtk, homeDirectory, ... }:

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

  selectedCursorTheme = "Numix-Cursor";
  selectedCursorPackage = pkgs.numix-cursor-theme;
in
{
  home.file = {
    ".config/gtk-4.0" = {
      source = "${rose-pine-gtk}/gtk4";
      recursive = true;
    };

    # xorg cursor
    ".icons/default/index.theme" = {
      text = ''
        [Icon Theme]
        Inherits=${selectedCursorTheme}
      '';
    };
  };
  gtk =
    {
      enable = true;

      font = {
        name = "Fira Code";
        size = 11;
        package = pkgs.fira-code;
      };

      cursorTheme = {
        name = selectedCursorTheme;
        package = selectedCursorPackage;
        size = 16;
      };

      iconTheme = rosePineIcons;

      theme = rosePineTheme;

      gtk3 = {
        bookmarks = [
          "file://${homeDirectory}/Downloads"
          "file://${homeDirectory}/Programming"
          "file://${homeDirectory}/Video"
          "file://${homeDirectory}/Music"
          "file://${homeDirectory}/Screenshots"
          "file://${homeDirectory}/Wallpapers"
        ];
      };
    };
}
