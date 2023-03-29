{
  godot_4_mono,
  nuget-to-nix,
}:
godot_4_mono.overrideAttrs (oa: {
  pname = "godot-mono-make-deps";

  nativeBuildInputs = oa.nativeBuildInputs ++ [nuget-to-nix];

  shouldConfigureNuget = false;

  outputs = ["out"];
  dontBuild = true;
  buildPhase = ''
    # Without RestorePackagesPath set, it restores packages to a temp directory. Specifying
    # a path ensures we have a place to run nuget-to-nix.
    nugetRestore() { dotnet msbuild -t:Restore -p:RestorePackagesPath=nugetPackages $1; }

    nugetRestore modules/mono/glue/GodotSharp/GodotSharp.sln
    nugetRestore modules/mono/editor/GodotTools/GodotTools.sln
  '';

  installPhase = ''
    mkdir -p $out
    cp -r * $out
  '';

  meta =
    oa.meta
    // {
      description = "Produces the unpacked source of godot, in preparation for nuget-to-nix";
    };
})
