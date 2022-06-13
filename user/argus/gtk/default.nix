{ pkgs, kanagawa-gtk, ... }:
{
  gtk =
    let
      kanagawa = import ./themes/kanagawa.nix {
        inherit kanagawa-gtk;
        stdenv = pkgs.stdenv;
        gtk-engine-murrine = pkgs.gtk-engine-murrine;
      };

      paperIcons = {
        name = "Paper-Mono-Dark";
        package = pkgs.paper-icon-theme;
      };

      rosePineIcons = {
        name = "rose-pine-icons";
        package = pkgs.rose-pine-gtk-theme;
      };

      rosePineTheme = {
        name = "rose-pine-gtk";
        package = pkgs.rose-pine-gtk-theme;
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

      iconTheme = rosePineIcons;

      theme = rosePineTheme;

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
