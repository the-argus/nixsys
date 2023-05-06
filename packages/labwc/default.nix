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
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = pname;
    rev = version;
    hash = "sha256-YD2bGxa7uss6KRvOGM0kn8dM+277ubaYeOB7ugRZCcY=";
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
}
