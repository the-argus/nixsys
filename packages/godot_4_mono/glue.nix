{
  godot_4,
  mono,
  stdenv,
}: let
  monoEnabledGodot = godot_4.overrideAttrs (base: {
    pname = "godot-mono-glue";
    buildDescription = "mono glue";

    sconsFlags =
      base.sconsFlags
      ++ [
        "module_mono_enabled=yes"
        "mono_glue=false"
        "mono_prefix=${mono}" # not sure if this is necessary. may be vestigal
      ];

    nativeBuildInputs = base.nativeBuildInputs ++ [mono];

    # patches = base.patches ++ [./gen_cs_glue_version.py.patch];

    outputs = ["out"];

    installPhase = ''
      glue="$out"/modules/mono/glue
      mkdir -p "$glue"
      ls -al bin

      cp -r * $out
    '';
  });
in
  stdenv.mkDerivation {
    pname = "godot-mono-glue";
    version = monoEnabledGodot.version;

    src = monoEnabledGodot;

    buildPhase = ''
      DISPLAY=:0 bin/godot.linuxbsd.editor.x86_64.mono --headless --generate-mono-glue "$glue"
    '';

    nativeBuildInputs = [mono];

    installPhase = ''
      mkdir -p "$out/bin"
      cp bin/godot.* $out/bin/
      installManPage misc/dist/linux/godot.6
      mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
      cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
      substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
        --replace "Exec=godot" "Exec=$out/bin/godot"
      cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
      cp icon.png "$out/share/icons/godot.png"
    '';

    meta =
      monoEnabledGodot.meta
      // {
        homepage = "https://docs.godotengine.org/en/stable/development/compiling/compiling_with_mono.html#generate-the-glue";
      };
  }
