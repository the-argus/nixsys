# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  #choose what host is being used (laptop or pc) ------------------------------
  imports =
    [
      ../hosts/laptop
    ];

  # everything that follows is host-agnostic configuration --------------------

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # PAM authentication for yubikey/solokey
  # line to add with mkOverride: "auth       required   pam_u2f.so"
  security.pam.services.login.text = pkgs.lib.mkDefault (pkgs.lib.mkAfter "# testing");

  # enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

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
      "systemd-network"
      "networkmanager"
    ];
  };

  environment.pathsToLink = [ "/share/zsh" ];
  
  services.flatpak.enable = true;
  environment.systemPackages = with pkgs; [
    # tui applications
    ranger
    neovim
    htop

    # cli applications
    neofetch
    tmatrix cmatrix
    zip unzip
    wget curl
    ffmpeg

    # util
    git
    home-manager
    pam_u2f
    polkit
    usbutils
  ];

  system.stateVersion = "22.11"; # Did you read the comment?
}

