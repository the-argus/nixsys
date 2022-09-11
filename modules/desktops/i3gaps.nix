{
  lib,
  config,
  pkgs,
  picom,
  unstable,
  ...
}: let
  cfg = config.desktops.i3gaps;
  derivations = {
    picom =
      import ../../packages/picom.nix
      {
        pkgs = unstable;
        inherit picom;
      };
  };
  inherit (lib) mkIf mkEnableOption;
in {
  options.desktops.i3gaps = {
    enable = mkEnableOption "I3 Window Manager";
  };

  config = mkIf cfg.enable {
    # fix for i3blocks if i ever use it
    environment.pathsToLink = ["/libexec"];

    desktops.xorg.enable = true;

    environment.systemPackages = with pkgs; [
      xmousepasteblock
      xfce.xfce4-clipman-plugin
      dunst
      rofi
      flameshot
      derivations.picom

      libnotify # notify-send scripts
    ];

    # this module is redundant with the hm module
    # services.xserver.windowManager.i3 = {
    #   enable = true;
    #   package = pkgs.i3-gaps;
    #   extraPackages = with pkgs; [
    #     xmousepasteblock
    #     xfce.xfce4-clipman-plugin
    #     dunst
    #     rofi
    #     flameshot
    #     derivations.picom

    #     libnotify # notify-send scripts
    #   ];
    # };
  };
}
