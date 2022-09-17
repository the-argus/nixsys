{
  pkgs,
  unstable,
  remotebuild,
  lib,
  nur,
  chrome-extensions,
  webcord,
  settings,
  additionalUserPackages ? [],
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
    ./music
    ./spicetify.nix
    ./i3.nix
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
    webcordPkg = webcord.packages.${unstable.system}.default;
  in
    with pkgs;
      [
        # unfree :(
        slack
        discord
        # spotify-unwrapped
        # lutris

        # gui applications---------
        webcordPkg
        obs-studio
        gimp
        thunderbird
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

        # useful linters
        python310Packages.demjson3
        python310Packages.mdformat
        unstable.alejandra

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
      ++ (map (pkgName: let
        pkgsets = {inherit pkgs unstable remotebuild;};
      in
        if builtins.typeOf pkgName == "set"
        then pkgsets.${pkgName.set}.${pkgName.package}
        else pkgs.${pkgName})
      additionalUserPackages);
}
