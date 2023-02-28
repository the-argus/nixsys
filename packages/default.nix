{
  callPackage,
  lib,
  ...
}: {
  # meta packages
  gtkThemes = callPackage ./gtk-themes {};
  discordThemes = callPackage ./discord-themes.nix {};
  firefoxPackages = callPackage ./firefox {};

  # indivdual packages
  picom = callPackage ./picom.nix {};
  awesome = callPackage ./awesome.nix {};
  airwave = lib.trivial.warn "airwave is deprecated" (callPackage ./airwave.nix {});
  carla = callPackage ./carla.nix {};
  plymouth-themes = callPackage ./plymouth-themes.nix {};
  ufetch = callPackage ./ufetch.nix {};
  xgifwallpaper = callPackage ./xgifwallpaper.nix {};
  fly-pie = callPackage ./fly-pie {};
  firefox-assets = callPackage ./firefox-assets {};
  neovim-remote = callPackage ./neovim-remote.nix {};
  cp-p = callPackage ./cp-p.nix {};
  rgf = callPackage ./rgf.nix {};
  ly = callPackage ./ly {};
  ntfy-notify-send = callPackage ./ntfy-notify-send {};
  rifle = callPackage ./rifle.nix {};
  sudo-askpass = callPackage ./sudo-askpass {};
}
