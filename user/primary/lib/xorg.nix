{
  pkgs,
  lib,
  settings,
  ...
}: let
  optional = condition: str: (
    if condition
    then str
    else ""
  );
  optionalList = lib.lists.optional;

  execShell = path: "${path} &";
  execI3 = path: "--no-startup-id ${path}";
in rec {
  bluetoothAutostart = {execFunc ? execShell}:
    map execFunc [
      # laptop has bluetooth and wireless
      "${pkgs.blueman}/bin/blueman-applet"
    ];

  wirelessAutostart = {execFunc ? execShell}:
    map execFunc [
      "${pkgs.networkmanagerapplet}/bin/nm-applet"
    ];

  mouseAutostart = {execFunc ? execShell}:
    map execFunc [
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
  in
    map execFunc [
      "${pkgs.dunst}/bin/dunst"
      "${pkgs.xfce.xfce4-clipman-plugin}/bin/xfce4-clipman"
      "${pkgs.xclip}/bin/xclip"
      "picom --config ${picomConfigLocation}"

      # restore feh wallpaper
      "$HOME/.fehbg"
    ]
    ++ (optionalList settings.usesWireless (wirelessAutostart {
      inherit execFunc;
    }))
    ++ (optionalList settings.usesBluetooth (bluetoothAutostart {
      inherit execFunc;
    }))
    ++ (optionalList settings.usesMouse (mouseAutostart {
      inherit execFunc;
    }));
}
