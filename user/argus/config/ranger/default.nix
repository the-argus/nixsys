{ pkgs, ... }: {
  home.file = {
    ".config/ranger" = {
      source = ./config;
      recursive = true;
    };
  };
}
