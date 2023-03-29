#!/usr/bin/env bash
outdir=$PWD
nix shell \
  --inputs-from ../.. \
  ../../.#myPackages.godot_4_mono.make-deps \
  nixpkgs#nuget-to-nix \
  --command nuget-to-nix nugetPackages > $outdir/deps.nix
