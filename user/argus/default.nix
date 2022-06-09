{ pkgs, nur, ... }: {
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./zsh.nix
    ./git.nix
    ./gtk
    ./firefox.nix
  ];

  # allow access to NUR
  nixpkgs.config = {
    packageOverrides = pkgs: {
      nur = nur { inherit pkgs; };
    };
    # allowUnfreePredicate = (pkgs: true);
  };

  # extra packages
  services.flatpak.enable = true;
  home.packages = with pkgs; [
    # unfree :(
    # discord
    # spotify-unwrapped

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
    spicetify-cli
    solo2-cli
    solo-python
    transmission
    ani-cli

    # dev
    nodejs
    cargo
    sumneko-lua-language-server
    rnix-lsp
    libclang
  ];
}
