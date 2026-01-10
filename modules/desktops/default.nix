{
  pkgs,
  config,
  lib,
  unstable,
  ...
}: let
  cfg = config.desktops;
  inherit (lib) mkIf mkEnableOption mkOption;
in {
  imports = [
    ./sway.nix
    ./awesome.nix
    ./wayland.nix
    ./xorg.nix
    ./ratpoison.nix
    ./qtile.nix
    ./gnome.nix
    ./plasma.nix
    ./i3gaps.nix
    ./labwc.nix
  ];

  options.desktops = {
    enable = mkEnableOption "Desktop";
    terminal = mkOption {
      type = lib.types.package;
      default = pkgs.kitty;
    };
  };

  config = mkIf cfg.enable {
    # fix overlap between plasma and gnome
    programs.ssh.askPassword =
      mkIf (cfg.gnome.enable && cfg.plasma.enable)
      (pkgs.lib.mkForce
        "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass");

    # enable stuff for gpg so password prompting works
    # services.pcscd.enable = true;
    # services.dbus.packages = [ pkgs.gcr ];
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gtk2;
      enableSSHSupport = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # packages-------------------------------------------------------------------
    environment.systemPackages = with pkgs; [
      pulseaudio
      xorg.xf86inputlibinput
      libinput
    ];

    # fonts -------------------------------------------------------------------
    fonts.packages = with pkgs; [
      # unfree :(
      # vistafonts
      # ttf-envy-code-r
      # corefonts

      fira-code
      fira-code-symbols
      cozette
      tamzen
      envypn-font
      creep
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      liberation_ttf
      victor-mono
      tt2020
      arkpandora_ttf
      times-newer-roman
      tewi-font
      spleen
      scientifica
      recursive
      ocr-a # cyberpunk hacker font thats actually readable
      mononoki
      montserrat
      monocraft
      monoid # monospace, ligatures and language support
      martian-mono # rounded monospace font
      unstable.garamond-libre
      gelasio
      courier-prime
      comic-relief
      cascadia-code # microsoft ligatures font

      nerd-fonts.fira-code
      nerd-fonts.victor-mono
    ];

    # hardware ----------------------------------------------------------------
    # OpenGL
    hardware.graphics = {
      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux;
        [libva libvdpau-va-gl vaapiVdpau]
        ++ lib.optionals config.services.pipewire.enable [pipewire];
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

    hardware.acpilight.enable = true;
    # backlight permissions
    services.udev.extraRules = ''
      SUBSYSTEM=="backlight", ACTION=="add", \
          RUN+="${pkgs.coreutils-full}/bin/chgrp video /sys/class/backlight/%k/brightness", \
          RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';
  };
}
