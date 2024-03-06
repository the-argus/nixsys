{
  config,
  pkgs,
  hostname,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./plymouth.nix
  ];
  services.printing.enable = true;
  services.avahi.enable = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  time.timeZone = "America/New_York";

  # dual booting with windows boot loader mounted on /efi
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = ["intel_iommu=on" "quiet" "systemd.show_status=0" "loglevel=4" "rd.systemd.show_status=auto" "rd.udev.log-priority=3"];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      # grub = {
      #   # enable = true;
      #   # device = "/dev/disk/by-uuid/444dd843-a3b1-4e59-9d47-c62cfab94d8b";
      #   useOSProber = true;
      # };
      systemd-boot = {
        enable = true;
      };
    };
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    swraid.enable = false;
  };

  # makes plymouth wait 5 seconds while playing
  # systemd.services.plymouth-quit.serviceConfig.ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 5";

  virtualization = {
    enable = false;
    containers = {
      docker.enable = false;
      podman.enable = true;
    };
  };

  # choose display manager
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.startx.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.emptty = {
    enable = true;
    configuration = {
      DEFAULT_USER = username;
      DBUS_LAUNCH = false;
    };
  };
  services.xserver.displayManager.ly = {
    enable = false;
    defaultUser = username;
    package = pkgs.myPackages.ly;
    extraConfig = ''
      animate = true
      animation = 0
    '';
  };
  # environment.etc.issue = {
  #   source = pkgs.writeText "issue" ''
  #     testing..
  #   '';
  # };

  services.greetd = {
    enable = false;
    settings = {
      terminal = {
        # only open the greeter on the first tty
        vt = 1;
      };
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --sessions ${pkgs.xorg.xinit}/bin/startx,${pkgs.sway}/bin/sway \
          --time \
          --issue \
          --remember \
          --remember-session \
          --asterisks \
        '';
        user = username;
      };
    };
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

  # hardware ------------------------------------------------------------------
  hardware.openrazer.enable = true;
  hardware.ckb-next.enable = true;

  # networking-----------------------------------------------------------------
  networking.hostName = hostname;
  networking.interfaces."wlp0s20f3" = {useDHCP = false;};
  # networking.wireless.interfaces = ["wlp0s20f3"];
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
    razergenie
  ];
}
