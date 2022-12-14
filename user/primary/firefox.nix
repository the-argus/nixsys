{
  firefox-addons,
  arkenfox-userjs,
  lib,
  pkgs,
  unstable,
  username,
  config,
  ...
}: {
  programs.firefox = let
    colors = with config.banner.palette; {
      firefox = let
        ffbg = base00;
        ffhi = highlight;
      in {
        userChrome = {
          # whole background
          bg = ffbg;
          # the url text
          urlbar-selected = ffhi; # rose pine 403C58
          # tab title text
          tabtext = ffhi; # rose pine 9BCED7

          # dont matter
          panel-disabled = ffbg; # rose pine f9f9fa
          arrowpanel = base05; # rose pine fefefa
          tab = urgent; # rose pine EA6F91
          tab-selected = urgent; # rose pine 403C58
          urlbar = ffhi; # rose pine 98c1d9
          urlbar-results = ffhi; # rose pine F1CA93
          sidebar = ffhi; # rose pine F1CA93
          tab-soundplaying = warn; # rose pine 9c89b8
          misc = hialt0; # rose pine ea6f91
        };
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
    assets = import ../../packages/firefox-assets {inherit pkgs;};
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
    package = unstable.firefox;

    # this is how you can set the gtk theme for firefox with home manager
    # package =
    #   let
    #     parentPackage = unstable.firefox;
    #     createSymlinkedFirefox = parent: pkgs.symlinkJoin
    #       {
    #         inherit (parent) name;
    #         paths = [ parent ];
    #         nativeBuildInputs = [ pkgs.makeWrapper ];
    #         postBuild = ''
    #           wrapProgram $out/bin/firefox \
    #             --set GTK_THEME "rose-pine-gtk"
    #         '';
    #       };
    #   in
    #   pkgs.emptyDirectory.overrideAttrs (oa: {
    #     override =
    #       let
    #         overridenFirefox = overrideFunc: (parentPackage.override) overrideFunc;
    #       in
    #       overrideFunc: (createSymlinkedFirefox (overridenFirefox overrideFunc));
    #   });

    extensions = with firefox-addons; [
      ublock-origin
      bitwarden
      vimium
    ];

    profiles = {
      ${username} = {
        name = username;
        id = 0;
        extraConfig = finalUserJS;
        userChrome = ''
          #fullscr-toggler { background-color: rgba(0, 0, 0, 0) !important; }
          :root {
            --uc-bg-color: #${colors.firefox.userChrome.bg};
            --uc-show-new-tab-button: none;
            --uc-show-tab-separators: none;
            --uc-tab-separators-color: none;
            --uc-tab-separators-width: none;
            --uc-tab-fg-color: #${colors.firefox.userChrome.tabtext};
            --autocomplete-popup-background: var(--mff-bg) !important;
            --default-arrowpanel-background: var(--mff-bg) !important;
            --default-arrowpanel-color: #${colors.firefox.userChrome.arrowpanel} !important;
            --lwt-toolbarbutton-icon-fill: var(--mff-icon-color) !important;
            --panel-disabled-color: #${colors.firefox.userChrome.panel-disabled}80;
            --toolbar-bgcolor: var(--mff-bg) !important;
            --urlbar-separator-color: transparent !important;
            --mff-bg: #${colors.firefox.userChrome.bg};
            --mff-icon-color: #${colors.firefox.userChrome.tabtext};
            --mff-nav-toolbar-padding: 8px;
            --mff-sidebar-bg: var(--mff-bg);
            --mff-sidebar-color: #${colors.firefox.userChrome.sidebar};
            --mff-tab-border-radius: 0px;
            --mff-tab-color: #${colors.firefox.userChrome.tab};
            --mff-tab-font-family: "${font}";
            --mff-tab-font-size: 11pt;
            --mff-tab-font-weight: 400;
            --mff-tab-height: 32px;
            --mff-tab-pinned-bg: #${colors.firefox.userChrome.tabtext};
            --mff-tab-selected-bg: #${colors.firefox.userChrome.tab-selected};
            --mff-tab-soundplaying-bg: #${colors.firefox.userChrome.tab-soundplaying};
            --mff-urlbar-color: #${colors.firefox.userChrome.urlbar};
            --mff-urlbar-focused-color: #${colors.firefox.userChrome.urlbar-selected};
            --mff-urlbar-font-family: "${font}";
            --mff-urlbar-font-size: 11pt;
            --mff-urlbar-font-weight: 700;
            --mff-urlbar-results-color: #${colors.firefox.userChrome.urlbar-results};
            --mff-urlbar-results-font-family: "${font}";
            --mff-urlbar-results-font-size: 11pt;
            --mff-urlbar-results-font-weight: 700;
            --mff-urlbar-results-url-color: #${colors.firefox.userChrome.urlbar};
          }

          #back-button > .toolbarbutton-icon{
            --backbutton-background: transparent !important;
            border: none !important;
          }

          #back-button {
            list-style-image: url("${assets}/left-arrow.svg") !important;
          }

          #forward-button {
            list-style-image: url("${assets}/right-arrow.svg") !important;
          }

          /* Options with pixel amounts could need to be adjusted, as this only works for my laptop's display */
          #titlebar {
            -moz-box-ordinal-group: 0 !important;
          }

          .tabbrowser-tab:not([fadein]),
          #tracking-protection-icon-container,
          #identity-box {
            display: none !important;
            border: none !important;
          }
          #urlbar-background, .titlebar-buttonbox-container, #nav-bar, .tabbrowser-tab:not([selected]) .tab-background{
              background: var(--uc-bg-color) !important;
            border: none !important;
          }
          #urlbar[breakout][breakout-extend] {
              top: calc((var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2) !important;
              left: 0 !important;
              width: 100% !important;
          }

          #urlbar[breakout][breakout-extend] > #urlbar-input-container {
              height: var(--urlbar-height) !important;
              padding-block: 0 !important;
              padding-inline: 0 !important;
          }

          #urlbar[breakout][breakout-extend] > #urlbar-background {
              animation-name: none !important;
              box-shadow: none !important;
          }
          #urlbar-background {
            box-shadow: none !important;
          }
          /*#tabs-newtab-button {
            display: var(--uc-show-new-tab-button) !important;
          }*/
          .tabbrowser-tab::after {
            border-left: var(--uc-tab-separators-width) solid var(--uc-tab-separators-color) !important;
            display: var(--uc-show-tab-separators) !important;
          }
          .tabbrowser-tab[first-visible-tab][last-visible-tab]{
            background-color: var(--uc-bar-bg-color) !important;
          }
          .tab-close-button.close-icon {
            display: none !important;
          }
          .tabbrowser-tab:hover .tab-close-button.close-icon {
            display: block !important;
          }
          #urlbar-input {
            text-align: center !important;
            color: var(--mff-urlbar-focused-color) !important;
          }
          #urlbar-input:focus {
            text-align: left !important;
          }
          #urlbar-container {
            margin-left: 3vw !important;
          }
          .tab-text.tab-label {
            color: var(--uc-tab-fg-color) !important;
          }
          #navigator-toolbox {
            border-bottom: 0px solid #${colors.firefox.userChrome.misc} !important;
            background: var(--uc-bg-color) !important;
          }

          .urlbar-icon > image {
            fill: var(--mff-icon-color) !important;
            color: var(--mff-icon-color) !important;
          }

          .toolbarbutton-text {
            color: var(--mff-icon-color)  !important;
          }
          .urlbar-icon {
            color: var(--mff-icon-color)  !important;
          }
        '';

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
