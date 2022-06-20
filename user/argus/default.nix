{ pkgs, unstable, lib, nur, ... }: {
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./local
    ./zsh.nix
    ./git.nix
    ./gtk
    ./firefox.nix
    ./alacritty.nix
    ./dunst.nix
    ./zathura.nix
    # ./spicetify.nix
  ];

  # allow access to NUR
  nixpkgs.config = {
    # packageOverrides = pkgs: {
    #   nur = nur { inherit pkgs; };
    # };
    # allowUnfreePredicate = (pkgs: true);
    # allow spotify to be installed if you don't have unfree enabled already
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "spotify-unwrapped"
      "reaper"
    ];
  };

  # extra packages
  home.packages = with pkgs; [
    # unfree :(
    # discord
    spotify-unwrapped
    spicetify-cli

    # music
    reaper
    lmms

    # airwave is unfortunately out of date
    #(import ../../packages/airwave.nix {inherit pkgs; inherit lib;})

    # plugins
    zam-plugins
    unstable.cardinal
    # TODO: Fire distortion, Ruina distortion
    # Gatelab, filterstep, and panflow (use panflow for 70s drums)
    # deelay (kinda like valhalla supermassive)
    wineWowPackages.full

    # synths
    surge-XT
    oxefmsynth
    # bespokesynth
    # bespokesynth-with-vst2

    # gui applications---------
    keepassxc
    pcmanfm
    gnome.gnome-calculator
    unstable.heroic
    pavucontrol
    sxiv
    kitty
    mpv
    zathura


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
    rose-pine-gtk-theme
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

  # music plugins
  home.file = {
    ".vst/zam" = {
      source = "${pkgs.zam-plugins}/lib/vst";
      recursive = true;
    };
    ".vst/surge" = {
      source = "${pkgs.surge-XT}/lib/vst3";
      recursive = true;
    };
    ".vst/oxe" = {
      source = "${pkgs.oxefmsynth}/lib/lxvst";
      recursive = true;
    };
    ".vst/cardinal" = {
      source = "${unstable.cardinal}/lib";
      recursive = true;
    };
    # ".vst/bespoke" = {
    #   source = "${pkgs.bespokesynth-with-vst2}";
    #   recursive = true;
    # };
  };
}
