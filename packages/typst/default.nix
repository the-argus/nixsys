{
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "22-03-21-2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "typst";
    rev = version;
    hash = "sha256-bJPGs/Bd9nKYDrCCaFT+20+1wTN4YdkV8bGrtOCR4tM=";
  };

  cargoSha256 = "sha256-NG7zrQ3M+jGn3VkwkIu/deEqt1Q7FQiyW/LdmNLYVNs=";
  
  installPhase = ''
    runHook preInstall
    
    mkdir $out
    cp -r target/* $out/

    runHook postInstall
  '';
}
