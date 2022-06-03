{ pkgs, ... }: {
  home.file =
    let
      devicons_repo = builtins.fetchGit {
        url = "https://github.com/alexanderjeurissen/ranger_devicons";
        ref = "main";
        rev = "49fe4753c89615a32f14b2f4c78bbd02ee76be3c";
      };
    in
    {
      ".config/ranger" = {
        source = ./config;
        recursive = true;
      };
      ".config/ranger/plugins/ranger_devicons" = "${devicons_repo}";
    };
}
