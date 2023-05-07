{
  stdenvNoCC,
  labwc,
  buildPackages,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "labwc-config";
  version = ${labwc.version};

  src = ./config;

  postInstall = ''
    mkdir $out
    cp -r . $out
  '';

  postFixup = ''
    substituteInPlace $out/autostart \
      --replace "~/.config/eww" "$out/eww"
  '';
}
