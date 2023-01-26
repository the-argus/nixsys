{
  pkgs,
  lib,
  banner,
  webcord,
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
        # unfree :(
        slack
        discord

        bitwarden-rofi.packages.${pkgs.system}.default

        nobar.packages.${pkgs.system}.default
        nextcloud-client

        # gui applications---------
        bitwarden-cli
        pcmanfm
        qalculate-gtk
        pavucontrol
        sxiv
        mpv
        zathura
        qpwgraph
        qdirstat

        # color palette
        wl-color-picker
        # epick
        # pngquant

        # cli
        solo2-cli
        nix-prefetch-scripts
        blugon
        # tigervnc
      ]
      ++ (lib.lists.optionals (!config.system.minimal) [
        # unfree :(
        p4
        steam-run
        steam-run-native

        # gui
        gimp
        pinta
        webcordPkg
        obs-studio
        element-desktop
        myPackages.xgifwallpaper

        # tui
        (myPackages.neovim-remote.override {
          inherit (config.desktops) terminal;
        })
        cava

        # cli
        myPackages.ufetch
        transmission
        ani-cli

        # dev
        nodejs
        cargo
      ]);
}
