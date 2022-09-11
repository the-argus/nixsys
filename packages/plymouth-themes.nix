{
  pkgs,
  themePath,
  themeName,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "adi1090x-plymouth";
  version = "0.0.1";

  src = pkgs.fetchgit {
    url = "https://github.com/adi1090x/plymouth-themes";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
    sha256 = "0scgba00f6by08hb14wrz26qcbcysym69mdlv913mhm3rc1szlal";
  };

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
