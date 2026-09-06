{
  stdenv,
  lib,
  pkg-config,
  meson,
  fetchgit,
  wayland,
  pixman,
  libdrm,
  fontconfig,
  freetype,
  wayland-scanner,
  ninja,
  ...
}:
stdenv.mkDerivation {
  pname = "neuwld";
  version = "0.0.1";

  src = fetchgit {
    url = "https://git.sr.ht/~shrub900/neuwld";
    rev = "554f827cadfdfcc276c709dbffa3b2b04c70cf7c";
    hash = "sha256-KAK4/TpNekaonN0yxi4/5mRdZL1uxYdGmwl41FRH5wU=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];

  mesonFlags = [
    "-Ddoxygen=disabled"
    "-Ddrivers=auto" # intel or nouveau
    "-Ddrm=enabled" # auto by default
    "-Dwayland=enabled" # auto by default
  ];

  buildInputs = [
    wayland
    pixman
    libdrm
    fontconfig
    freetype
  ];

  meta = with lib; {
    description = "a drawing library that targets Wayland";
    homepage = "https://git.sr.ht/~shrub900/neuwld";
    license = licenses.mit;
    broken = stdenv.isDarwin;
  };
}
