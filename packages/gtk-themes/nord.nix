{
  stdenv,
  fetchgit,
  fetchurl,
  gtk-engine-murrine,
  ...
}:
stdenv.mkDerivation rec {
  pname = "nordic-gtk";
  version = "2.2.0";

  src = builtins.fetchTarball {
    url = "https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic.tar.xz";
    sha256 = "sha256:0qx2c3yajvnwdkg7r42jx4yygv0svl0q3yvyiqh54ia1lhfwbad4";
  };

  propagatedUserEnvPkgs = [gtk-engine-murrine];

  installPhase = ''
    mkdir -p $out/share/themes/Nordic
    cp -r . $out/share/themes/Nordic
  '';
}
