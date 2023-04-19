{
  pkgs,
  nvim-config,
  config,
  ...
}: {
  imports = [
    ../primary/zsh.nix
    ../primary/lf.nix
    ../primary/git.nix
  ];

  home.packages = with pkgs; [
    (nvim-config.packages.${pkgs.system}.mkNeovim {
      pluginsArgs = {
        bannerPalette = config.system.theme.scheme;
      };
      wrapperArgs = {
        viAlias = false;
        vimAlias = false;
      };
    })
    nix-prefetch-scripts
    trash-cli
    myPackages.ufetch
    glow
    myPackages.rgf
  ];
}
