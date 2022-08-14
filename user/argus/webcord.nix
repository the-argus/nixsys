{ pkgs, ... }:
{
  home.file = {
    ".config/WebCord/Themes" = {
      src = pkgs.fetchgit {
        url = "https://github.com/DiscordStyles/SoftX";
        rev = "ef11558a47b3ce6b590e8d8ea47e34fc1de32d9c";
        sha256 = "1b8k640jymd6hcqr9930i6m98ihxcya18biaazsp5hcvkxh25ac6";
      };
      recursive = true;
    };
  };
}
