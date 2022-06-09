#!/bin/sh

# this file contains any commands I may want to run when setting up my system
# that cannot be managed by nix :(

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update
