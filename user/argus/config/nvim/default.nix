{ pkgs, nvim-config, ... }: {
  home.file = {
    ".config/nvim" = {
      source = nvim-config;
      recursive = true;
    };
  };
}
