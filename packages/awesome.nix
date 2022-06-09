{ pkgs, awesome, ... }:
# basic override of awesome to use git master source code
pkgs.awesome.overrideAttrs (finalAttrs: previousAttrs: {
    src = awesome;
})
