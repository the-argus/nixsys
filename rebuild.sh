#!/bin/sh

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

# check if hardware config exists
HARDWARE_DIR=$SCRIPT_DIR/system/hardware-configuration.nix
if [ ! -e $HARDWARE_DIR ]; then
    echo "copy your hardware-configuration.nix to" $HARDWARE_DIR
    exit
fi

    pushd $SCRIPT_DIR
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd
