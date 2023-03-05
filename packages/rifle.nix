{
  fetchurl,
  stdenvNoCC,
  python3,
  coreutils-full,
  ...
}: let
  contents = fetchurl {
    url = "https://raw.githubusercontent.com/ranger/ranger/f1444faf59bfd921e1b5dbb98d8b12c7af1cf371/ranger/ext/rifle.py";
    sha256 = "sha256-MfFrAEQqr55kDVAI4p0MmoGtzEhvPdKEKLBbzhxZiH4=";
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
