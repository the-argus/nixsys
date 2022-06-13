{ ... }: {
  home.file = {
    ".local/share/applications" = {
      source = ./applications;
      recursive = true;
    };

    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };
}
