{ pkgs, config, inputs, lib, ... }:
let
  cfg = config.desktops;
  inherit (lib) mkIf mkEnableOption;
in
{
  imports = [
    ./sway.nix
  ];


  options.desktops = {
    enable = mkEnableOption "Desktop";
    wayland = {
      enable = mkEnableOption "Wayland";
    };
  };

  config = mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;

    # packages-------------------------------------------------------------------
    environment.systemPackages = with pkgs; [
      pulseaudio
      xorg.xf86inputlibinput
      libinput
      # appearance
      paper-gtk-theme # Paper
      # Icons: Lounge-aux
      # Themes: Lounge Lounge-compact Lounge-night Lounge-night-compact
      lounge-gtk-theme
      juno-theme # Juno Juno-mirage Juno-ocean Juno-palenight
      graphite-gtk-theme # Graphite Graphite-dark Graphite-light Graphite-dark-hdpi Graphite-hdpi ....

      paper-icon-theme
      numix-cursor-theme # Numix-Cursor Numix-Cursor-Light
    ];

    # xserver -----------------------------------------------------------------
    services.xserver.enable = true;
    services.xserver = {
      excludePackages = with pkgs; [
        xterm
        xorg.xf86inputevdev.out
      ];
    };
    services.xserver.displayManager.startx.enable = true;
    services.xserver.windowManager.awesome.enable = true;
    services.xserver.useGlamor = false;
    #	services.xserver.videoDrivers = [ "intel" ];
    services.xserver.videoDriver = "intel";

    # wayland -----------------------------------------------------------------

    wayland_config = mkIf cfg.wayland.enable {
      # XDG Config
      xdg = {
        portal = {
          enable = true;
          wlr.enable = true;
          gtkUsePortal = true;
          # extraPortals = with pkgs; [
          #   xdg-desktop-portal-wlr
          #   xdg-desktop-portal-kde
          #   xdg-desktop-portal-gnome
          # ];
        };
      };
    };

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
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];


    # hardware ----------------------------------------------------------------
    # OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
      # extraPackages32 = with pkgs.pkgsi686Linux;
      #   [ libva vaapiIntel libvdpau-va-gl vaapiVdpau ]
      #   ++ lib.optionals config.services.pipewire.enable [ pipewire ];
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    hardware.acpilight.enable = true;
    # backlight permissions
    services.udev.extraRules = ''
      SUBSYSTEM=="backlight", ACTION=="add", \
          RUN+="${pkgs.coreutils-full}/bin/chgrp video /sys/class/backlight/%k/brightness", \
          RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';
  };

}
