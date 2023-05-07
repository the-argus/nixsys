{
  stdenvNoCC,
  labwc-original,
  buildPackages,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "${labwc-original.name}-wrapper";
  version = labwc-original.version;

  src = labwc-original;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [buildPackages.makeWrapper];

  postInstall = ''
    mkdir $out/bin -p
    ln -sf $src/share $out/share
    ln -sf $src/bin/labwc $out/bin/labwc

    wrapProgram $out/bin/labwc \
      --add-flags "-c ${./config}"
  '';
}
