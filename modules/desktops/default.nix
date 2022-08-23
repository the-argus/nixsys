{ pkgs
, config
, inputs
, lib
, #font-icons,
  ...
}:
let
  cfg = config.desktops;
  inherit (lib) mkIf mkEnableOption;
in
{
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

      (import ../../packages/font-icons.nix { inherit pkgs; })
      #      import ../../packages/font-icons.nix { inherit pkgs; inherit font-icons;}
      (nerdfonts.override { fonts = [ "FiraCode" "VictorMono" ]; })
    ];


    # hardware ----------------------------------------------------------------
    # OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
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
