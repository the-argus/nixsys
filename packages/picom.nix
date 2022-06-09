{ pkgs, picom, ... }:
pkgs.picom.overrideAttrs (finalAttrs: previousAttrs: {
    src = picom;
})
