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

  # Use the systemd-boot EFI boot loader.
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

  # PAM authentication for yubikey/solokey
  # line to add with mkOverride: "auth       required   pam_u2f.so"
  security.pam.services.login.text = pkgs.lib.mkDefault (pkgs.lib.mkAfter "# testing");

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

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
    ];
  };

  programs.sway = {
    enable = true;
  };

  xdg.portal.wlr.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    wget
    neofetch
    curl
    firefox
    xorg.xinit
    xorg.xorgserver
    # xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.xf86videointel
    xorg.xauth
    networkmanager
    awesome
    kitty
    zsh
    zsh-syntax-highlighting
    zsh-autocomplete
    git
    discord
    ranger
    waybar
    gcc
    wofi
    swaybg
    wofi-emoji
    wl-clipboard
    wlsunset
    grim
    slurp
    zip
    unzip
    nodejs
    acpilight
    htop
    keepassxc
    pulseaudio
    pam_u2f
    polkit
    flameshot
    gnome.gnome-calculator
    cargo
  ];

  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    cozette
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    liberation_ttf
    dina-font
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # backlight permissions
  services.udev.extraRules = ''
    SUBSYSTEM=="backlight", ACTION=="add", \
    	RUN+="${pkgs.coreutils-full}/bin/chgrp video /sys/class/backlight/%k/brightness", \
    	RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  #sound.enable = false;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
  system.stateVersion = "22.05"; # Did you read the comment?

}

