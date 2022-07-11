{ pkgs
, plymouth-themes-src
, ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "adi1090x-plymouth";
  version = "0.0.1";

  src = plymouth-themes-src;

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
  '';

  buildPhase = ''
  '';

  installPhase = ''
      cp -r pack_3/lone $out/share/plymouth/themes
    cat pack_3/lone/lone.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/lone/lone.plymouth
  '';
}
