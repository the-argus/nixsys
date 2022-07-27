{ pkgs
, ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "firefox-assets";
  version = "0.0.1";

  src = ./src;
  dontUnpack = true;

  installPhase = ''
    mkdir $out
    cp -r . $out
  '';
}
