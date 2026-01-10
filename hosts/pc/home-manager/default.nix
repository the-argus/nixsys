{
  pkgs,
  unstable,
  ...
}: {
  imports = [];
  programs.yabridge.enable = true;

  # make home manager update fonts
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    godot_4
    blender
    kdePackages.kdenlive
    # myPackages.IDEA
    # jetbrains.rider
    # myPackages.hansoft
    # blender
    # (gimp-with-plugins.override {plugins = with pkgs.gimpPlugins; [gmic];})
    inkscape
    steam
    jre8
    aseprite
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
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
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

    nerd-fonts.fira-code
    nerd-fonts.victor-mono
  ];
}
