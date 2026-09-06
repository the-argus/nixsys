{
  stdenv,
  lib,
  fetchgit,
  gnumake,
  neuswc,
  # transitive dependencies of neuswc
  wayland,
  pixman,
  wayland-protocols,
  libxkbcommon,
  fontconfig,
  libdrm,
  freetype,
  xwayland,
  ...
}:
stdenv.mkDerivation {
  pname = "hevel";
  version = "0.0.1";

  src = fetchgit {
    url = "https://git.sr.ht/~dlm/hevel";
    rev = "7ef61a5c0d4012417443734919ac723635cd5464";
    hash = "sha256-ad4euUV+jJYG58aO9tfKyCq8sznDf2tHj7RmORqnP1o=";
  };

  nativeBuildInputs = [gnumake];

  buildInputs = [
    xwayland
    neuswc

    # transitive dependencies of neuswc
    wayland
    pixman
    wayland-protocols
    libxkbcommon
    fontconfig
    libdrm
    freetype
  ];

  meta = with lib; {
    description = "a scrollable, floating window manager for Wayland that uses mouse chords for all commands";
    homepage = "https://git.sr.ht/~dlm/hevel";
    license = licenses.mit;
    broken = stdenv.isDarwin;
  };
}
