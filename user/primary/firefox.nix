{
  firefox-addons,
  arkenfox-userjs,
  lib,
  pkgs,
  username,
  config,
  ...
}: {
  programs.firefox = let
    colors = with config.banner.palette; {
      firefox = let
        # try to make this match nixsys/packages/firefox/userchrome/original.nix
        ffbg = base00;
      in {
        # user content (home page)
        userContent = {
          # dark colors
          d2 = ffbg; #"1F1D29";
          d4 = base06; #"30333d";

          # word colors
          w1 = hialt0; # "ccaced";
          w2 = base05; #"c0c0c0";
          w3 = base05; #"dfd7d7";

          # light colors
          l1 = base05; #"e1e0e6";
          l2 = base05; #"adabb9";
          l3 = base07; # "9795a3";
          l4 = base05; #"878492";

          # other colors
          o1 = link; #"332e56";
          o2 = base02; #"4b4757";

          # dont matter
          d1 = urgent; # "30333d";
          d3 = base02; #"585e74";
          o3 = urgent; #"33313c";
        };
      };
    };
    baseUserJS = builtins.readFile "${arkenfox-userjs}/user.js";
    font = config.system.theme.font.display.name;
    finalUserJS = lib.strings.concatStrings [
      baseUserJS
      ''
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

        user_pref("browser.startup.page", 3);
        user_pref("privacy.clearOnShutdown.history", false);

        // Enable CSD
        user_pref("browser.tabs.drawInTitlebar", true);

        // Set UI density to normal
        user_pref("browser.uidensity", 0);
      ''
    ];
  in {
    enable = true;

    profiles = {
      ${username} = {
        name = username;
        id = 0;
        extraConfig = finalUserJS;
        extensions.packages = with firefox-addons; [
          ublock-origin
          vimium
        ];
        userChrome = pkgs.myPackages.firefoxPackages.userChrome.mkCascade {
          colors = config.banner.palette;
          inherit font;
        };

        userContent = ''
          :root {
          	--dark_color1: #${colors.firefox.userContent.d1};
          	--dark_color2: #${colors.firefox.userContent.d2};
          	--dark_color3: #${colors.firefox.userContent.d3};
          	--dark_color4: #${colors.firefox.userContent.d4};

          	--word_color1: #${colors.firefox.userContent.w1};
          	--word_color2: #${colors.firefox.userContent.w2};
          	--word_color3: #${colors.firefox.userContent.w3};

          	--light_color1: #${colors.firefox.userContent.l1};
          	--light_color2: #${colors.firefox.userContent.l2};
          	--light_color3: #${colors.firefox.userContent.l3};
          	--light_color4: #${colors.firefox.userContent.l4};

          	--other_color1: #${colors.firefox.userContent.o1};
          	--other_color2: #${colors.firefox.userContent.o2};
          	--other_color3: #${colors.firefox.userContent.o3};
          }
          /*================ LIGHT THEME ================*/
          @media {
          :root:not([style]),
          :root[style*="--lwt-accent-color:rgb(227, 228, 230);"] {
          	--base_color1: var(--light_color1);
          	--base_color2: var(--light_color2);
          	--base_color3: var(--light_color3);
          	--base_color4: var(--light_color4);

          	--outer_color1: var(--other_color1);
          	--outer_color2: var(--other_color2);
          	--outer_color3: var(--other_color3);

          	--orbit_color: var(--dark_color3);
          }
          }
          /*================ DARK THEME ================*/
          @media {
          :root[style*="--lwt-accent-color:rgb(12, 12, 13);"] {
          	--base_color1: var(--dark_color1);
          	--base_color2: var(--dark_color2);
          	--base_color3: var(--dark_color3);
          	--base_color4: var(--dark_color4);

          	--outer_color1: var(--word_color1);
          	--outer_color2: var(--word_color2);
          	--outer_color3: var(--word_color3);

          	--orbit_color: var(--light_color3);
          }
          }

          /*============== PRIVATE THEME ==============*/
          @media {
          :root[privatebrowsingmode=temporary] {
          	--base_color1: #291D4F;
          	--base_color2: #3C3376;
          	--base_color3: #4F499D;
          	--base_color4: #625FC4;

          	--outer_color1: #E571F0;
          	--outer_color2: #D9CAF1;
          	--outer_color3: #FFF5FF;

          	--orbit_color: #B39FE3;
          }
          }

          @-moz-document url(about:blank), url(about:newtab), url(about:home) {
              html:not(#ublock0-epicker),
              html:not(#ublock0-epicker) body,
              #newtab-customize-overlay {
                  background: var(--dark_color2) !important;
              }

              .search-wrapper input {
                  background-color: var(--dark_color2) !important;
                  color: var(--dark_color2) !important;
                  border: none !important;
                  box-shadow: none !important;
              }

              .search-wrapper input:focus {
                  color: var(--dark_color2) !important;
              }

              .search-wrapper .search-button {
                  fill: var(--dark_color2) !important;
              }

              .search-wrapper .search-button:focus,
              .search-wrapper .search-button:hover {
                  background-color: transparent !important;
                  fill: var(--dark_color2) !important;
              }
          }

          /* Scrollbar */

          *:not(select) {
              scrollbar-color: var(--dark_color4) var(--dark_color1) !important;
              scrollbar-width: thin !important;
          }
          ::-webkit-scrollbar,
          .integrations-select-repos::-webkit-scrollbar {
              max-height: var(--scrollbar-chrome-size) !important;
              max-width: var(--scrollbar-chrome-size) !important;
          }
          ::-webkit-scrollbar,
          .integrations-select-repos::-webkit-scrollbar,
          ::-webkit-scrollbar-corner,
          .integrations-select-repos::-webkit-scrollbar-corner,
          ::-webkit-scrollbar-track,
          .integrations-select-repos::-webkit-scrollbar-track,
          ::-webkit-scrollbar-track-piece,
          .integrations-select-repos::-webkit-scrollbar-track-piece {
              background: var(--dark_color1) !important;
          }
          ::-webkit-scrollbar:hover,
          .integrations-select-repos::-webkit-scrollbar:hover,
          ::-webkit-scrollbar-corner:hover,
          .integrations-select-repos::-webkit-scrollbar-corner:hover,
          ::-webkit-scrollbar-track:hover,
          .integrations-select-repos::-webkit-scrollbar-track:hover,
          ::-webkit-scrollbar-track-piece:hover,
          .integrations-select-repos::-webkit-scrollbar-track-piece:hover {
              background: var(--dark_color3) !important;
          }
          ::-webkit-scrollbar-thumb,
          .integrations-select-repos::-webkit-scrollbar-thumb {
              background: var(--dark_color4) !important;
              border-radius: var(--scrollbar-chrome-radius) !important;
          }
          ::-webkit-scrollbar-thumb:hover,
          .integrations-select-repos::-webkit-scrollbar-thumb:hover {
              background: var(--other_color1) !important;
          }
        '';
      };
    };
  };
}
