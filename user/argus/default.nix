{
    nixpkgs.config.allowUnfree = true;
    imports = [
        ./zsh.nix
    ];
}
