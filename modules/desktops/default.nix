{
  pkgs,
  config,
  lib,
  unstable,
  ...
}: let
  cfg = config.desktops;
  inherit (lib) mkIf mkEnableOption mkOption;
in {
  imports = [
    ./sway.nix
    ./awesome.nix
    ./wayland.nix
    ./xorg.nix
    ./ratpoison.nix
    ./qtile.nix
    ./gnome.nix
    ./plasma.nix
    ./i3gaps.nix
    ./labwc.nix
    ./hevel.nix
  ];

  options.desktops = {
    enable = mkEnableOption "Desktop";
    terminal = mkOption {
      type = lib.types.package;
      default = pkgs.kitty;
    };
  };

  config = mkIf cfg.enable {
    # fix overlap between plasma and gnome
    programs.ssh.askPassword = mkIf (cfg.gnome.enable && cfg.plasma.enable) (
      pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass"
    );

    # enable stuff for gpg so password prompting works
    # services.pcscd.enable = true;
    # services.dbus.packages = [ pkgs.gcr ];
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gtk2;
      enableSSHSupport = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # packages-------------------------------------------------------------------
    environment.systemPackages = with pkgs; [
      pulseaudio
      xorg.xf86inputlibinput
      libinput
    ];

    # fonts -------------------------------------------------------------------
    fonts.packages = with pkgs; [
      # unfree :(
      # vistafonts
      # ttf-envy-code-r
      # corefonts

      # coding fonts I like most -------------------------------------------

      fira-code # I used this for a long time
      fira-code-symbols
      # pretty dense, kind of terminal looking font, similar to hermit.
      # suffers very slightly from italic character being cut off in kitty, with
      # normal cell size
      nerd-fonts.agave
      # ibm style like plex mono, used in zed. quite legible and some slightly
      # script like style to the italic. has a fancy # character which draws
      # attention
      lilex
      # font that looks a bit like very good but dense handwriting. a bit
      # geometric and futuristic feeling
      hermit
      # microsoft ligatures font. feels quite a bit like hermit, but with
      # ligatures, with around the same or maybe less cutoff than Agave.
      cascadia-code
      # really good looking monospace font with ligatures, quite rounded.
      # unfortunately the character spacing in kitty isn't quite right,
      # certain letter pairs like pk in pkg are weirdly grouped together
      martian-mono

      # coding fonts I like slightly less ----------------------------------

      # script style italics, but otherwise generally quite Normal. ligatures
      # do not modify form. looks like a slightly more rounded version of
      # Agave. Though it suffers from glyphs being cut off slightly more than
      # agave, to the point where it is noticable.
      nerd-fonts._0xproto
      # very normal looking font that doesn't draw attention and otherwise
      # focuses on legibility. also a bit dense like hermit and agave.
      # unfortunately it suffers from italic characters being cut off the most
      # out of any of these
      nerd-fonts.commit-mono
      # sort of like victor mono, but less attention grabbing with the
      # script-ness. unfortunately suffers from some pretty bad character
      # cutoff in kitty, especially noticable with the character M
      nerd-fonts.fantasque-sans-mono
      # very tasteful and low profile, designed for letters to be as
      # distinguishable as possible. unforunately the bottoms of letters seem
      # to get cut off a bit in kitty
      nerd-fonts.mononoki

      # free and open source comic sans code which I would love to like, but it
      # suffers from a very distracting issue of an irregular baseline for the
      # characters
      #
      # nerd-fonts.comic-shanns-mono
      
      # cyberpunk hacker font thats actually readable. only issue is that some
      # characters are just too stylized and draw attention. these are the
      # square brackets, zero, comma, and semicolon, and probably others.
      ocr-a

      # non coding fonts or fonts I haven't tried for coding -----------------

      cozette
      tamzen
      envypn-font
      creep
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      liberation_ttf
      victor-mono
      tt2020
      arkpandora_ttf
      times-newer-roman
      spleen
      scientifica
      montserrat
      monocraft # fake bitmap
      unstable.garamond-libre
      gelasio
      comic-relief

      nerd-fonts.fira-code
      nerd-fonts.victor-mono
    ];

    # hardware ----------------------------------------------------------------
    # OpenGL
    hardware.graphics = {
      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux;
        [
          libva
          libvdpau-va-gl
          libva-vdpau-driver
        ]
        ++ lib.optionals config.services.pipewire.enable [pipewire];
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

    hardware.acpilight.enable = true;
    # backlight permissions
    services.udev.extraRules = ''
      SUBSYSTEM=="backlight", ACTION=="add", \
          RUN+="${pkgs.coreutils-full}/bin/chgrp video /sys/class/backlight/%k/brightness", \
          RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';
  };
}
