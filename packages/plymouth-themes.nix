{
  pkgs,
  themeName,
  ...
}: let
  pack_1 = [
    "abstract_ring"
    "abstract_ring_alt"
    "alienware"
    "angular"
    "angular_alt"
    "black_hud"
    "blockchain"
    "circle"
    "circle_alt"
    "circle_flow"
    "circle_hud"
    "circuit"
    "colorful"
    "colorful_loop"
    "colorful_sliced"
    "connect"
    "cross_hud"
    "cubes"
    "cuts"
    "cuts_alt"
  ];
  pack_2 = [
    "cyanide"
    "cybernetic"
    "dark_planet"
    "darth_vader"
    "deus_ex"
    "dna"
    "double"
    "dragon"
    "flame"
    "glitch"
    "glowing"
    "green_blocks"
    "green_loader"
    "hexagon"
    "hexagon_2"
    "hexagon_alt"
    "hexagon_dots"
    "hexagon_dots_alt"
    "hexagon_hud"
    "hexagon_red"
  ];
  pack_3 = [
    "hexa_retro"
    "hud"
    "hud_2"
    "hud_3"
    "hud_space"
    "ibm"
    "infinite_seal"
    "ironman"
    "liquid"
    "loader"
    "loader_2"
    "loader_alt"
    "lone"
    "metal_ball"
    "motion"
    "optimus"
    "owl"
    "pie"
    "pixels"
    "polaroid"
  ];
  pack_4 = [
    "red_loader"
    "rings"
    "rings_2"
    "rog"
    "rog_2"
    "seal"
    "seal_2"
    "seal_3"
    "sliced"
    "sphere"
    "spin"
    "spinner_alt"
    "splash"
    "square"
    "square_hud"
    "target"
    "target_2"
    "tech_a"
    "tech_b"
    "unrap"
  ];
  invertListToAttrs = listName: values: lib.lists.foldr (next: prev: {${next} = listName;} // prev) {} values;

  availableThemes =
    (invertListToAttrs "pack_1" pack_1)
    // (invertListToAttrs "pack_2" pack_2)
    // (invertListToAttrs "pack_3" pack_3)
    // (invertListToAttrs "pack_4" pack_4);
  themePath = "${availableThemes.${cfg.animationName}}/${cfg.animationName}";
in
  pkgs.stdenv.mkDerivation rec {
    pname = "adi1090x-plymouth";
    version = "0.0.1";

    src = pkgs.fetchgit {
      url = "https://github.com/adi1090x/plymouth-themes";
      rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
      sha256 = "0scgba00f6by08hb14wrz26qcbcysym69mdlv913mhm3rc1szlal";
    };

    installPhase = ''
      mkdir -p $out/share/plymouth/themes/
      cp -r ${themePath} $out/share/plymouth/themes
      cat ${themePath}/${themeName}.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/${themeName}/${themeName}.plymouth
    '';

    passthru = {
      inherit availableThemes;
    };
  }
