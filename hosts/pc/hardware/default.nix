{
  config,
  pkgs,
  lib,
  hostname,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./plymouth.nix
  ];

  /*
  nix.package = pkgs.nixVersions.nix_2_7;
  */
  nix.package = pkgs.nixFlakes;

  environment.etc = {
    # softdep isnt really necessary but i dont believe it hurts
    "vfio.conf" = {
      text = ''
        options vfio-pci ids=10de:1180,10de:0e0a
        softdep nvidia pre: vfio-pci
        softdep snd_hda_intel pre: vfio-pci
      '';
    };
    "modprobe.d/blacklist-nvidia-nouveau.conf" = {
      text = ''
        blacklist nouveau
        blacklist nvidiafb
        options nouveau modeset=0
      '';
    };
  };

  boot = {
    #kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = ["nordrand" "quiet" "systemd.show_status=0" "loglevel=4" "rd.systemd.show_status=auto" "rd.udev.log-priority=3" "rdblacklist=nouveau" "vfio-pci.ids=10de:1180,10de:0e0a"];
    # nouveau blacklist
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;

      # efi-only grub
      grub = {
        enable = false;
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

    initrd = {
      #enable = false;
      verbose = false;
      systemd.enable = true;
      services.swraid.enable = false;
    };
  };

  # desktops ------------------------------------------------------------------
  music.enable = true; # music production software and configuration

  virtualization = {
    enable = false;
    containers = {
      podman.enable = false;
      docker.enable = false;
    };
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = false;
    # greeters.mini = {
    #   enable = true;
    #   user = username;
    # };
  };

  services.greetd = {
    enable = false;
    settings = {
      terminal = {
        # only open the greeter on the first tty
        vt = 1;
      };
      default_session = {
        command = ''
          ${pkgs.cage}/bin/cage ${pkgs.greetd.gtkgreet}/bin/gtkgreet \
        '';
        # --sessions ${pkgs.xorg.xinit}/bin/startx,${pkgs.sway}/bin/sway \
        # --time \
        # --issue \
        # --remember \
        # --remember-session \
        # --asterisks \
        user = username;
      };
    };
  };

  services.pipewire.package =
    (import (pkgs.fetchgit {
      url = "https://github.com/K900/nixpkgs";
      rev = "092f4eb681a6aee6b50614eedac74629cb48db23";
      sha256 = "1vx4fn4x32m0q91776pww8b9zqlg28x732ghj47lcfgzqdhwbdh4";
    }) {system = "x86_64-linux";})
    .pipewire;

  # networking ----------------------------------------------------------------
  networking.interfaces.enp39s0.useDHCP = true;
  networking.hostName = hostname; # Define your hostname.
  networking.wireless.enable = false;

  services.openssh = {
    enable = false;
    PermitRootLogin = "no";
  };
  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJt9P8Vba+rp/5Rw/BmP1LcUGV03QlFaH8Wf6wKwqEuV i.mcfarlane2002@gmail.com"
  ];

  # display -------------------------------------------------------------------
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
    ];
    extraPackages32 = with pkgs.pkgsi686Linux;
      [libva libvdpau-va-gl vaapiVdpau]
      ++ lib.optionals config.services.pipewire.enable [pipewire];
  };
  hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

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
    virt-manager
  ];
}
