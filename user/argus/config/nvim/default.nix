{ pkgs, nvim-config, ... }: {
  home.file = {
    # copy variable profile stuff
    # imports = [
    #   ./var
    # ];

    ".config/nvim" = nvim-config;
    # copy base configuration
    # ".config/nvim" = builtins.fetchTarball {
    #   url = "https://github.com/the-argus/nvim-config/archive/refs/tags/v0.0.1.tar.gz";
    #   sha256 = "1548x0v8fbavh0qmkrmq0ah6qwgh3kra1c363z8frn2wfqfkm1d0";
    # };
  };
}
