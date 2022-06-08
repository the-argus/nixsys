{ pkgs, nur, ... }: {
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./zsh.nix
    ./git.nix
    ./gtk
    ./firefox.nix
    # ./gtk/themes/kanagawa.nix

    # extra configuration modules
    # ./config/nvim/var
  ];

  # "config" folder (stuff that isnt configured in nix)
  # nvim.lsp.profile = "no-csharp";

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
    discord
    spotify-unwrapped

    # gui applications---------
    keepassxc
    pcmanfm
    gnome.gnome-calculator
    heroic
    pavucontrol
    sxiv
    kitty
    mpv

    spotify-tray
    spicetify-cli

    pinta
    wl-color-picker
    # color palette
    epick
    pngquant

    # tui
    cava
    transmission
    ani-cli
  ];
}
