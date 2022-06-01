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
  time.timeZone = "America/Anchorage";

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

  nixpkgs.config.allowUnfree = true;
  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    # gui applications---------
    sxiv
    gnome.gnome-calculator
    firefox
    kitty

    discord
    keepassxc
    pcmanfm
    mpv
    heroic
    spot
    # spotify-tray
    # spicetify-cli

    # tui applications
    ranger
    neovim
    htop

    # cli applications
    neofetch
    git
    zip
    unzip
    wget
    curl

    # dev
    gcc
    nodejs
    cargo
    sumneko-lua-language-server
    rnix-lsp

    # util
    home-manager
    pam_u2f
    polkit
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

