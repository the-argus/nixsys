#!/usr/bin/env bash
nix shell ../../.#myPackages.godot_4_mono.make-deps --command 'eval "$makeDeps"'
