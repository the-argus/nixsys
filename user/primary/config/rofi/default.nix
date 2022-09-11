{pkgs, ...}: {
  home.file = {
    ".config/rofi" = {
      source = ./config;
      recursive = true;
    };
  };
}
