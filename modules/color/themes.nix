{
  pkgs,
  unstable,
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
  inherit (allThemes) cursorThemes material-black-frost;

  rosePineTheme = {
    name = "rose-pine";
    package = pkgs.rose-pine-gtk-theme;
  };
  rosePineIcons = {
    name = "rose-pine";
    package = unstable.rose-pine-icon-theme;
  };

  kanagawaTheme = {
    package = kanagawa;
    name = "Kanagawa-B"; # or Kanagawa-BL
  };

  materialBlackFrostTheme = {
    package = material-black-frost;
    name = "Material-Black-Frost";
  };
  materialBlackFrostIcons = {
    package = material-black-frost;
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
      wallpaper = "rose/delorean.png";
      gtk = {
        # theme = rosePineTheme;
        theme = "gtkNix";
        iconTheme = rosePineIcons;
        cursorTheme = cursorThemes.posysImproved;
      };
      font = rec {
        monospace = {
          name = "FiraCode Nerd Font"; # "VictorMono Nerd Font";
          size = 12;
          package = pkgs.nerd-fonts.fira-code;
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

    rosepineOpaque = override defaultTheme {
      opacity = "1.0";
    };

    macchiato = override defaultTheme {
      wallpaper = "colourful-place.jpg";
      scheme = schemes.macchiato;
      font = override defaultTheme.font {
        # monospace = {
        #   name = "Cascadia Code";
        #   size = 12;
        #   package = pkgs.cascadia-code;
        # };
        monospace = {
          name = "Martian Mono";
          size = 12;
          package = pkgs.martian-mono;
        };
      };
    };

    amber-forest = override defaultTheme rec {
      wallpaper = "paradise.jpg";
      scheme = schemes.amber-forest;
    };

    gruvboxWithGtkNix = override defaultTheme rec {
      wallpaper = "gruv/pawel-czerwinski-gruvpaint.jpg";
      scheme = schemes.gruv;
      gtk = {
        theme = "gtkNix";
        iconTheme = {
          package = pkgs.gruvbox-dark-icons-gtk;
          name = "oomox-gruvbox-dark";
        };
        cursorTheme = cursorThemes.googleDotBlack;
      };
      discordTheme = discordThemes.mkDiscordThemeFromSystemTheme;
    };

    gruvbox = override defaultTheme rec {
      wallpaper = "gruv/fossil-gruv.png";
      scheme = schemes.gruv;
      gtk = {
        theme = {
          package = unstable.gruvbox-gtk-theme;
          name = "Gruvbox-Dark-B";
        };
        iconTheme = {
          package = pkgs.gruvbox-dark-icons-gtk;
          name = "oomox-gruvbox-dark";
        };
        cursorTheme = cursorThemes.posysImproved;
      };
      discordTheme = discordThemes.mkDiscordThemeFromSystemTheme;
      opacity = "0.9";
    };

    rosepine = override defaultTheme {
      discordTheme = discordThemes.rosepine;
      gtk.theme = rosePineTheme;
    };

    gtk4 = override defaultTheme {
      wallpaper = "overlookers-colored.jpg";
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
      wallpaper = "nord/lake.png";
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
      wallpaper = "nord/canyon.png";
      gtk.theme = "gtkNix";
    };

    orchis = override defaultTheme {
      wallpaper = "green-sky.png";
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
      wallpaper = "hld-wallpaper.png";
      font = defaultTheme.font;
      scheme = schemes.drifter;
      gtk = {
        theme = "gtkNix";
        iconTheme = {
          name = "Tela-circle";
          package = pkgs.tela-circle-icon-theme;
        };
      };
      opacity = "0.9";
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
