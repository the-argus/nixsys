{pkgs, ...}: {
  home.file = {
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };

  xdg.desktopEntries = let
    hide = exec: {
      "${exec}" = {
        noDisplay = true;
        exec = "${exec}";
        name = "${exec}";
      };
    };

    mpvEntry = exec: {
      noDisplay = true;
      exec = "${exec} --player-operation-mode=pseudo-gui -- %U";
      name = "${exec} Media Player";
      mimeType = ["application/ogg" "application/x-ogg" "application/mxf" "application/sdp" "application/smil" "application/x-smil" "application/streamingmedia" "application/x-streamingmedia" "application/vnd.rn-realmedia" "application/vnd.rn-realmedia-vbr" "audio/aac" "audio/x-aac" "audio/vnd.dolby.heaac.1" "audio/vnd.dolby.heaac.2" "audio/aiff" "audio/x-aiff" "audio/m4a" "audio/x-m4a" "application/x-extension-m4a" "audio/mp1" "audio/x-mp1" "audio/mp2" "audio/x-mp2" "audio/mp3" "audio/x-mp3" "audio/mpeg" "audio/mpeg2" "audio/mpeg3" "audio/mpegurl" "audio/x-mpegurl" "audio/mpg" "audio/x-mpg" "audio/rn-mpeg" "audio/musepack" "audio/x-musepack" "audio/ogg" "audio/scpls" "audio/x-scpls" "audio/vnd.rn-realaudio" "audio/wav" "audio/x-pn-wav" "audio/x-pn-windows-pcm" "audio/x-realaudio" "audio/x-pn-realaudio" "audio/x-ms-wma" "audio/x-pls" "audio/x-wav" "video/mpeg" "video/x-mpeg2" "video/x-mpeg3" "video/mp4v-es" "video/x-m4v" "video/mp4" "application/x-extension-mp4" "video/divx" "video/vnd.divx" "video/msvideo" "video/x-msvideo" "video/ogg" "video/quicktime" "video/vnd.rn-realvideo" "video/x-ms-afs" "video/x-ms-asf" "audio/x-ms-asf" "application/vnd.ms-asf" "video/x-ms-wmv" "video/x-ms-wmx" "video/x-ms-wvxvideo" "video/x-avi" "video/avi" "video/x-flic" "video/fli" "video/x-flc" "video/flv" "video/x-flv" "video/x-theora" "video/x-theora+ogg" "video/x-matroska" "video/mkv" "audio/x-matroska" "application/x-matroska" "video/webm" "audio/webm" "audio/vorbis" "audio/x-vorbis" "audio/x-vorbis+ogg" "video/x-ogm" "video/x-ogm+ogg" "application/x-ogm" "application/x-ogm-audio" "application/x-ogm-video" "application/x-shorten" "audio/x-shorten" "audio/x-ape" "audio/x-wavpack" "audio/x-tta" "audio/AMR" "audio/ac3" "audio/eac3" "audio/amr-wb" "video/mp2t" "audio/flac" "audio/mp4" "application/x-mpegurl" "video/vnd.mpegurl" "application/vnd.apple.mpegurl" "audio/x-pn-au" "video/3gp" "video/3gpp" "video/3gpp2" "audio/3gpp" "audio/3gpp2" "video/dv" "audio/dv" "audio/opus" "audio/vnd.dts" "audio/vnd.dts.hd" "audio/x-adpcm" "application/x-cue" "audio/m3u"];
      categories = ["AudioVideo" "Audio" "Video" "Player" "TV"];
      icon = "mpv";
      comment = "Play movies and songs";
      genericName = "Multimedia player";
    };
  in
    {
      # discord = {
      #   name = "Discord (Performance)";
      #   comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
      #   genericName = "Internet Messenger";
      #   exec = ''flatpak run com.discordapp.Discord --command="discord --no-sandbox --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization"'';
      #   icon = "discord";
      #   type = "Application";
      #   categories = [ "Network" "InstantMessaging" ];
      # };
      # webcord = {
      #   name = "Discord";
      #   comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
      #   genericName = "Internet Messenger";
      #   exec = ''webcord'';
      #   icon = "discord";
      #   type = "Application";
      #   categories = [ "Network" "InstantMessaging" ];
      # };
      webcord = let
        theme = (pkgs.callPackage ../themes.nix {}).discordTheme;
      in {
        name = "Webcord";
        exec = ''webcord --add-css-theme=${theme}/THEME.theme.css'';
        icon = "discord";
      };

      pavucontrol = {
        name = "Pavucontrol";
        exec = "pavucontrol";
        icon = "multimedia-volume-control";
        type = "Application";
      };

      pcmanfm = {
        name = "File Manager";
        exec = "pcmanfm";
        icon = "system-file-manager";
        type = "Application";
      };

      nvim = {
        name = "Neovim";
        exec = "nvim %F";
        terminal = true;
        mimeType = ["text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++"];
        categories = ["Utility" "TextEditor"];
        comment = "Edit text files";
        genericName = "Text Editor";
        icon = "nvim";
        type = "Application";
      };

      mpv = mpvEntry "mpv";
      umpv = mpvEntry "umpv";

      ranger = {
        name = "ranger";
        type = "Application";
        noDisplay = true;
        terminal = true;
        exec = "\\$TERM -e ranger %F";
        comment = "Manage and explore files";
        mimeType = ["inode/directory"];
      };

      # hide programs I don't launch from rofi
    }
    // hide "htop"
    // hide "compton"
    // hide "xfce4-clipman"
    // hide "xfce4-clipman-settings"
    // hide "pcmanfm-desktop-pref"
    // hide "winetricks"
    // hide "cups"
    // hide "picom"
    // hide "nm-connection-editor";
}
