{ pkgs,  homeDirectory, ... }:

let
  theme = (pkgs.callPackage ../themes.nix {}).gtk;
in
{
  home.packages = [pkgs.dconf];
  home.file = {
    # xorg cursor
    ".icons/default/index.theme" = {
      text = ''
        [Icon Theme]
        Inherits=${theme.cursorTheme.name}
      '';
    };
  };
  gtk =
    {
      enable = true;
      
      font = theme.font;

      cursorTheme = theme.cursorTheme;

      iconTheme = theme.iconTheme;
      
      # the system theme's gtk theme, lol
      theme = theme.theme;

      gtk3 = {
        bookmarks = [
          "file://${homeDirectory}/Downloads"
          "file://${homeDirectory}/Programming"
          "file://${homeDirectory}/Video"
          "file://${homeDirectory}/Music"
          "file://${homeDirectory}/Screenshots"
          "file://${homeDirectory}/Wallpapers"
        ];
      };
    };
}
