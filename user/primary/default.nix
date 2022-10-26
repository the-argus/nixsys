{
  pkgs,
  unstable,
  banner,
  remotebuild,
  localbuild,
  lib,
  nur,
  chrome-extensions,
  webcord,
  settings,
  additionalUserPackages ? [],
  config,
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
    ../../modules/color/themes.nix
    ../../modules/home-manager
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
      #   # keepassxc browser
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
        # unfree :(
        slack
        discord
        # spotify-unwrapped
        # lutris

        # gui applications---------
        prismlauncher
        webcordPkg
        obs-studio
        gimp
        thunderbird
        element-desktop
        keepassxc
        pcmanfm
        qalculate-gtk
        heroic
        pavucontrol
        sxiv
        mpv
        zathura
        qpwgraph
        qdirstat

        pinta
        inkscape
        # color palette
        wl-color-picker
        epick
        pngquant

        # tui
        cava

        # cli
        solo2-cli
        transmission
        ani-cli
        nix-prefetch-scripts
        tigervnc

        # dev
        nodejs
        cargo

        # useful linters, formatters, or both
        python310Packages.demjson3 # jsonlint
        nodePackages.fixjson
        nodePackages.markdownlint-cli
        alejandra
        nodePackages.prettier
        sumneko-lua-language-server
        rnix-lsp
        libclang # clangd

        # typing games
        # thokr     # another simply game with the added ability to tweet
        # your results
        # ktouch    # underwhelming, QWERTY-only. provides a useful
        # capitalization lesson for my bad shift habits
        # ttyper    # simple game, just typing random words then it tells
        # you your speed
        # toipe     # another simple game, looks nice too

        tipp10 # in-depth QWERTY trainer, could support dvorak with
        # a bit of effort (key replacement filter)
        klavaro # good for QWERTY, but only lets you do systemwide
        # dvorak
        gtypist # very good for qwerty, also requires systemwide
        # dvorak
        gotypist # makes you practice fast, slow, and medium.
        # cool typing experiment, idk how good it is really
        #typespeed  # words come flying at you from the left side. fun
        # game, idk how good it really is for typing

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
      ]
      ++ ((import ../../lib {inherit lib;}).stringsToPkgs
        {inherit unstable localbuild remotebuild pkgs;}
        additionalUserPackages);
}
