{
  pkgs,
  lib,
  config,
  ...
}: let
  optionalList = lib.lists.optionals;

  execShell = path: "${path} &";
  execI3 = path: "${path}";
in rec {
  startxAliases = let
    mkAlias = wmName: (lib.optionalAttrs
      config.desktops.${wmName}.enable
      {"${wmName}-start" = "startx $HOME/.xinitrc ${wmName}";});
  in
    (mkAlias "i3gaps")
    // (mkAlias "qtile")
    // (mkAlias "ratpoison")
    // (mkAlias "awesome");
  bluetoothAutostart = [
    # laptop has bluetooth and wireless
    "${pkgs.blueman}/bin/blueman-applet"
  ];

  wirelessAutostart = [
    "${pkgs.networkmanagerapplet}/bin/nm-applet"
  ];

  mouseAutostart = [
    # i use a mouse on my pc, so theres middleclick
    "${pkgs.xmousepasteblock}/bin/xmousepasteblock"
  ];

  mkAutoStart = {
    isI3 ? false,
    picomConfigLocation ? "~/.config/picom/picom.conf",
  }: let
    execFunc =
      if isI3
      then execI3
      else execShell;

    picomPkg = pkgs.myPackages.picom;
  in
    map execFunc ([
        "${pkgs.dunst}/bin/dunst"
        "${pkgs.xfce.xfce4-clipman-plugin}/bin/xfce4-clipman"
        "${pkgs.xclip}/bin/xclip"
        "${picomPkg}/bin/picom --config ${picomConfigLocation} > ~/picom.log 2>&1"

        # restore feh wallpaper
        "$HOME/.fehbg"
      ]
      ++ (optionalList config.system.hardware.usesWireless wirelessAutostart)
      ++ (optionalList config.system.hardware.usesBluetooth bluetoothAutostart)
      ++ (optionalList config.system.hardware.usesMouse mouseAutostart));
}
