{ pkgs, kanagawa-gtk, ... }:
{
  gtk =
    let
      theme = import ./themes/kanagawa.nix {
        inherit kanagawa-gtk;
        stdenv = pkgs.stdenv;
        gtk-engine-murrine = pkgs.gtk-engine-murrine;
      };
    in
    {
      enable = true;

      font = {
        name = "Fira Code";
        size = 11;
        package = pkgs.fira-code;
      };

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
        size = 16;
      };

      iconTheme = {
        name = "Paper-Mono-Dark";
        package = pkgs.paper-icon-theme;
      };

      theme = {
        name = theme.name;
        package = theme.pkg;
      };

      gtk3 = {
        bookmarks = [
          "file:///home/argus/Downloads"
          "file:///home/argus/Programming"
          "file:///home/argus/Video"
          "file:///home/argus/Music"
          "file:///home/argus/Screenshots"
          "file:///home/argus/Wallpapers"
        ];
      };
    };
}
