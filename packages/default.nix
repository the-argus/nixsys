{
  callPackage,
  lib,
  original-kitty ? null,
  fzf,
  picom,
  ...
}: rec {
  # meta packages
  gtkThemes = callPackage ./gtk-themes {};
  discordThemes = callPackage ./discord-themes.nix {};
  firefoxPackages = callPackage ./firefox {};

  # indivdual packages
  inherit picom;
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
  kitty = callPackage ./kitty {inherit original-kitty;};
  emptty-unwrapped = callPackage ./emptty/default.nix {};
  emptty = callPackage ./emptty/wrapper.nix {inherit emptty-unwrapped;};
  typst = callPackage ./typst {};
  godot_4_mono = callPackage ./godot_4_mono {};
  godot_4_mono-bin = callPackage ./godot_4_mono-bin {};
  IDEA = callPackage ./idea {};
  labwc = callPackage ./labwc {};
  wlrctl = callPackage ./wlrctl {};
  sway-osd = callPackage ./sway-osd {};
  hansoft = callPackage ./hansoft {};
  vscodium-wrapper = callPackage ./vscodium-wrapper {};
  ctrlf = callPackage ./ctrlf {};
  fzf-16 = callPackage ./fzf-16 {fzf-original = fzf;};
  lf-kitty-previewer = callPackage ./lf-kitty-previewer {};
}
