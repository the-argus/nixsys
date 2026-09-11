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

  # does not publicly require anything. the only sort of exceptioin is wayland
  # server, which you must use in order for using neuswc to make sense. it
  # doesn't strictly depend on it though because the wayland types are forward
  # declared.
  #
  # However, it seems that, I guess partially because static linking requires
  # transitive -l flags, and partially because of the developer putting
  # everything into the pkg config file, we have to forward everything for
  # downstream pkgconfig
  propagatedBuildInputs = [
    wayland
    xwayland
    libxcb
    libxcb-wm
    libinput
    neuwld
    pixman
    wayland-protocols
    libxkbcommon
  ];

  meta = with lib; {
    description = "neuswc is a fork of swc created by wayland.fyi";
    homepage = "https://git.sr.ht/~shrub900/neuswc";
    license = licenses.mit;
    broken = stdenv.isDarwin;
  };
}
