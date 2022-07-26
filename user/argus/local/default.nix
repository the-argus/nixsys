{ ... }: {
  home.file = {
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };

  xdg.desktopEntries =
    let

      hide = exec: {
        "${exec}" = {
          noDisplay = true;
          exec = "${exec}";
          name = "${exec}";
        };
      };
    in
    {
      discord = {
        name = "Discord (Performance)";
        comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
        genericName = "Internet Messenger";
        exec = ''flatpak run com.discordapp.Discord --command="discord --no-sandbox --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization"'';
        icon = "discord";
        type = "Application";
        categories = [ "Network" "InstantMessaging" ];
      };

      pavucontrol = {
        name = "Pavucontrol";
        exec = "pavucontrol";
        icon = "multimedia-volume-control";
      };

      pcmanfm = {
        name = "PCManFM";
        exec = "pcmanfm";
        icon = "system-file-manager";
      };

      nvim = {
        name = "Neovim";
        exec = "nvim %F";
        terminal = true;
        mimeType = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
        categories = [ "Utility" "TextEditor" ];
        comment = "Edit text files";
        genericName = "Text Editor";
        icon = "nvim";
      };

      # hide programs I don't launch from rofi
    } // hide "htop"
    // hide "compton"
    // hide "xfce4-clipman"
    // hide "xfce4-clipman-settings"
    // hide "pcmanfm-desktop-pref"
    // hide "winetricks"
    // hide "wine"
    // hide "mpv"
    // hide "umpv"
    // hide "cups"
    // hide "picom"
    // hide "ranger"
    // hide "nm-connection-editor";
}
