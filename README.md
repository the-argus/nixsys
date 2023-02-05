# Nix system configuration flake

This repository describes the setup of both my laptop and PC. It's a relatively
large flake because I am very committed to reproducibility. The only things in
my setup that don't exactly match what you will get from building this
repository are some browser extensions and installed flatpaks.

## Usage

To apply or update, enter the shell:``nix develop``
then enter "rebuild" or "update", respectively.

You can find configurations for different machines inside of the ``hosts/``
directory. In order to build the configurations for different hosts instead
of the default, run ``rebuild laptop`` or ``rebuild pc``.

## ``lib/`` directory and ``finalizeSettings`` function

Each host (both laptop and PC) have different configurations for nixpkgs. Unlike
configuration options such as ``environment.systemPackages``, it is not possible
to set these with modules. Therefore, each host has some settings (found in
``hosts/[hostname]/default.nix``) which are imported and used in order to import
nixpkgs. Here is a snippet of code from the flake.nix, for example:

```nix
{
  outputs = let
    hosts = {
      laptop = import ./hosts/laptop {
        inherit nixpkgs;
        hostname = "evil";
      };
      pc = import ./hosts/pc {
        inherit nixpkgs;
        hostname = "mutant";
      };
    };
  in
  {
    nixosConfigurations = {
      laptop = self.createNixosConfiguration hosts.laptop;
    };
    
    packages.${defaultGlobalSettings.system} = {
      myPackages =
        (finalizeSettings defaultGlobalSettings).pkgs.callPackage ./packages {};
    };
  };
}
```

On the last line, you can see that ``(finalizeSettings defaultGlobalSettings)``
returns a set which includes ``pkgs``, which is the finished and imported
nixpkgs.

## Making your own host: available settings

First, copy and paste the contents of ``hosts/laptop/default.nix`` to
``hosts/[yourhostname]/default.nix``. You can then edit the value found in the
``hostname ? "evil",`` line, to be whatever default hostname you prefer. Then
you can get into editing the settings.

### ``theme``

Defaults to rosepine with the gtk-nix flake's gtk theme. Available themes
include "drifter", "orchis", "nordicWithGtkNix", "nordic", "gtk4", "rosepine",
"gruvbox", "gruvboxWithGtkNix", and "amber-forest".

### ``system``

Defaults to "x86_64-linux". This is the only tested system.

### ``username``

Defaults to "argus". Change it to whatever you want your primary user's username
to be.

### ``useDvorak``

Boolean which, when set to true, adds the Dvorak programmer layout to X based
environments, and makes it the default while in a TTY.

### ``allowedUnfree``

A list of strings with the names of unfree packages you would like to allow. It
always is merged with the contents of allowedUnfree from
``lib/settings-defaults.nix``.

### ``allowBroken``

Defaults to false. Whether to allow broken packages. Useful when building with
musl.

### ``extraExtraSpecialArgs``

Unused. Additional values to be passed into all home-manager modules.

### ``extraSpecialArgs``

Unused. Additional values to be passed into all nixos modules.

### ``additionalModules``

List of paths to nix module files. These will be imported in addition to
``user/primary/default.nix``.

### ``packageSelections``

A set which must contain at least the following:

```nix
{
  unstable = _: _: {};
  remotebuild = _: _: {};
  localbuild = _: _: {};
}
```

Each of these is a function which will apply overlays. For example, if you want
the steam package to be the version from the unstable branch, you could do the
following:

```nix
{
  unstable = unstable: _:
    {
      steam = unstable.steam;
    };
  remotebuild = _: _: {};
  localbuild = _: _: {};
}
```

The second argument of the function is the original packageset.

### ``additionalOverlays``

A list of overlays to add to pkgs. Applied *before* ``packageSelections``.

### ``additionalNixosModules``

Identical to ``additionalModules`` except these will be added to the
``nixpkgs.lib.nixosSystem`` call.

### ``optimization``

A complex set which must at least contain the following:

```nix
{
  arch = "";
  useMusl = false;
  useFlags = false;
  useClang = false;
  useNative = false;
  USE = [];
};
```

Setting ``useFlags`` to true will enable all of the custom build settings, and
cause pretty much all your packages to build from source. Add compiler flags
such as ``"-O3"`` to the USE list.

### ``name``

This value must always be set to "pkgs".

### ``nix``

Thise is merely a passthrough to ``config.nix``. Available values include things
like ``package``, ``gc``, ``distributedBuilds``, ``settings``, etc.

### ``unstableOverrides``, ``remotebuildOverrides``, and ``localbuildOverrides``

These are overrides which will be applied to the settings, but *only* for a
single package set. Here are what they must contain at the bare minimum,
respectively:

```nix
{
  name = "unstable";
};
{
  name = "remotebuild";
};
{
  name = "localbuild";
};
```

These can be used to select certain packages to have specific optimizations, or
to be cross-compiled on a remote machine. For example:

```nix
{
  packageSelections = {
    # make firefox be selected from the "remotebuild" packageset
    remotebuild = remotebuild: _:
      with remotebuild; {
        inherit firefox;
      };
    localbuild = _: _: {};
    unstable = _: _: {};
  };

  # configure the remotebuild packageset to use fancy optimizations
  remotebuildOverrides = {
    optimization = {
      useMusl = true;
      useFlags = true;
      useClang = true;
    };
    name = "remotebuild";
  };
}
```
