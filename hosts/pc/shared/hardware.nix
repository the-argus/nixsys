{...}: {
  system.hardware = {
    usesWireless = false; # install and autostart nm-applet
    usesBluetooth = false; # install and autostart blueman applet
    usesMouse = true; # enables xmousepasteblock for middle click
    hasBattery = false; # battery widget in tiling WMs
    usesEthernet = true;
  };
}
