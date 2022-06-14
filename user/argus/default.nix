{ pkgs, lib, nur, ... }: {
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./local
    ./zsh.nix
    ./git.nix
    ./gtk
    ./firefox.nix
    ./alacritty.nix
    #./spicetify.nix
  ];

  # allow access to NUR
  nixpkgs.config = {
    packageOverrides = pkgs: {
      nur = nur { inherit pkgs; };
    };
    allowUnfreePredicate = (pkgs: true);
  };

  # extra packages
  home.packages = with pkgs; [
    # unfree :(
    # discord
    spotify-unwrapped
    spicetify-cli

    # music
    reaper
    zam-plugins
    surge-XT
    oxefmsynth
    bespokesynth
    (import ../../packages/airwave.nix {inherit pkgs; inherit lib;})

    # gui applications---------
    keepassxc
    pcmanfm
    gnome.gnome-calculator
    heroic
    pavucontrol
    sxiv
    kitty
    mpv


    pinta
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

    # dev
    nodejs
    cargo
    sumneko-lua-language-server
    rnix-lsp
    libclang

    # appearance
    rose-pine-gtk-theme
  ];

  # music plugins
  home.file = {
    ".vst/zam" = {
      source = pkgs.zam-plugins;
      recursive = true;
    };
    ".vst/surge" = {
      source = pkgs.surge-XT;
      recursive = true;
    };
    ".vst/oxe" = {
      source = pkgs.oxefmsynth;
      recursive = true;
    };
    ".vst/bespoke" = {
      source = pkgs.bespokesynth;
      recursive = true;
    };
  };
}
