{
  pkgs,
  lib,
  banner,
  config,
  nvim-config,
  bitwarden-rofi,
  unstable,
  # nobar,
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
    ./webcord.nix
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

  # extra packages
  home.packages = with pkgs;
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
      # slack
      obsidian

      (bitwarden-rofi.packages.${pkgs.system}.default.override
        # roughly 300 hours lol
        {autoLock = 1000000;})

      # nobar.packages.${pkgs.system}.default
      nextcloud-client
      # myPackages.godot_4_mono-bin
      unstable.trenchbroom
      # godot_4

      webcord

      # gui applications---------
      pcmanfm
      qalculate-gtk
      pavucontrol
      mpv
      zathura
      # qpwgraph
      qdirstat

      # cli
      bitwarden-cli
      # trash-cli
      # solo2-cli
      nix-prefetch-scripts
      repgrep
      myPackages.ctrlf
      # xorg.xhost
      ripgrep
      duf
      fd
      tldr
      zoxide
      myPackages.fzf-16
      direnv
      nix-index
      neofetch
      nix-direnv-flakes
      # tigervnc
    ]
    ++ (lib.lists.optionals (!config.system.minimal) [
      # unfree :(
      # steam-run
      # steam-run-native

      # gui
      pinta
      obs-studio
      # element-desktop
      # myPackages.xgifwallpaper

      # tui
      cava

      # cli
      myPackages.ufetch
      transmission_4
      # ani-cli
      glow
      # myPackages.rgf
      shotgun

      # dev
      # nodejs
      # cargo
    ]);
}
