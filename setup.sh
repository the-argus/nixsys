#!/bin/sh

# nix cant automatically download this file
# using a specific name that works with nixpkgs
wget https://www.steinberg.net/vst3sdk

nix-store --add-fixed sha256 vst3sdk

# SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
# URI="file://${SCRIPT_DIR}/vst3sdk"
# echo $URI
# nix-prefetch-url --type sha256 $URI
