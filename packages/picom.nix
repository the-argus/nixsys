{pkgs, ...}:
pkgs.picom.overrideAttrs (_: {
  src = pkgs.fetchgit {
    url = "https://github.com/pijulius/picom";
    rev = "982bb43e5d4116f1a37a0bde01c9bda0b88705b9";
    sha256 = "04rji6a9qdih04qk3mc0bg8hj6c1ccdn28jk4gh4gxfmq14qnav2";
  };
})
