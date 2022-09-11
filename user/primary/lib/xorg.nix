{
  pkgs,
  settings,
  picomConfigLocation,
  ...
}: let
  optional = condition: str: (
    if condition
    then str
    else ""
  );
in {
  bluetoothAutostart = ''
    # laptop has bluetooth and wireless
    ${pkgs.blueman}/bin/blueman-applet &
  '';

  wirelessAutostart = ''
    ${pkgs.networkmanagerapplet}/bin/nm-applet &
  '';

  mouseAutostart = ''
    # i use a mouse on my pc, so theres middleclick
    ${pkgs.xmousepasteblock}/bin/xmousepasteblock &
  '';

  autoStart = [
    "${pkgs.dunst}/bin/dunst &"
    "${pkgs.xfce.xfce4-clipman-plugin}/bin/xfce4-clipman &"
    "${pkgs.xclip}/bin/xclip &"
    "picom --config ${picomConfigLocation} &"

    # restore feh wallpaper
    "$HOME/.fehbg"
    "${optional settings.usesWireless wirelessAutostart}"
    "${optional settings.usesBluetooth bluetoothAutostart}"
    "${optional settings.usesMouse mouseAutostart}"
  ];
}
