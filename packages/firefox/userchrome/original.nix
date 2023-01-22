{
  colors ? (abort "you must define colors to use a userchrome"),
  font ? (abort "you must define a font to use a userchrome"),
  callPackage,
  ...
}: let
  assets = callPackage ../../firefox-assets {};
  userChrome = let
    ffbg = colors.base00;
    ffhi = colors.highlight;
  in {
    # whole background
    bg = ffbg;
    # the url text
    urlbar-selected = ffhi; # rose pine 403C58
    # tab title text
    tabtext = ffhi; # rose pine 9BCED7

    # dont matter
    panel-disabled = ffbg; # rose pine f9f9fa
    arrowpanel = colors.base05; # rose pine fefefa
    tab = colors.urgent; # rose pine EA6F91
    tab-selected = colors.urgent; # rose pine 403C58
    urlbar = ffhi; # rose pine 98c1d9
    urlbar-results = ffhi; # rose pine F1CA93
    sidebar = ffhi; # rose pine F1CA93
    tab-soundplaying = colors.warn; # rose pine 9c89b8
    misc = colors.hialt0; # rose pine ea6f91
  };
in ''
  #fullscr-toggler { background-color: rgba(0, 0, 0, 0) !important; }
  :root {
    --uc-bg-color: #${userChrome.bg};
    --uc-show-new-tab-button: none;
    --uc-show-tab-separators: none;
    --uc-tab-separators-color: none;
    --uc-tab-separators-width: none;
    --uc-tab-fg-color: #${userChrome.tabtext};
    --autocomplete-popup-background: var(--mff-bg) !important;
    --default-arrowpanel-background: var(--mff-bg) !important;
    --default-arrowpanel-color: #${userChrome.arrowpanel} !important;
    --lwt-toolbarbutton-icon-fill: var(--mff-icon-color) !important;
    --panel-disabled-color: #${userChrome.panel-disabled}80;
    --toolbar-bgcolor: var(--mff-bg) !important;
    --urlbar-separator-color: transparent !important;
    --mff-bg: #${userChrome.bg};
    --mff-icon-color: #${userChrome.tabtext};
    --mff-nav-toolbar-padding: 8px;
    --mff-sidebar-bg: var(--mff-bg);
    --mff-sidebar-color: #${userChrome.sidebar};
    --mff-tab-border-radius: 0px;
    --mff-tab-color: #${userChrome.tab};
    --mff-tab-font-family: "${font}";
    --mff-tab-font-size: 11pt;
    --mff-tab-font-weight: 400;
    --mff-tab-height: 32px;
    --mff-tab-pinned-bg: #${userChrome.tabtext};
    --mff-tab-selected-bg: #${userChrome.tab-selected};
    --mff-tab-soundplaying-bg: #${userChrome.tab-soundplaying};
    --mff-urlbar-color: #${userChrome.urlbar};
    --mff-urlbar-focused-color: #${userChrome.urlbar-selected};
    --mff-urlbar-font-family: "${font}";
    --mff-urlbar-font-size: 11pt;
    --mff-urlbar-font-weight: 700;
    --mff-urlbar-results-color: #${userChrome.urlbar-results};
    --mff-urlbar-results-font-family: "${font}";
    --mff-urlbar-results-font-size: 11pt;
    --mff-urlbar-results-font-weight: 700;
    --mff-urlbar-results-url-color: #${userChrome.urlbar};
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
    border-bottom: 0px solid #${userChrome.misc} !important;
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
''
