{ pkgs, ... }: {
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./zsh.nix
    ./git.nix
    ./gtk.nix
    
    # extra configuration modules
    # ./config/nvim/var
  ];
  
  # "config" folder (stuff that isnt configured in nix)
  # nvim.lsp.profile = "no-csharp";

  # extra packages
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # gui applications---------
    discord
    pavucontrol
    sxiv
    kitty
    mpv
    
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
