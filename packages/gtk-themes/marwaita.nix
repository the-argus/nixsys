{
  stdenv,
  fetchgit,
  gtk-engine-murrine,
  ...
}:
stdenv.mkDerivation rec {
  pname = "marwaita-gtk";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/darkomarko42/Marwaita";
    rev = "532485418e7616e3e13354bcf146de74187b03f5";
    sha256 = "0syh0r0fyb2qamf24vnpn1lirpjpff55k6nrgqy39q5ic6nimjhv";
    fetchSubmodules = true;
  };

  propagatedUserEnvPkgs = [gtk-engine-murrine];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r "Marwaita" $out/share/themes
    cp -r "Marwaita Color Dark" $out/share/themes
    cp -r "Marwaita Color" $out/share/themes
    cp -r "Marwaita Dark" $out/share/themes
  '';
}
