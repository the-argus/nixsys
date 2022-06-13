{ pkgs, ... }: {
  home.file = {
    ".config/dunst" = {
      source = ./config;
      recursive = true;
    };
  };
}
