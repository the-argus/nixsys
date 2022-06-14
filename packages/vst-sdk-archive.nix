{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
    pname = "vst3-sdk";
    version = "0.1";
    src = pkgs.fetchzip {
        url = "https://www.steinberg.net/vst3sdk";
        sha256 = "0dq5c2ympz7jrliyw464ns13bj57wbgv56sy43j1sgb1f4gf6wf6";
    };
}
