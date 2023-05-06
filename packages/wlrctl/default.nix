{
  stdenv,
  fetchFromSourcehut,
  meson,
  pkg-config,
  scdoc,
  ninja,
  libxkbcommon,
  wayland,
  wayland-scanner,
  wlroots,
  ...
}:
stdenv.mkDerivation rec {
  pname = "wlrctl";
  version = "0.2.2-unstable";

  src = fetchFromSourcehut {
    owner = "~brocellous";
    repo = "wlrctl";
    rev = "8407f371506062dadd1ece92914bc89024b30f23";
    sha256 = "sha256-2ha6C1InGybL0DhqEnfk+lCoI2Mmh/+z1BWK0x8rn40=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    scdoc
    ninja
    wayland-scanner
  ];

  buildInputs = [
    libxkbcommon
    wayland
    (wlroots.override {enableXWayland = true;})
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=type-limits";
}
