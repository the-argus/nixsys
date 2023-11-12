{
  pkgs,
  lib,
  banner,
  webcord,
  config,
  nvim-config,
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
    ./blugon.nix
    ./lf.nix
    ./ntfy.nix
    # ./vscode.nix
    banner.module
  ];

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
            useQmlls = false;
            viAlias = true;
            vimAlias = true;
          };
        })
        # unfree :(
        slack
        obsidian
        p4
        unityhub

        (bitwarden-rofi.packages.${pkgs.system}.default.override
          # roughly 300 hours lol
          {autoLock = 1000000;})

        nobar.packages.${pkgs.system}.default
        nextcloud-client
        myPackages.godot_4_mono-bin

        # gui applications---------
        bitwarden-cli
        pcmanfm
        qalculate-gtk
        pavucontrol
        mpv
        zathura
        qpwgraph
        qdirstat

        # cli
        trash-cli
        solo2-cli
        nix-prefetch-scripts
        # tigervnc
      ]
      ++ (lib.lists.optionals (!config.system.minimal) [
        # unfree :(
        steam-run
        steam-run-native

        # gui
        pinta
        webcordPkg
        obs-studio
        element-desktop
        # myPackages.xgifwallpaper

        # tui
        cava

        # cli
        myPackages.ufetch
        transmission
        # ani-cli
        glow
        myPackages.rgf
        shotgun

        # dev
        # nodejs
        cargo
      ]);
}
