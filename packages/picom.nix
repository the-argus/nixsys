{pkgs, ...}:
pkgs.picom.overrideAttrs (_: {
  src = pkgs.fetchgit {
    url = "https://github.com/yshui/picom";
    rev = "7d0d693ca7a4f07f94dbd66a1b22ddf29bd61c49";
    sha256 = "0r0nf37bg5ddviabxm8msw21rxrh5vffc7wzv2nwc09y2wdph175";
  };
})
