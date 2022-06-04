{ pkgs, nvim-config, ... }: {
  home.file = {
    # copy variable profile stuff
    # imports = [
    #   ./var
    # ];

    ".config/nvim" = {
      source = nvim-config;
      recursive = true;
    };
  };
}
