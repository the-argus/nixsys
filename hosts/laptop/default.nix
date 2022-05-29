{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # networking-----------------------------------------------------------------
  networking.hostName = "evil";
  networking.interfaces."wlp0s20f3" = { useDHCP = true; };
  networking.wireless.interfaces = [ "wlp0s20f3" ];
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  # networking.wireless.enable = true;

  # bluetooth------------------------------------------------------------------
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    bluez
    bluez-alsa
    bluez-tools
  ];
}
