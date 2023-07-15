{
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "sudo-askpass";
  version = "v1.1.0";

  src = fetchFromGitHub {
    owner = "Absolpega";
    repo = "simple-terminal-sudo-askpass";
    rev = "84dd6ef95c37f81d7e852b9e8d6cda188b5e060d";
    sha256 = "00gwbqcv9mbypcfznmdal7m5jh3lrsnvqf2n71nf8k5hm658z2l3";
  };

  cargoHash = "sha256-T4vHg6XWoTpd+ZaS9cfwyguVCcdjyyCvjrZr56fBc/o=";

  cargoPatches = [./add-cargo-lock.patch];
}
