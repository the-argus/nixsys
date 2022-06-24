{ pkgs, ... }:
pkgs.carla.overrideAttrs (finalAttrs: previousAttrs: {
  nativeBuildInputs = with pkgs; [
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
