{
  pkgs,
  nvim-config,
  config,
  ...
}: {
  imports = [
    ./bash.nix
    ../primary/lf.nix
  ];

  home.packages = with pkgs; [
    (nvim-config.packages.${pkgs.system}.mkNeovim {
      minimal = true;
      pluginsArgs = {
        bannerPalette = config.system.theme.scheme;
      };
      wrapperArgs = {
        viAlias = false;
        vimAlias = false;
      };
    })
    myPackages.ufetch
  ];
}
