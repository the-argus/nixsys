{ pkgs, lib, ... }:
let
  inherit (lib) types mkOption;

  override = lib.attrsets.recursiveUpdate;

  # color schemes --------------------------------------------------
  schemes = import ./color-schemes.nix;

  # discord theme packages -----------------------------------------
  discordThemes = pkgs.callPackage ./webcord/pkgs.nix { };

  # gtk themes -----------------------------------------------------
  kanagawa = import ./gtk/themes/kanagawa.nix {
    stdenv = pkgs.stdenv;
    gtk-engine-murrine = pkgs.gtk-engine-murrine;
  };
  rose-pine = import ./gtk/themes/rose-pine.nix {
    inherit (pkgs) stdenv gtk-engine-murrine fetchgit;
  };
  marwaita = pkgs.callPackage ./gtk/themes/marwaita.nix { };
  darkg = pkgs.callPackage ./gtk/themes/darkg.nix { };
  nord = pkgs.callPackage ./gtk/themes/nord.nix { };

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

  nordicTheme = {
    name = nord.name;
    package = nord.pkg;
  };
  nordzyIcons = {
    name = nord.iconName;
    package = nord.iconPkg;
  };
  nordzyCursor = {
    name = "Nordzy-Cursors";
    package = nord.iconPkg;
  };

  # themes --------------------------------------------------
  defaultTheme = {
    gtk = {
      theme = rosePineTheme;
      iconTheme = rosePineIcons;
      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
        size = 16;
      };
    };
    font = {
      monospace = {
        name = "FiraCode Nerd Font";
        size = 14;
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      };
      display = {
        name = "Fira Code";
        size = 11;
        package = pkgs.fira-code;
      };
    };
    discordTheme = discordThemes.inScheme;
    scheme = schemes.rosepine;
    opacity = "0.8";
  };

  rosePine = override defaultTheme {
    discordTheme = discordThemes.rosepine;
  };

  gtk4 = override defaultTheme {
    gtk = {
      theme = darkGTheme;
      iconTheme = numixCircleIcons;
    };
    font = {
      display = {
        name = "Montserrat";
        size = 12;
        package = pkgs.montserrat;
      };
    };
    discordTheme = discordThemes.slate;
    scheme = schemes.gtk4;
    opacity = "1.0";
  };

  nordic = override defaultTheme {
    gtk = {
      theme = nordicTheme;
      iconTheme = nordzyIcons;
      cursorTheme = nordzyCursor // { size = 16; };
    };
    discordTheme = discordThemes.nordic;
    scheme = schemes.nord;
    opacity = "0.8";
  };
in
defaultTheme
