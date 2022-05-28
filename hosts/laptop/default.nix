{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "evil";
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
}
