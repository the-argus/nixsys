{
  pkgs,
  unstable,
  banner,
  remotebuild,
  localbuild,
  lib,
  webcord,
  additionalUserPackages ? [],
  config,
  nvim-config,
  username,
  stateVersion,
  bitwarden-rofi,
  nobar,
  ...
}: {
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./local
    ./zsh.nix
    ./git.nix
    ./gtk.nix
    ./firefox.nix
    ./alacritty.nix
    ./kitty.nix
    ./dunst.nix
    ./zathura.nix
    ./music.nix
    ./spicetify.nix
    ./waybar.nix
    ./rofi.nix
    ../../modules/color/themes.nix
    ../../modules/home-manager
    banner.module
  ];

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
  };

  banner.palette = config.system.theme.scheme;

  programs.chromium = {
    enable = true;
    # package = pkgs.callPackage ../../packages/ungoogled-chromium {};
    package = pkgs.ungoogled-chromium;

    extensions = [
      # chrome-extensions.ublock-origin
      # {
      #   # chromium web store
      #   id = "ocaahdebbfolfmndjeplogmgcagdmblk";
      #   updateUrl = "https://raw.githubusercontent.com/NeverDecaf/chromium-web-store/master/updates.xml";
      # }
      # {
      #   # ublock origin
      #   id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      # }
      # {
      #   id = "oboonakemofpalcgghocfoadofidjkkk";
      # }
    ];
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "inode/directory" = ["ranger.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop"];
    };
    defaultApplications = {
      "inode/directory" = ["ranger.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop"];
    };
  };

  # extra packages
  home.packages = let
    webcordPkg = webcord.packages.${pkgs.system}.default;
  in
    with pkgs;
      [
        (nvim-config.packages.${pkgs.system}.mkNeovim {
          pluginsArgs = {
            bannerPalette = config.system.theme.scheme;
          };
          wrapperArgs = {
            viAlias = true;
            vimAlias = true;
          };
        })
        (callPackage ../../packages/ufetch.nix {})
        # unfree :(
        slack
        discord

        bitwarden-rofi.packages.${pkgs.system}.default

        nobar.packages.${pkgs.system}.default

        # gui applications---------
        webcordPkg
        obs-studio
        element-desktop
        bitwarden-cli
        pcmanfm
        qalculate-gtk
        pavucontrol
        sxiv
        mpv
        zathura
        qpwgraph
        qdirstat

        pinta
        # color palette
        wl-color-picker
        epick
        pngquant

        (pkgs.callPackage ../../packages/xgifwallpaper.nix {})

        # tui
        cava

        # cli
        solo2-cli
        transmission
        ani-cli
        nix-prefetch-scripts
        # tigervnc

        # dev
        nodejs
        cargo

        # nobar
        xkb-switch
        playerctl
      ]
      ++ ((import ../../lib {inherit lib;}).stringsToPkgs
        {inherit unstable localbuild remotebuild pkgs;}
        additionalUserPackages);
}
