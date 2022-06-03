{ pkgs, ... }: {
  home.file = {
    ".config/ranger" = {
      source = ./config;
      recursive = true;
    };
    ".config/ranger/plugins/ranger_devicons" = builtins.fetchGit {
      url = "https://github.com/alexanderjeurissen/ranger_devicons";
      ref = "master";
      rev = "";
    };
  };
}
