{
  pkgs,
  homeDirectory,
  gtk-nix,
  config,
  ...
}: let
  gtk = config.system.theme.gtk;
in {
  imports = [gtk-nix.homeManagerModule];
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

  gtkNix =
    pkgs.lib.mkIf (
      if (builtins.typeOf gtk.theme == "string")
      then (gtk.theme == "gtkNix")
      else false
    ) {
      enable = true;
      configuration = {
        radius = "8px";
        disabled-opacity = 0.6;
      };
      palette = config.banner.palette;
    };

  gtk = {
    enable = true;

    font = config.system.theme.font.display;

    cursorTheme = gtk.cursorTheme;

    iconTheme = gtk.iconTheme;

    theme =
      pkgs.lib.mkIf (
        if (builtins.typeOf gtk.theme == "string")
        then
          (
            if gtk.theme == "gtkNix"
            then false
            else abort "You set gtk.theme to a string, but its not gtkTheme"
          )
        else true
      )
      gtk.theme;

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
