{username}: {
  services.davfs2 = {
    enable = true;
    davUser = username;
    extraConfig = ''
      use_locks 0
    '';
  };
}
