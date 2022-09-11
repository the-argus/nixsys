{
  stdenv,
  gtk-engine-murrine,
  ...
}:
stdenv.mkDerivation rec {
  pname = "kanagawa";
  version = "0.1";

  src = pkgs.fetchgit {
    url = "https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme";
    sha256 = "1f4bh20vw7s9x1vyi599y693g25dmd44lb84mnp6py464ra9zh67";
    ref = "94e98184d2af3484ee38223572ba167b198d50fc";
  };

  propagatedUserEnvPkgs = [gtk-engine-murrine];

  installPhase = ''
    mkdir -p $out/share/themes/kanagawa
    cp -r themes/Kanagawa-B $out/share/themes
    cp -r themes/Kanagawa-BL $out/share/themes
  '';
}
