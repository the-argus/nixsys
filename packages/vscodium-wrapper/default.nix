{
  lib,
  stdenvNoCC,
  vscodium,
  vscodePackage ? vscodium,
  additionalPackages ? [],
  buildPackages,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = vscodePackage.pname;
  version = vscodePackage.version;
  src = vscodePackage;
  dontBuild = true;
  nativeBuildInputs = [buildPackages.makeWrapper];
  postInstall = let
    path = lib.makeBinPath additionalPackages;
  in ''
    mkdir $out/bin -p
    ln -sf $src/bin/codium $out/bin/codium
    ln -sf $src/share $out/share

    wrapProgram $out/bin/codium \
      --prefix PATH : ${path}
  '';
}
