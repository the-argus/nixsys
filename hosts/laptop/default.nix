{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  # dual booting with windows boot loader mounted on /efi
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    grub = {
      useOSProber = true;
    };
    systemd-boot = {
      enable = true;
    };
  };

  desktops = {
    enable = true;
    sway.enable = true;
    awesome.enable = true;
    ratpoison.enable = true;
  };
  # choose display manager
  services.xserver.displayManager.startx.enable = true;

  # display -------------------------------------------------------------------
  hardware.opengl = {
    extraPackages = with pkgs; [
      intel-media-driver
      libGL
      libGLU
      python310Packages.glad
      python310Packages.glfw
      freeglut
    ];
    extraPackages32 = with pkgs.pkgsi686Linux;
      [ libva vaapiIntel libvdpau-va-gl vaapiVdpau ]
      ++ lib.optionals config.services.pipewire.enable [ pipewire ];
  };

  #	services.xserver.videoDrivers = [ "intel" ];
  services.xserver = {
    videoDriver = "intel";

    config = ''
      Section "ServerFlags"
          Option      "AutoAddDevices"         "false"
      EndSection
    '';
  };

  # networking-----------------------------------------------------------------
  networking.hostName = "evil";
  networking.interfaces."wlp0s20f3" = { useDHCP = true; };
  networking.wireless.interfaces = [ "wlp0s20f3" ];
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  # networking.wireless.enable = true;

  # iphone tethering
  services.usbmuxd.enable = true;

  # bluetooth------------------------------------------------------------------
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # packages-------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    bluez
    bluez-alsa
    bluez-tools
    networkmanagerapplet
    libimobiledevice
  ];
}
