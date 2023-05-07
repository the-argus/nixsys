{...}: {
  home.file = {
    ".config/labwc" = {
      source = ./config;
      recursive = true;
    };
  };
}
