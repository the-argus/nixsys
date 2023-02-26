{
  fetchurl,
  stdenvNoCC,
  python3,
  coreutils-full,
  ...
}: let
  contents = fetchurl {
    url = "https://raw.githubusercontent.com/ranger/ranger/master/ranger/ext/rifle.py";
    sha256 = "1lwq0n25336q6hkq7gywfc6vp5hbv8aar25slc95mnikbfsvxwp3";
  };
in
  stdenvNoCC.mkDerivation {
    name = "rifle";
    src = contents;
    dontUnpack = true;
    buildInputs = [python3];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/rifle
      ${coreutils-full}/bin/chmod +wx $out/bin/rifle
    '';

    postFixup = ''
      patchShebangs --host $out/bin/rifle
    '';
  }
