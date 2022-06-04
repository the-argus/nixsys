{ pkgs, ranger-devicons, ... }: {
  home.file =
    {
      ".config/ranger" = {
        source = ./config;
        recursive = true;
      };

      ".config/ranger/plugins/ranger_devicons" = {
        source = ranger-devicons;
        recursive = true;
      };
    };
}
