{ pkgs, awesome, ... }:
pkgs.stdenv.mkDerivation
rec {
  pname = "awesome-git";
  version = "4.3";

  src = awesome;

  buildInputs = with pkgs; [
    gnumake
    cmake
    lua5_4
    xorg.libxcb
    xorg.libX11
    glib
    gdk-pixbuf
    cairo
    xorg.xcbutilcursor
    xorg.xcbutil
    xorg.xcbutilkeysyms
    libxkbcommon
    xorg.xorgproto
    # xorg.xcbproto
    libxdg_basedir
    xcbutilxrm
    libstartup_notification
    # missing cairo-xcb, xcb-icccm
  ];

  configurePhase = '''';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
  '';
}
