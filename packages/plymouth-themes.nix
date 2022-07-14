{ pkgs
, plymouth-themes-src
, themePath
, themeName
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
      cp -r ${themePath} $out/share/plymouth/themes
    cat ${themePath}/${themeName}.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/${themeName}/${themeName}.plymouth
  '';
}
