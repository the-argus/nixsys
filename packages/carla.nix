{
  carla,
  gcc,
  gcc_multi,
  python3Packages,
  pkg-config,
  which,
  wrapQtAppsHook,
  ...
}:
carla.overrideAttrs (_: {
  nativeBuildInputs = [
    gcc
    gcc_multi
    python3Packages.wrapPython
    pkg-config
    which
    wrapQtAppsHook
  ];

  # create the bridges for more plugin types
  buildPhase = ''
    make
    make posix32
  '';
})
