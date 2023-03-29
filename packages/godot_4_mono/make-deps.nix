{
  godot_4_mono,
  nuget-to-nix,
  dotnet-sdk,
  ...
}:
godot_4_mono.overrideAttrs (oa: {
  pname = "godot-mono-make-deps";

  nativeBuildInputs = oa.nativeBuildInputs ++ [nuget-to-nix dotnet-sdk];

  shouldConfigureNuget = false;

  outputs = ["out"];

  dontBuild = true;

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
