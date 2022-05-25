#!/bin/sh

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

pushd $SCRIPT_DIR
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd
