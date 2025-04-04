{
  config,
  pkgs,
  hostname,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  # dual booting with windows boot loader mounted on /efi
  boot = {
    kernelParams = ["quiet" "systemd.show_status=0" "loglevel=4" "rd.systemd.show_status=auto" "rd.udev.log-priority=3"];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      grub = {
        #   # enable = true;
        devices = ["/dev/disk/by-label/WINBOOT"];
        useOSProber = true;
      };
      systemd-boot = {
        enable = true;
      };
    };
    initrd.verbose = false;
  };

  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";
  desktops = {
    enable = true;
    # sway.enable = true;
    # awesome.enable = true;
    # ratpoison.enable = true;
    qtile.enable = false;
    i3gaps.enable = false;
    gnome.enable = true;
    # plasma.enable = true;
  };
  # choose display manager
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.startx.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.ly = {
  #   enable = true;
  #   defaultUsers = username;
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

  # display -------------------------------------------------------------------
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

  # networking-----------------------------------------------------------------
  networking.hostName = hostname;
  networking.interfaces."wlp0s20f3" = {useDHCP = false;};
  networking.wireless.interfaces = ["wlp0s20f3"];
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
    libimobiledevice
    razergenie
  ];
}
# } //
# (if useFlags then {
#   nixpkgs.config.localSystem = {
#     gcc.arch = "tigerlake";
#     gcc.tune = "tigerlake";
#   };
# } else { })

