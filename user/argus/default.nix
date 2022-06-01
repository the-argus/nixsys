{
    nixpkgs.config.allowUnfree = true;
    imports = [
        ./zsh.nix
        ./git.nix
        ./gtk.nix
    ];
}
