{ pkgs, picom, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "picom-fork";
  version = "9.1";

  src = picom;

  buildInputs = with pkgs; [
    ninja
    meson
    libev
    pkgconfig
    xorg.libX11
    xorg.xcbutilrenderutil
    xorg.xcbutilimage
    xorg.libXext
    xorg.pixman
    uthash
    libconfig
    pcre
    libGL
    dbus
  ];

  buildPhase = ''
    meson --buildtype=release ${picom} build
    ninja -C build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/src/picom $out/bin/picom
  '';
}
