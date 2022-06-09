{ ... }: {
  home.file = {
    ".local/share/applications" = {
      source = ./applications;
      recursive = true;
    };
  };
}
