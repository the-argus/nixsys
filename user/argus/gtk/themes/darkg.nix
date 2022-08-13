{ stdenv, fetchgit, gtk-engine-murrine, ... }:
stdenv.mkDerivation rec {
  pname = "darkg-gtk";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/erenyldz89/DarkG";
    rev = "e7c2d6d1aa173c8b4e0d44f8f9b6f59f44a29233";
    sha256 = "1ycgcpf0yj8mv2d2qnbf37rrni581xa6cw83qdyz5633d7717jil";
    fetchSubmodules = true;
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes/DarkG
    cp -r * $out/share/themes/DarkG
  '';
}
