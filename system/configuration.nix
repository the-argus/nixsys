# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  unstable,
  useMusl,
  username,
  settings,
  ...
}: {
  #choose what host is being used (laptop or pc)
  imports =
    [
      ../modules
    ]
    ++ settings.hardwareConfiguration;

  # kernel version
  # boot.kernelPackages = unstable.linuxPackages_latest;
  # boot.kernelPackages = unstable.linuxPackages_zen;
  boot.kernelPackages = lib.mkDefault unstable.linuxPackages_xanmod_latest;

  # PAM authentication for yubikey/solokey
  # line to add with mkOverride: "auth       required   pam_u2f.so"
  services.udev.extraRules = ''    ACTION!="add|change", GOTO="solokeys_end"
    # SoloKeys rule

    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a2ca", TAG+="uaccess"

    LABEL="solokeys_end"'';

  # line that might be necessary to add:
  # @include common-auth
  security.pam.u2f.enable = true;
  security.pam.services.login.text = pkgs.lib.mkDefault (pkgs.lib.mkBefore ''
    auth sufficient pam_u2f.so
  '');
  security.pam.services.sudo.text = pkgs.lib.mkDefault (pkgs.lib.mkBefore ''
    auth sufficient pam_u2f.so
  '');

  # enable nix flakes
  nix = {
    package = pkgs.nixFlakes;
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-old";
    # };
    settings = {
      extra-experimental-features = ["nix-command" "flakes"];
      substituters = ["https://webcord.cachix.org"];
      trusted-public-keys = ["webcord.cachix.org-1:l555jqOZGHd2C9+vS8ccdh8FhqnGe8L78QrHNn+EFEs="];
      builders = [
        "ssh://servers@rpmc.duckdns.org aarch64-linux,x86_64-linux"
      ];
    };

    # musl
    binaryCaches = [
      "https://cache.nixos.org/"
      # ] ++ (if useMusl then [
      "https://cache.allvm.org/"
    ]; # else [ ]);

    binaryCachePublicKeys = [
      # if useMusl then [
      "gravity.cs.illinois.edu-1:yymmNS/WMf0iTj2NnD0nrVV8cBOXM9ivAkEdO1Lro3U="
    ]; # else [ ];
  };

  # modules
  music.enable = true; # music production software and configuration
  virtualization.enable = true;
  virtualization.passthrough.enable = true;
  virtualization.passthrough.ovmfPackage = unstable.OVMFFull;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # console
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "jackaudio"
      "systemd-network"
      "networkmanager"
      "openrazer"
      "plugdev"
    ];
  };

  environment.pathsToLink = ["/share/zsh"];
  services.flatpak.enable = true;
  # xdg.portal = {
  #   enable = false;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal
  #   ];
  # };
  environment.systemPackages = with pkgs; [
    # tui applications
    ranger
    unstable.neovim
    htop
    lynx
    w3m

    # cli applications
    neofetch
    tmatrix
    cmatrix
    zip
    unzip
    wget
    curl
    ffmpeg
    direnv
    nix-direnv-flakes

    # util
    git
    home-manager
    pam_u2f
    polkit
    usbutils
    nix-index
    alsa-utils
    ix
    killall
    pciutils
    inetutils

    curlftpfs
    sshfs

    # build - essential
    gcc
    lld
    llvm
  ];

  system.stateVersion = "22.05";
}
