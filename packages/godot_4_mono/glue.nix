{
  godot_4,
  mono,
  stdenv,
  ...
}: let
  monoEnabledGodot = godot_4.overrideAttrs (base: {
    pname = "godot-mono-glue";
    buildDescription = "mono glue";

    sconsFlags =
      base.sconsFlags
      ++ [
        "module_mono_enabled=yes"
        "mono_prefix=${mono}" # not sure if this is necessary. may be vestigal
      ];

    nativeBuildInputs = base.nativeBuildInputs ++ [mono];

    # patches = base.patches ++ [./gen_cs_glue_version.py.patch];

    outputs = ["out"];

    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  });
in
  stdenv.mkDerivation {
    pname = "godot-mono-glue";
    version = monoEnabledGodot.version;

    src = monoEnabledGodot;

    nativeBuildInputs = [mono];

    # just build straight into $out, avoid any copying to and from the build dir
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/modules/mono/glue
      $src/bin/godot.linuxbsd.editor.x86_64.mono --headless --generate-mono-glue $out/modules/mono/glue/
    '';

    meta =
      monoEnabledGodot.meta
      // {
        homepage = "https://docs.godotengine.org/en/stable/development/compiling/compiling_with_mono.html#generate-the-glue";
      };
  }
