{ pkgs, ... }: {
  home.file = {
    ".config/neofetch" = {
      source = ./config;
      recursive = true;
    };
  };
}
