{
  pkgs,
  homeDirectory,
  gtk-nix,
  ...
}: let
  theme = pkgs.callPackage ./themes.nix {};
  gtk = theme.gtk;
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

  gtkNix = let
    p = theme.scheme;
  in
    pkgs.lib.mkIf (
      if (builtins.typeOf gtk.theme == "string")
      then (gtk.theme == "gtkNix")
      else false
    ) {
      enable = true;
      configuration = {
        spacing-small = "0.5em";
        spacing-medium = "0.8em";
        spacing-large = "1.2em";
        radius = "8px";
      };
      palette = let
        # use this set for both normal and highlight colors
        colors = {
          inherit (p) red yellow green cyan blue;
          purple = p.magenta;
          # neither orange nor pink are set here, i dont think they show up in the theme anyways
        };
      in {
        surface = {
          strongest = p.bg;
          strong = p.altfg;
          moderate = p.altbg2;
          weak = p.altbg3;
          weakest = p.altbg3;
        };
        whites = let
          # white colors all default to pure white
          mkWhite = alpha: "${p.white}${alpha}";
        in {
          strongest = mkWhite "FF";
          strong = mkWhite "DE";
          moderate = mkWhite "57";
          weak = mkWhite "24";
          weakest = mkWhite "0F";
        };
        blacks = let
          # white colors all default to pure white
          mkBlack = alpha: "${p.black}${alpha}";
        in {
          strongest = mkBlack "FF";
          strong = mkBlack "DE";
          moderate = mkBlack "6B";
          weak = mkBlack "26";
          weakest = mkBlack "0F";
        };
        lightColors = colors;
        normalColors = colors;
        primaryAccent = p.hi1;
        secondaryAccent = p.hi2;
      };
    };

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
