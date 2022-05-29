{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    nixFlakes
  ];

  shellHook = ''
    alias usrbuild="home-manager switch --flake ."
    alias sysbuild="sudo nixos-rebuild switch --flake ."
    alias rebuild="sysbuild && usrbuild"
    alias update="nix flake update"


      echo "You can apply this flake to your system with \"rebuild\""
      echo "And update it with \"update\""
      echo "And apply user configuration with \"usrbuild\" and system configuration with \"sysbuild\""
      PATH=${pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
      ''}/bin:$PATH
    '';
  }
