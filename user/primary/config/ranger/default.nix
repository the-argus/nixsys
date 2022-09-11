{pkgs, ...}: {
  home.file = {
    ".config/ranger" = {
      source = ./config;
      recursive = true;
    };

    ".config/ranger/plugins/ranger_devicons" = {
      source = pkgs.fetchgit {
        url = "https://github.com/alexanderjeurissen/ranger_devicons";
        sha256 = "1kgzv9mqsqzbpjrj3qi8vkha7vij2qsmdnjwl547pnf04hbdhgk1";
        rev = "49fe4753c89615a32f14b2f4c78bbd02ee76be3c";
      };
      recursive = true;
    };
  };
}
