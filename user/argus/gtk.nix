{ pkgs, ... }:
{
    gtk = {
        enable = true;
        
        # font = "FiraCode Mono Nerd Font 11";
        
        cursorTheme = {
            name = "Numix";
            package = pkgs.numix-cursor-theme;
            size = 16;
        };
        
        iconTheme = {
            name = "Paper-Mono-Dark";
            package = pkgs.paper-icon-theme;
        };

        theme = {
            name = "Paper";
            package = pkgs.paper-gtk-theme;
        };

        gtk3 = {
            bookmarks = [
                "file:///home/argus/Desktop/programming"
            ];
        };
    };
}
