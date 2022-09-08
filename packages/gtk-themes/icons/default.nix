{ pkgs, ... }:
{
  nordic = pkgs.callPackage ./nordic.nix { };
}
