{
  pkgs,
  lib,
  banner,
  settings,
  ...
}: let
  override = pkgs.lib.attrsets.recursiveUpdate;

  # color schemes --------------------------------------------------
  schemes = pkgs.callPackage ./schemes {inherit banner;};

  # discord theme packages -----------------------------------------
  inherit (pkgs.myPackages) discordThemes;

  # gtk themes -----------------------------------------------------
  allThemes = pkgs.myPackages.gtkThemes;
  inherit (allThemes) kanagawa rose-pine marwaita darkg nord;
  inherit (allThemes) cursorThemes materialBlackFrost;

  rosePineTheme = {
    name = "rose-pine-gtk";
    package = pkgs.rose-pine-gtk-theme;
  };
  rosePineIcons = {
    name = "rose-pine-icons";
    package = pkgs.rose-pine-gtk-theme;
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

  availableThemes = rec {
    defaultTheme = rec {
      gtk = {
        # theme = rosePineTheme;
        theme = "gtkNix";
        iconTheme = rosePineIcons;
        cursorTheme = cursorThemes.posysImproved;
      };
      font = rec {
        monospace = {
          name = "FiraCode Nerd Font"; # "VictorMono Nerd Font";
          size = 14;
          package = pkgs.nerdfonts.override {
            fonts = [
              # "VictorMono"
              "FiraCode "
            ];
          };
          #   name = "Sarasa Gothic";
          #   size = 14;
          #   package = pkgs.sarasa-gothic;
        };
        display = {
          # name = "Victor Mono Semibold";
          # size = 12;
          # package = pkgs.victor-mono;
          name = "Fira Code";
          size = 11;
          package = pkgs.fira-code;
        };
      };
      discordTheme = discordThemes.mkDiscordThemeFromSystemTheme;
      scheme = schemes.rosepine;
      opacity = "0.8";
    };

    amber-forest = override defaultTheme rec {
      scheme = schemes.amber-forest;
    };

    gruvbox = override defaultTheme rec {
      scheme = schemes.gruv;
      gtk = {
        theme = "gtkNix";
        # theme = {
        #   package = pkgs.gruvbox-dark-gtk;
        #   name = "gruvbox-dark";
        # };
        iconTheme = {
          package = pkgs.gruvbox-dark-icons-gtk;
          name = "oomox-gruvbox-dark";
        };
        cursorTheme = cursorThemes.googleDotBlack;
      };
      discordTheme = discordThemes.mkDiscordThemeFromSystemTheme;
    };

    rosepine = override defaultTheme {
      discordTheme = discordThemes.rosepine;
      gtk.theme = rosePineTheme;
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

    nordicWithGtkNix = override nordic {
      gtk.theme = "gtkNix";
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

    drifter = override defaultTheme rec {
      font = defaultTheme.font;
      scheme = schemes.drifter;
      gtk = {
        iconTheme = materialBlackFrostIcons;
        theme = "gtkNix";
        cursorTheme = cursorThemes.breezeXBlack;
      };
      opacity = "0.7";
      discordTheme = discordThemes.mkDiscordThemeFromSystemTheme;
    };
  };
in {
  options = {
    system.theme = lib.mkOption {
      type = lib.types.attrs;
      default =
        if builtins.hasAttr "theme" settings
        then
          (
            if builtins.typeOf settings.theme == "string"
            then availableThemes.${settings.theme}
            else if builtins.typeOf settings.theme == "set"
            then settings.theme
            else availableThemes.defaultTheme
          )
        else availableThemes.defaultTheme;
    };
  };
}
