{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    nixFlakes
  ];

  shellHook = ''
    alias rebuild="sudo nixos-rebuild switch --flake .#"
    alias update="nix flake update"

      echo "You can apply this flake to your system with \"rebuild\""
      echo "And update it with \"update\""
      PATH=${pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
      ''}/bin:$PATH
    '';
  }
