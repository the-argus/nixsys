{ pkgs, ... }:
{
    gtk = {
        enable = true;
        
        # font = "FiraCode Mono Nerd Font 11";
        
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
            name = "Juno";
            package = pkgs.graphite-gtk-theme;
        };

        gtk3 = {
            bookmarks = [
                "file:///home/argus/Desktop/programming"
            ];
        };
    };
}
