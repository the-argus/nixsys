{pkgs, ...}: {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = let
      colors = (pkgs.callPackage ./themes.nix {}).scheme;
    in {
      modifier = "Mod4"; # super key
      workspaceAutoBackAndForth = true;

      colors = {
        background = colors.bg;
      };
    };

    extraConfig = '''';
  };
}
