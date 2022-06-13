{ pkgs, ... }: {
  home.file = {
    ".config/qtile" = {
      source = ./config;
      recursive = true;
    };
  };
}
