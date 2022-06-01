{ pkgs, ... }: {
  home.file = {
    ".config/zathura" = {
      source = ./config;
      recursive = true;
    };
  };
}
