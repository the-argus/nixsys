{ pkgs, ... }: {
  home.file = {

    # copy base configuration
    ".config/nvim" = builtins.fetchGit {
      url = "https://github.com/the-argus/nvim-config";
      ref = "master";
      rev = "";
    };
  };

  # copy variable profile stuff
  imports = [
    ./var
  ];
}
