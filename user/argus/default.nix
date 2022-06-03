{ config, ... }: {
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./config # configures *everything* that can't be done in nix
    ./zsh.nix
    ./git.nix
    ./gtk.nix
  ];
  
  # "config" folder (stuff that isnt configured in nix)
  config.nvim.lsp.profile = "no-csharp";
}
