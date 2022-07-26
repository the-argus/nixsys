{ ... }: {
  home.file = {
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };

  xdg.desktopEntries = {
    discord = {
      name = "Discord (Performance)";
      comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
      genericName = "Internet Messenger";
      exec = ''flatpak run com.discordapp.Discord --command="discord --no-sandbox --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization"'';
      icon = "discord";
      type = "Application";
      categories = [ "Network" "InstantMessaging" ];
    };
  };
}
