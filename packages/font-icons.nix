{ pkgs, font-icons, ... }:
pkgs.stdenv.mkDerivation {
    pname = "font-icons";
    version = 1.0;

    src = font-icons;

    installPhase = ''
mkdir -p $out/share/font/truetype
cp icons.ttf $out/share/font/truetype/font-icons.ttf
    '';
}
