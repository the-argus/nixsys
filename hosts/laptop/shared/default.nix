{...}: {
  imports = [
    ./desktops.nix
    ./gaming.nix
  ];

  system.minimal = false;

  system.hardware = {
    usesWireless = true; # install and autostart nm-applet
    usesBluetooth = true; # install and autostart blueman applet
    usesMouse = false; # enables xmousepasteblock for middle click
    hasBattery = true; # battery widget in tiling WMs
    usesEthernet = false;
  };
}
