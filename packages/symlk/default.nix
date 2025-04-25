{
  stdenvNoCC,
  python3Minimal,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "symlk";
  src = ./.;

  buildInputs = [python3Minimal];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp symlk $out/bin/symlk
  '';
}
