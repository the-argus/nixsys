{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "evil";
  networking.interfaces."wlp0s20f3" = { useDHCP = true; };
  networking.wireless.interfaces = [ "wlp0s20f3" ];
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  # networking.wireless.enable = true;
}
