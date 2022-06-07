{ pkgs, ... }: {
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./zsh.nix
    ./git.nix
    ./gtk
    # ./gtk/themes/kanagawa.nix
    
    # extra configuration modules
    # ./config/nvim/var
  ];
  
  # "config" folder (stuff that isnt configured in nix)
  # nvim.lsp.profile = "no-csharp";

  # extra packages
  nixpkgs.config.allowUnfreePredicate = (pkgs: true);
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
    epick pngquant

    # tui
    cava
    transmission
    ani-cli
  ];
}
