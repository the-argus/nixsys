{ pkgs,  homeDirectory, ... }:

let
  kanagawa = import ./themes/kanagawa.nix {
    stdenv = pkgs.stdenv;
    gtk-engine-murrine = pkgs.gtk-engine-murrine;
  };

  rose-pine = import ./themes/rose-pine.nix {
    inherit (pkgs) stdenv gtk-engine-murrine fetchgit;
  };

  marwaita = pkgs.callPackage ./themes/marwaita.nix {};

  darkg = pkgs.callPackage ./themes/darkg.nix {};

  paperIcons = {
    name = "Paper-Mono-Dark";
    package = pkgs.paper-icon-theme;
  };

  rosePineIcons = {
    name = rose-pine.iconName;
    package = rose-pine.pkg;
  };

  numixCircleIcons = {
    name = "Numix-Circle"; # or Numix-Circle-Light
    package = pkgs.numix-icon-theme-circle;
  };

  rosePineTheme = {
    name = rose-pine.name;
    package = rose-pine.pkg;
  };

  marwaitaTheme = {
    name = "Marwaita";
    package = marwaita;
  };

  darkGTheme = {
    name = "DarkG";
    package = darkg;
  };

  selectedCursorTheme = "Numix-Cursor";
  selectedCursorPackage = pkgs.numix-cursor-theme;
in
{
  home.packages = [pkgs.dconf];
  home.file = {
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

      iconTheme = numixCircleIcons;

      theme = darkGTheme;

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
