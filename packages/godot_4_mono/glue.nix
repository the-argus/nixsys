{
  godot_4,
  mono,
}:
godot_4.overrideAttrs (base: {
  pname = "godot-mono-glue";
  buildDescription = "mono glue";
  buildPlatform = "server";

  sconsFlags =
    base.sconsFlags
    ++ [
      "module_mono_enabled=true"
      "mono_glue=false" # Indicates not to expect already existing glue.
      "mono_prefix=${mono}"
    ];

  nativeBuildInputs = base.nativeBuildInputs ++ [mono];

  # patches = base.patches ++ [./gen_cs_glue_version.py.patch];

  outputs = ["out"];

  installPhase = ''
    runHook preInstall

    glue="$out"/modules/mono/glue
    mkdir -p "$glue"
    # bin/godot_server.x11.opt.tools.64.mono --generate-mono-glue "$glue"
    mkdir -p $out/test
    cp -r * $out/test

    runHook postInstall
  '';

  meta =
    base.meta
    // {
      homepage = "https://docs.godotengine.org/en/stable/development/compiling/compiling_with_mono.html#generate-the-glue";
    };
})
