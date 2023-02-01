{
  pkgs,
  username,
  ...
}: let
  blugonConfig = pkgs.writeText "blugon-config" ''
    [main]
    readcurrent = False
    interval = 120
    backend = scg
    wait_for_x = False
    fade = False

    [current]
    min_temp = 1.0
    max_temp = 10000.0

    [wait_for_x]
    sleep_after_failed_startup = 0.1
    sleep_after_losing_x = 120.0

    [fade]
    steps = 10
    duration = 3.0

    [tty]
    color0 = 000000
    color1 = aa0000
    color2 = 00aa00
    color3 = aa5500
    color4 = 0000aa
    color5 = aa00aa
    color6 = 00aaaa
    color7 = aaaaaa
    color8 = 555555
    color9 = ff5555
    color10 = 55ff55
    color11 = ffff55
    color12 = 5555ff
    color13 = ff55ff
    color14 = 55ffff
    color15 = ffffff
  '';
  myBlugon = pkgs.blugon.overrideAttrs (_: {
    postInstall = ''
      # this should be in postPatch but thats used by the original pkg
      rm -rf $out/lib/systemd
      rm -rf $out/share/systemd

      mkdir $out/share/blugon/myconfig
      ln -sf $out/share/blugon/configs/default/gamma $out/share/blugon/myconfig/gamma
      ln -sf ${blugonConfig} $out/share/blugon/myconfig/config

      ${pkgs.coreutils-full}/bin/chmod +wr $out/bin/blugon
      sed -i "s|CONFIG_FILE_CURRENT = CONFIG_DIR + 'current'|CONFIG_FILE_CURRENT = '\/home\/${username}\/.cache\/blugon-current'|g" $out/bin/blugon
    '';
  });
in {
  home.packages = with pkgs; [
    myBlugon
  ];
  systemd.user.services.blugon = {
    Unit = {
      Description = "Blue Light Filter";
      Documentation = "man:blugon(1)";
      After = "graphical-session.target";
    };

    Service = {
      Type = "simple";
      ExecStart = "${myBlugon}/bin/blugon --waitforx --configdir=${myBlugon}/share/blugon/myconfig";
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
