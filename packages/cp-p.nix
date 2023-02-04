{
  stdenv,
  fetchgit,
  ...
}:
stdenv.mkDerivation {
  name = "cp-p";
  src = fetchgit {
    url = "https://github.com/Naheel-Azawy/cp-p";
    rev = "2e97ba534a5892c47a0317a038b19bcda221e5e6";
    sha256 = "1ki8bp33d9xf4jinr0isvkxq3i86xi1kkv2f5x54as6i0yz9w7iq";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mv cp-p $out/bin
  '';
}
