# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  config,
  username,
  settings,
  ...
}: {
  #choose what host is being used (laptop or pc)
  imports = [
    ../modules
  ];

  environment.variables.EDITOR = "nvim";
  services.dbus.implementation = "broker";

  # kernel version
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;

  # PAM authentication for yubikey/solokey
  # line to add with mkOverride: "auth       required   pam_u2f.so"
  services.udev.extraRules = ''    ACTION!="add|change", GOTO="solokeys_end"
    # SoloKeys rule

    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a2ca", TAG+="uaccess"

    LABEL="solokeys_end"'';

  # line that might be necessary to add:
  # @include common-auth
  security.pam.u2f.enable = true;
  security.pam.services.login.text = lib.mkDefault (lib.mkBefore ''
    auth sufficient pam_u2f.so
  '');
  security.pam.services.sudo.text = pkgs.lib.mkDefault (pkgs.lib.mkBefore ''
    auth sufficient pam_u2f.so
  '');

  environment.etc.issue.source =
    lib.mkForce (pkgs.writeText "issue"
      (import ../assets/issues/braille-large-welcome.nix {inherit username;}));

  # enable nix flakes
  nix = let
    override = lib.attrsets.recursiveUpdate;
    defaultSettings = {
      package = lib.mkDefault pkgs.nixVersions.stable;
      # package =  pkgs.nixVersions.nix_2_7;
      # gc = {
      #   automatic = true;
      #   dates = "weekly";
      #   options = "--delete-old";
      # };
      settings = {
        extra-experimental-features = ["nix-command" "flakes"];
        substituters = [
          "https://cache.nixos.org/"
          # ] ++ (if useMusl then [
          # "https://cache.allvm.org/"
        ];
        trusted-public-keys = [
          # if useMusl then [
          # "gravity.cs.illinois.edu-1:yymmNS/WMf0iTj2NnD0nrVV8cBOXM9ivAkEdO1Lro3U="
        ];
        auto-optimise-store = true;
      };
    };
  in
    override defaultSettings (settings.nix or {});

  # modules
  virtualization = {
    enable = lib.mkDefault false;
    firmware.ovmfPackage = pkgs.OVMFFull;
  };

  # Set your time zone.
  time.timeZone = lib.mkDefault "America/New_York";

  documentation = {
    info.enable = false;
    dev.enable = false;
    nixos.enable = false;
  };
  # this line is hardcoded to be green
  # services.getty.greetingLine = "Welcome, ${username}.";

  # console
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true;
  };

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.bash;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = [
      "davfs2"
      "wheel"
      "video"
      "audio"
      "jackaudio"
      "systemd-network"
      "networkmanager"
      "openrazer"
      "plugdev"
      "libvirtd"
    ];
  };

  environment.pathsToLink = ["/share/zsh"];
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };

  # services.mullvad-vpn.enable = true;
  networking.firewall.checkReversePath = "loose";
  networking.wireguard.enable = true;

  environment.systemPackages = with pkgs;
    [
      # tui applications
      (lib.meta.lowPrio vim)
      htop

      # cli applications
      zip
      unzip
      wget
      curl
      ffmpeg
      # mullvad-vpn

      # util
      git
      home-manager
      pam_u2f
      polkit
      usbutils
      alsa-utils
      killall
      pciutils
      inetutils
      file

      # build - essential
      gcc
      lld
    ]
    ++ (lib.lists.optionals (!config.system.minimal) [
      # sshfs
      # ntfs3g

      # cli applications
      neofetch
      tmatrix
      cmatrix
    ]);

  system.stateVersion = "22.11";
}
