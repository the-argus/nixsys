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
  buildPhase = " ";
  installPhase = ''echo "No output intended. Run make-deps.sh instead." > $out'';

  makeDeps = ''
    set -e
    outdir="$(pwd)"
    wrkdir="$(mktemp -d)"
    pushd "$wrkdir" > /dev/null
      unpackPhase
      cd source
      patchPhase
      configurePhase

      # Without RestorePackagesPath set, it restores packages to a temp directory. Specifying
      # a path ensures we have a place to run nuget-to-nix.
      nugetRestore() { dotnet msbuild -t:Restore -p:RestorePackagesPath=nugetPackages $1; }

      nugetRestore modules/mono/glue/GodotSharp/GodotSharp.sln
      nugetRestore modules/mono/editor/GodotTools/GodotTools.sln

      nuget-to-nix nugetPackages > "$outdir"/deps.nix
    popd > /dev/null
    rm -rf "$wrkdir"
  '';

  meta =
    oa.meta
    // {
      description = "A derivation with no output that exists to provide an environment for make-deps.sh";
    };
})
