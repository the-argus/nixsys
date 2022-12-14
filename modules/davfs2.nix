{username, ...}: {
  services.davfs2 = {
    enable = true;
    davUser = username;
    extraConfig = ''
      use_locks 0
    '';
  };
  # desired output : https://nextcloud.rprox.duckdns.org/nextcloud/remote.php/dav/files/argus/ /home/argus/Nextcloud davfs user,rw,auto 0 0
  fileSystems."/home/${username}/Nextcloud" = {
    device = "https://nextcloud.rprox.duckdns.org/nextcloud/remote.php/dav/files/${username}";
    fsType = "davfs";
    options = [
      "user"
      "rw"
      "noauto" # I'll mount it manually
    ];
  };
}
