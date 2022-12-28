{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.desktops;
  inherit (lib) mkIf mkEnableOption;
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
  ];

  options.desktops = {
    enable = mkEnableOption "Desktop";
  };

  config = mkIf cfg.enable {
    # fix overlap between plasma and gnome
    programs.ssh.askPassword =
      mkIf (cfg.gnome.enable && cfg.plasma.enable)
      (pkgs.lib.mkForce
        "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass");

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # packages-------------------------------------------------------------------
    environment.systemPackages = with pkgs; [
      pulseaudio
      xorg.xf86inputlibinput
      libinput
    ];

    # fonts -------------------------------------------------------------------
    fonts.fonts = with pkgs; [
      fira-code
      fira-code-symbols
      cozette
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      liberation_ttf
      dina-font
      victor-mono

      (nerdfonts.override {fonts = ["FiraCode" "VictorMono"];})
    ];

    # hardware ----------------------------------------------------------------
    # OpenGL
    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
      ];
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
