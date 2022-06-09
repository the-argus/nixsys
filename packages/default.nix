{ lib, pkgs, picom, config, ... }:
{
    picom = import ./picom.nix;
    awesome = import ./awesome.nix;
}
