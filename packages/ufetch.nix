{
  stdenv,
  fetchgit,
  coreutils-full,
  ...
}:
stdenv.mkDerivation {
  name = "ufetch-nixos";

  src = fetchgit {
    url = "https://gitlab.com/jschx/ufetch";
    rev = "12b68fa35510a063582d626ccd1abc48f301b6b1";
    sha256 = "0sv17zmvhp0vfdscs8yras7am10ah7rpfyfia608sx74k845bfyl";
  };

  dontBuild = true;

  installPhase = ''
    ${coreutils-full}/bin/chmod +x ufetch-nixos
    mkdir -p $out/bin
    cp ufetch-nixos $out/bin/ufetch
  '';
}
