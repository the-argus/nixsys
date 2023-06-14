{
  godot_4,
  callPackage,
  mkNugetDeps,
  mkNugetSource,
  mono,
  dotnet-sdk,
  writeText,
  python3Minimal,
  ...
}: let
  glue = callPackage ./glue.nix {};
  godot_4_mono = godot_4.overrideAttrs (oa: rec {
    pname = "godot_4_mono";

    buildDescription = "mono build";

    nativeBuildInputs = oa.nativeBuildInputs ++ [mono dotnet-sdk python3Minimal];

    inherit glue;

    nugetDeps = mkNugetDeps {
      name = "deps";
      nugetDeps = import ./deps.nix;
    };

    nugetSource = mkNugetSource {
      name = "${pname}-nuget-source";
      description = "A Nuget source with dependencies for ${pname}";
      deps = [nugetDeps];
    };

    nugetConfig = writeText "NuGet.Config" ''
      <?xml version="1.0" encoding="utf-8"?>
      <configuration>
        <packageSources>
          <add key="godot-mono-deps" value="${nugetSource}/lib" />
        </packageSources>
      </configuration>
    '';

    sconsFlags =
      oa.sconsFlags
      ++ [
        "module_mono_enabled=yes"
        "mono_prefix=${mono}"
      ];

    shouldConfigureNuget = true;

    postConfigure = ''
      echo "Setting up buildhome."
      mkdir buildhome
      export HOME="$PWD"/buildhome

      echo "Overlaying godot glue."
      cp -R --no-preserve=mode "$glue"/. .

      if [ $shouldConfigureNuget ]; then
        echo "Configuring NuGet."
        mkdir -p ~/.nuget/NuGet
        ln -s "$nugetConfig" ~/.nuget/NuGet/NuGet.Config
      fi
    '';

    postBuild = ''
      python3 modules/mono/build_scripts/build_assemblies.py --godot-output-dir=bin
    '';

    postInstall = ''
      if [ $shouldInstallShortcut ]; then
        mv "$out"/share/applications/org.godotengine.Godot.desktop "$out"/share/applications/org.godotengine.GodotMono.desktop
        substituteInPlace "$out"/share/applications/org.godotengine.GodotMono.desktop --replace "Name=Godot Engine" "Name=Godot Engine (Mono)"
      else
        rm "$out"/share/applications/org.godotengine.Godot.desktop
      fi
    '';
  });
in
  godot_4_mono.overrideAttrs (_: {
    passthru = {
      make-deps = callPackage ./make-deps.nix {inherit godot_4_mono;};
      inherit glue;
    };
  })
