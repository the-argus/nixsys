{ pkgs, ... }:
let
  override = pkgs.lib.attrsets.recursiveUpdate;

  # color schemes --------------------------------------------------
  schemes = import ./schemes;

  # discord theme packages -----------------------------------------
  discordThemes = pkgs.callPackage ../../packages/discord-themes.nix { };

  # gtk themes -----------------------------------------------------
  allThemes = pkgs.callPackage ../../packages/gtk-themes { };
  inherit (allThemes) kanagawa rose-pine marwaita darkg nord;
  inherit (allThemes) cursorThemes materialBlackFrost;

  rosePineTheme = {
    name = "rose-pine-gtk";
    package = rose-pine;
  };
  rosePineIcons = {
    name = "rose-pine-icons";
    package = rose-pine;
  };

  kanagawaTheme = {
    package = kanagawa;
    name = "Kanagawa-B"; # or Kanagawa-BL
  };

  materialBlackFrostTheme = {
    package = materialBlackFrost;
    name = "Material-Black-Frost";
  };
  materialBlackFrostIcons = {
    package = materialBlackFrost;
    name = "Black-Frost-Numix-FLAT"; # also Black-Frost-Numix and Black-Frost-Suru
  };


  paperIcons = {
    name = "Paper-Mono-Dark";
    package = pkgs.paper-icon-theme;
  };
  numixCircleIcons = {
    name = "Numix-Circle"; # or Numix-Circle-Light
    package = pkgs.numix-icon-theme-circle;
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
    name = "Nordic";
    package = nord;
  };
  nordzyIcons = {
    name = "NordArc";
    package = nord;
  };
in
rec {

  # themes --------------------------------------------------
  defaultTheme = {
    gtk = {
      theme = rosePineTheme;
      iconTheme = rosePineIcons;
      cursorTheme = cursorThemes.posysImproved;
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
      cursorTheme = cursorThemes.nordzyCursor;
    };
    discordTheme = discordThemes.nordic;
    scheme = schemes.nord;
    opacity = "0.8";
  };

  orchis = override defaultTheme {
    gtk = {
      theme = {
        name = "Orchis-Light"; # Orchis, Orchis-Light, Orchis-Compact, Orchis-Dark, Orchis-Dark-Compact, Orchis-Green, Orchis-Green Compact, etc
        # colors: Green Grey Orange Pink Purple Red Yellow
        package = pkgs.orchis;
      };
      iconTheme = {
        name = "Tela-circle"; # or Tela-circle-dark
        package = pkgs.tela-circle-icon-theme;
      };
    };
  };

  drifter = override defaultTheme {
    scheme = schemes.drifter;
    gtk = {
      iconTheme = materialBlackFrostIcons;
      theme = materialBlackFrostTheme;
      cursorTheme = cursorThemes.breezeXBlack;
    };
    opacity = "0.7";
  };
}