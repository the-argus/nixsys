{
  enableXWayland ? true,
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  glib,
  libdrm,
  libinput,
  libxcb,
  libxkbcommon,
  libxml2,
  meson,
  ninja,
  pango,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  wlroots,
  xwayland,
}:
stdenv.mkDerivation rec {
  pname = "labwc";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = pname;
    rev = version;
    sha256 = "sha256-yZ1tXx7AA9pFc5C6c/J3B03/TfXw1PsAunNNiee3BGU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    cairo
    glib
    libdrm
    libinput
    libxcb
    libxkbcommon
    libxml2
    pango
    wayland
    wayland-protocols
    (wlroots.override {inherit enableXWayland;})
    xwayland
  ];

  mesonFlags = lib.optional enableXWayland "-Dxwayland=enabled";

  makeWrapperArgs = builtins.trace "Evaluating myPackages.labwc, which wraps labwc to use my config. This program may be double wrapped." [
    "--add-flags \"-c ${./config}\""
  ];

  postFixup = ''
    substituteInPlace $out/share/wayland-sessions/labwc.desktop \
      --replace "Exec=labwc" "Exec=$out/bin/labwc"
  '';

  passthru.providedSessions = ["labwc"];
}
