{
  stdenvNoCC,
  labwc,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "labwc-config";
  version = labwc.version;

  src = ./config;

  installPhase = ''
    mkdir $out
    cp -r . $out
  '';

  postFixup = ''
    substituteInPlace $out/autostart \
      --replace "~/.config/eww" "$out/eww"
  '';
}
