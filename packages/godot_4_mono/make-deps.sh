#!/bin/sh
outdir=$PWD
nix build \
  ../../.#myPackages.godot_4_mono.make-deps
nix shell \
  --inputs-from ../.. \
  nixpkgs#nuget-to-nix \
  nixpkgs#dotnet-sdk \
  --command "./dotnet-restore"
