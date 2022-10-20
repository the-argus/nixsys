# Nix system configuration flake

## Usage

To apply or update, enter the shell:``nix develop``
then enter "rebuild" or "update", respectively.

## Configuration configuration

This flake also supplies functions, ``createHomeConfigurations`` and
``createNixosConfiguration`` which can be used by external flakes
to alter this one. See examples of this in the separate, child
configurations I use on [my laptop](https://github.com/the-argus/laptop-config)
and [my PC](https://github.com/the-argus/pc-config).

To see what settings are configurable, check [the default settings](./lib/settings-defaults.nix)
