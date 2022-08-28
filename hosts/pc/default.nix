{ config, pkgs, plymouth, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  # Use the GRUB 2 boot loader.
  boot = {
    kernelParams = [ "nordrand" "quiet" "systemd.show_status=0" "loglevel=4" "rd.systemd.show_status=auto" "rd.udev.log-priority=3" ];
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
	canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;

      # efi-only grub
      grub = {
        enable = false;
        version = 2;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        extraEntries = ''
	  menuentry "Reboot" {
	  	  reboot
	  }
	  menuentry "Poweroff" {
		  halt
	  }
        '';
      };
    };

    initrd.verbose = false;
    plymouth = {
      enable = true;
      themePackages = [ pkgs.plymouth-themes-package ];
      theme = plymouth.themeName;
    };
  };

  # makes plymouth wait 5 seconds while playing
  # systemd.services.plymouth-quit.serviceConfig.ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 5";
  
  # desktops ------------------------------------------------------------------  
  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";
  desktops = {
    enable = true;
    # sway.enable = true;
    # awesome.enable = true;
    # ratpoison.enable = true;
    qtile.enable = true;
    # i3gaps.enable = true;
    gnome.enable = true;
    # plasma.enable = true;
  };
  
  services.xserver.displayManager.startx.enable = true;
  
  # networking ----------------------------------------------------------------
  networking.hostName = "mutant"; # Define your hostname.
  networking.wireless.enable = false;

  # display -------------------------------------------------------------------
  hardware.opengl = {
    extraPackages = with pkgs; [
    ];
  };

  #	services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver = {
    videoDriver = "amdgpu";

    config = ''
      Section "ServerFlags"
          Option      "AutoAddDevices"         "false"
      EndSection
    '';
  };
  # hardware ------------------------------------------------------------------
  hardware.openrazer.enable = true;

  environment.systemPackages = with pkgs; [
	razergenie
  ];

  system.stateVersion = "22.05"; # Did you read the comment?
}
