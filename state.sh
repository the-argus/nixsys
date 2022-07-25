#!/bin/sh

# this file contains any commands I may want to run when setting up my system
# that cannot be managed by nix :(

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update
flatpak install Discord
# flatpak install Spotify

# sync /home/argus/.wine/drive_c/yabridge
# list of installed plugins there:
# - https://www.ohmforce.com/frohmage
yabridgectl sync
