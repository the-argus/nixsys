{
  pkgs,
  unstable,
  ...
}: {
  imports = [];
  programs.yabridge.enable = false;

  # make home manager update fonts
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    kdenlive
    # myPackages.IDEA
    # jetbrains.rider
    # myPackages.hansoft
    # blender
    # (gimp-with-plugins.override {plugins = with pkgs.gimpPlugins; [gmic];})
    inkscape
    steam
    jre8
    # aseprite
    zoom-us
    protontricks
    xournalpp
    home-manager
    razergenie
    vial

    feh
    xclip
    xcolor
    ueberzug
    xorg.xauth
    xorg.xf86inputsynaptics
    xorg.xf86inputmouse

    # fonts
    fira-code
    fira-code-symbols
    cozette
    # tamzen
    # envypn-font
    # creep
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    liberation_ttf
    victor-mono
    tt2020
    arkpandora_ttf
    times-newer-roman
    # tewi-font
    spleen
    scientifica
    recursive
    ocr-a # cyberpunk hacker font thats actually readable
    mononoki
    montserrat
    monocraft
    monoid # monospace, ligatures and language support
    martian-mono # rounded monospace font
    unstable.garamond-libre
    gelasio
    courier-prime
    comic-relief
    cascadia-code # microsoft ligatures font

    (nerdfonts.override {fonts = ["FiraCode" "VictorMono"];})
  ];
}
