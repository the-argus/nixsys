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
    sha256 = "039cxc82k7x473n6d65jray90rj35qmfdmr390zy0c7ic7vn4b78";
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
