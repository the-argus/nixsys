{ pkgs, unstable, lib, nur, chrome-extensions, webcord, ... }: {
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./local
    ./zsh.nix
    ./git.nix
    ./gtk
    ./firefox.nix
    ./alacritty.nix
    ./kitty.nix
    ./dunst.nix
    ./zathura.nix
    ./music
    ./spicetify.nix
    ./webcord
  ];

  programs.chromium = {
    enable = true;
    # package = pkgs.callPackage ../../packages/ungoogled-chromium {};
    package = unstable.ungoogled-chromium;

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
      #   # keepassxc browser
      #   id = "oboonakemofpalcgghocfoadofidjkkk";
      # }
    ];
  };

  # extra packages
  home.packages = with pkgs; [
    # unfree :(
    slack
    # discord
    # spotify-unwrapped
    (webcord.packages.${unstable.system}.default)
    # lutris

    # gui applications---------
    obs-studio
    element-desktop
    keepassxc
    pcmanfm
    qalculate-gtk
    unstable.heroic
    polymc
    pavucontrol
    sxiv
    mpv
    zathura
    qpwgraph
    qdirstat

    pinta
    inkscape
    # color palette
    unstable.wl-color-picker
    epick
    pngquant

    # tui
    cava

    # cli
    unstable.solo2-cli
    transmission
    unstable.ani-cli
    nix-prefetch-scripts

    # dev
    nodejs
    cargo
    sumneko-lua-language-server
    rnix-lsp
    libclang

    # appearance
    # rose-pine-gtk-theme
    # paper-gtk-theme # Paper
    # Icons: Lounge-aux
    # Themes: Lounge Lounge-compact Lounge-night Lounge-night-compact
    # lounge-gtk-theme
    # juno-theme # Juno Juno-mirage Juno-ocean Juno-palenight
    # graphite-gtk-theme # Graphite Graphite-dark Graphite-light Graphite-dark-hdpi Graphite-hdpi ....

    # paper-icon-theme
    # zafiro-icons
    # pantheon.elementary-icon-theme
    # material-icons
    # numix-cursor-theme # Numix-Cursor Numix-Cursor-Light
    # capitaine-cursors
  ];
}
