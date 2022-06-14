#!/bin/sh

# nix cant automatically download this file
wget https://www.steinberg.net/vst3sdk -O vst-sdk.zip
nix-store --add-fixed sha256 vst-sdk.zip
