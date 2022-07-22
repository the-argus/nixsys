{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "Frohmage.exe";
  src = pkgs.fetchurl {
    url = "https://cdn.shopify.com/s/files/1/0348/9785/4596/files/Frohmage-167-win64-vst-free.exe?v=1602245999";
    sha256 = "1jkj9prl5p4245vx1v9q0ckqqhmy9ljwm9b2sgpb3f6pdbav08i3";
  };

  nativeBuildInputs = [ pkgs.wineWowPackages.minimal ];

  buildPhase = ''
    wine "*.exe"
  '';

  installPhase = "cp -r . $out";
}
