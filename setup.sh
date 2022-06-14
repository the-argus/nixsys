#!/bin/sh

# nix cant automatically download this file
# using a specific name that works with nixpkgs
wget https://www.steinberg.net/vst3sdk -O vstsdk368_08_11_2017_build_121.zip

nix-store --add-fixed sha256 vstsdk368_08_11_2017_build_121.zip
