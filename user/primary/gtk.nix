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

  gtkNix = let
    p = config.banner.palette;
  in
    with p;
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
        palette = let
          # use this set for both normal and highlight colors
          colors = {
            red = base09;
            yellow = base0A;
            green = base0B;
            cyan = base0C;
            blue = base0D;
            purple = base0E;
          };
        in {
          surface = {
            strongest = base00;
            strong = base00;
            moderate = base02;
            weak = base03;
            weakest = base03;
          };
          whites = let
            mkWhite = alpha: "${base05}${alpha}";
          in {
            strongest = mkWhite "FF";
            strong = mkWhite "DE";
            moderate = mkWhite "57";
            weak = mkWhite "24";
            weakest = mkWhite "0F";
          };
          blacks = let
            mkBlack = alpha: "${base00}${alpha}";
          in {
            strongest = mkBlack "FF";
            strong = mkBlack "DE";
            moderate = mkBlack "6B";
            weak = mkBlack "26";
            weakest = mkBlack "0F";
          };
          lightColors = colors;
          normalColors = colors;
          primaryAccent = highlight;
          secondaryAccent = hialt0;
        };
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
