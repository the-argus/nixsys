{ pkgs, ... }:
# basic override of awesome to use git master source code
pkgs.awesome.overrideAttrs (finalAttrs: previousAttrs: {
  src = pkgs.fetchgit {
    url = "https://github.com/awesomeWM/awesome";
    rev = "b7bac1dc761f7e231355e76351500a97b27b6803";
    sha256 = "0140429rlfpfnjz6rviy8s5s7x7pyrs3mmbx0qplkfww0ilrs72b";
  };
  patches = [ ];
})
