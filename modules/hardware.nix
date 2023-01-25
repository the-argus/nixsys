{lib, ...}: let
  # THIS MODULE IS ALSO IMPORTED BY HOME-MANAGER
  defaults = {
    usesWireless = true; # install and autostart nm-applet
    usesBluetooth = true; # install and autostart blueman applet
    usesMouse = false; # enables xmousepasteblock for middle click
    usesEthernet = false;
    hasBattery = true; # battery widget in tiling WMs
  };

  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) bool;
in {
  options.system = {
    minimal = mkEnableOption "Disables the installation of many packages.";
    hardware = {
    usesWireless = mkOption {
      type = bool;
      default = defaults.usesWireless;
      description = "Whether the system uses wireless internet and needs the corresponding utilities.";
    };
    usesBluetooth = mkOption {
      type = bool;
      default = defaults.usesBluetooth;
      description = "Whether the system has a bluetooth adapter and needs the corresponding utilities.";
    };
    usesMouse = mkOption {
      type = bool;
      default = defaults.usesMouse;
      description = "Whether or not you use a mouse with a middle click button.";
    };
    usesEthernet = mkOption {
      type = bool;
      default = defaults.usesEthernet;
      description = "Whether the system uses wired internet and needs the corresponding utilities.";
    };
    hasBattery = mkOption {
      type = bool;
      default = defaults.hasBattery;
      description = "Whether the system has a battery and needs charge to be displayed.";
    };
    };
  };
}
