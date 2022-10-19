{
  pkgs,
  lib,
  settings,
  picom,
  ...
}: let
  optional = condition: str: (
    if condition
    then str
    else ""
  );
  optionalList = lib.lists.optionals;

  execShell = path: "${path} &";
  execI3 = path: "${path}";
in rec {
  startxAliases = {
    i3 = "startx $HOME/.xinitrc i3";
    qtile = "startx $HOME/.xinitrc qtile";
  };
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

    picomPkg =
      import ../../packages/picom.nix
      {
        inherit pkgs picom;
      };
  in
    map execFunc ([
        "${pkgs.dunst}/bin/dunst"
        "${pkgs.xfce.xfce4-clipman-plugin}/bin/xfce4-clipman"
        "${pkgs.xclip}/bin/xclip"
        "${picomPkg}/bin/picom --config ${picomConfigLocation} > ~/picom.log 2>&1"

        # restore feh wallpaper
        "$HOME/.fehbg"
      ]
      ++ (optionalList settings.usesWireless wirelessAutostart)
      ++ (optionalList settings.usesBluetooth bluetoothAutostart)
      ++ (optionalList settings.usesMouse mouseAutostart));
}
