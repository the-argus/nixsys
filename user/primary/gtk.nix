{
  pkgs,
  homeDirectory,
  gtk-nix,
  ...
}: let
  theme = pkgs.callPackage ./themes.nix {};
  gtk = theme.gtk;
in {
  imports = [ gtk-nix.homeManagerModule ];
  home.packages = [pkgs.dconf];
  home.file = {
    # xorg cursor
    ".icons/default/index.theme" = {
      text = ''
        [Icon Theme]
        Inherits=${gtk.cursorTheme.name}
      '';
    };
  };
  
  gtkNix.enable = true;

  gtk = {
    enable = true;

    font = theme.font.display;

    cursorTheme = gtk.cursorTheme;
   
    iconTheme = gtk.iconTheme;

    # theme = gtk.theme

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
