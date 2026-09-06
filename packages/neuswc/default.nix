{
  stdenv,
  lib,
  neuwld,
  pkg-config,
  wayland-scanner,
  meson,
  ninja,
  fetchgit,
  wayland,
  pixman,
  wayland-protocols,
  libxkbcommon,
  fontconfig,
  libdrm,
  freetype,
  xwayland,
  libxcb,
  libxcb-wm,
  libinput,
  ...
}:
stdenv.mkDerivation {
  pname = "neuswc";
  version = "0.0.1";

  src = fetchgit {
    url = "https://git.sr.ht/~shrub900/neuswc";
    rev = "5d32737e4f0e89ae68d3d4d85743f70c177ce5b5";
    hash = "sha256-6umDisPrdqxd7vXV6QANROOMBLUAQr4hUuDdrPEq80E=";
  };

  mesonFlags = ["-Dvideo=drm"];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];

  buildInputs = [
    wayland
    xwayland
    libxcb
    libxcb-wm
    libinput
    neuwld
    pixman
    wayland-protocols
    libxkbcommon

    # transitive system dependencies of neuwld
    fontconfig
    libdrm
    freetype
  ];

  meta = with lib; {
    description = "neuswc is a fork of swc created by wayland.fyi";
    homepage = "https://git.sr.ht/~shrub900/neuswc";
    license = licenses.mit;
    broken = stdenv.isDarwin;
  };
}
