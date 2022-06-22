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

    ChowPhaser
    ChowKick
    ChowCentaur
    CHOWTapeModel
    airwindows-lv2
    odin2

    tunefish
    
    # need to look up what these are (nix search lv2)
    # talentedhack # autotalent ported to lv2
    # x42-plugins
    # vocproc
    # x42-avldrums
    # sorcer
    # rkrlv2
    # plujain-ramp
    
    # https://www.youtube.com/playlist?list=PLCXbZyyqusu3b3_CD6gHj4fKHE4AiesnJ
    # TODO: Fire distortion, Ruina distortion
    # AIRWINDOWS (NC-17 is cool)
    # Gatelab, filterstep, and panflow (use panflow for 70s drums)
    # Surge FX (Surge XT effects separated)
    # deelay (kinda like valhalla supermassive)
    # driftmaker delay disentegration (creepy digital delay)
    # emergence - grain delay thing, very visual, trip-hop-ey
    # fogpad (open source babeyyy, check out the creator)
    # PSP pianoverb (simulates having a sustaining piano in the room when a loud sound is played)
    # all the CHOW plugins, CHOW matrix works on linux, open source
    # GSatPlus (excellent sounding free saturation plugin)
    # Burier (also saturation, absolutely destroys shit, can be a cool distortion pedal)
    #           https://www.youtube.com/watch?v=lw03654HndM&list=PLCXbZyyqusu3b3_CD6gHj4fKHE4AiesnJ&index=3
    # Melda Free Bundle https://www.meldaproduction.com/MFreeFXBundle
    # Channe V (de-esser, compressor, limiter, pre, tape) analog obsession
    # PreBox (analog obsession, saturation-ey mix glue thing)
    # Magic Dice by baby audio (random delay)
    # Amplitube CS (stompboxes tuner preamps and shit, freemium though)
    # TDR Nova
    # Zebralette U-he
    
    # other plugins i should get:
    # modartt pianoteq 
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
