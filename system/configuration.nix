# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, hardware, ... }:

{
  #choose what host is being used (laptop or pc)
  imports = [
    ../modules
  ] ++ 
      (if hardware == "laptop" then [../hosts/laptop] else []) ++
      (if hardware == "pc" then [../hosts/pc] else []);

  # kernel version
  boot.kernelPackages = unstable.linuxPackages_latest;

  # PAM authentication for yubikey/solokey
  # line to add with mkOverride: "auth       required   pam_u2f.so"
  services.udev.extraRules = ''ACTION!="add|change", GOTO="solokeys_end"
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
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  
  # modules
  music.enable = true; # music production software and configuration
  virtualization.enable = true;
  virtualization.passthrough.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.argus = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "jackaudio"
      "systemd-network"
      "networkmanager"
    ];
  };

  environment.pathsToLink = [ "/share/zsh" ];

  services.flatpak.enable = true;
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

    # util
    git
    home-manager
    pam_u2f
    polkit
    usbutils
    nix-index
    alsa-utils
    ix

    # essential
    gcc
    lld llvm
  ];

  system.stateVersion = "22.05";
}

