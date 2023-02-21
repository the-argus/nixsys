{
  pkgs,
  username,
  ...
}: {
  systemd.user.services.ntfy-recieve = {
    Unit = {
      Description = "Get notifications from from ntfy.sh to notify-send.";
      After = "graphical-session.target";
    };

    Service = {
      Type = "simple";
      User = username;
      ExecStart = "${pkgs.myPackages.ntfy-notify-send}/bin/ntfy-notify-send";
      RestartForceExitStatus = 11;
      RestartSec = 0;

      # disallow writing to /usr, /bin, /sbin, ...
      ProtectSystem = "yes";
      # more paranoid security settings
      NoNewPrivileges = "yes";
      ProtectKernelTunables = "yes";
      ProtectControlGroups = "yes";
      RestrictNamespaces = "yes";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
