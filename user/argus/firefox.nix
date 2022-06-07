{ arkenfox-userjs, pkgs, ... }:
{
  programs.firefox =
    let
      baseUserJS = builtins.readFile "${arkenfox-userjs}/user.js";
      finalUserJS = baseUserJS + ''
        // homepage
        user_pref("browser.startup.homepage", "about:home");
        user_pref("browser.newtabpage.enabled", true);
        user_pref("browser.startup.page", 1);

        // disable the "master switch" that disables about:home
        //user_pref("browser.startup.homepage_override.mstone", "");

        // allow search engine searching from the urlbar
        user_pref("keyword.enabled", true);

        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

        user_pref("privacy.resistFingerprinting.letterboxing", false);

        // DRM content :(
        user_pref("media.gmp-widevinecdm.enabled", true);
        user_pref("media.eme.enabled", true);
      '';
    in
    {
      enable = true;
      package = pgks.firefox;

      extensions = [
        
      ];

      profiles = {
        name = "argus";
        id = 1;
        extraConfig = finalUserJS;
        isDefault = true;
      };
    };
}
