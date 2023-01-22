{
  lib,
  useDefaultColors ? false,
  colors ?
    if useDefaultColors
    then "default"
    else (abort "you must define colors to use a userchrome"),
  useSideView ? false,
  useTabCenterVerticalTabs ? false,
  ...
}: let
  src = ./chrome;
  integrations = ./integrations;

  originalColorsCSS = ''
    @media (prefers-color-scheme: dark) { :root {

      /* These colours are (mainly) used by the
         Container Tabs Plugin */
      --uc-identity-colour-blue:      #7ED6DF;
      --uc-identity-colour-turquoise: #55E6C1;
      --uc-identity-colour-green:     #B8E994;
      --uc-identity-colour-yellow:    #F7D794;
      --uc-identity-colour-orange:    #F19066;
      --uc-identity-colour-red:       #FC5C65;
      --uc-identity-colour-pink:      #F78FB3;
      --uc-identity-colour-purple:    #786FA6;

      /*  Cascades main Colour Scheme */
      --uc-base-colour:               #1E2021;
      --uc-highlight-colour:          #191B1C;
      --uc-inverted-colour:           #FAFAFC;
      --uc-muted-colour:              #AAAAAC;
      --uc-accent-colour:             var(--uc-identity-colour-purple);

    }}


    @media (prefers-color-scheme: light) { :root {

      /* These colours are (mainly) used by the
         Container Tabs Plugin */
      --uc-identity-colour-blue:      #1D65F5;
      --uc-identity-colour-turquoise: #209FB5;
      --uc-identity-colour-green:     #40A02B;
      --uc-identity-colour-yellow:    #E49320;
      --uc-identity-colour-orange:    #FE640B;
      --uc-identity-colour-red:       #FC5C65;
      --uc-identity-colour-pink:      #EC83D0;
      --uc-identity-colour-purple:    #822FEE;

      /*  Cascades main Colour Scheme */
      --uc-base-colour:               #FAFAFC;
      --uc-highlight-colour:          #DADADC;
      --uc-inverted-colour:           #1E2021;
      --uc-muted-colour:              #191B1C;
      --uc-accent-colour:             var(--uc-identity-colour-purple);

    }}
  '';

  customColorsCSS = ''
    :root {
      /* These colours are (mainly) used by the
         Container Tabs Plugin */
      --uc-identity-colour-blue:      #${colors.ansi04};
      --uc-identity-colour-turquoise: #${colors.ansi06};
      --uc-identity-colour-green:     #${colors.ansi02};
      --uc-identity-colour-yellow:    #${colors.ansi03};
      --uc-identity-colour-orange:    #${colors.hialt1};
      --uc-identity-colour-red:       #${colors.ansi01};
      --uc-identity-colour-pink:      #${colors.hialt0};
      --uc-identity-colour-purple:    #${colors.ansi05};

      /*  Cascades main Colour Scheme */
      --uc-base-colour:               #${colors.base00};
      --uc-highlight-colour:          #${colors.highlight};
      --uc-inverted-colour:           #${colors.pfg-highlight};
      --uc-muted-colour:              #${colors.base03};
      --uc-accent-colour:             #${colors.hialt0};
    }
  '';

  colorsCSS =
    builtins.toFile "colors.css"
    (
      if colors == "default"
      then originalColorsCSS
      else customColorsCSS
    );
in
  ''
    @import '${colorsCSS}';
    @import '${src}/userChrome.css';
  ''
  + (lib.strings.optionalString useSideView "@import '${integrations}/side-view/cascade-sideview.css';")
  + (lib.strings.optionalString useTabCenterVerticalTabs ''
    @import '${integrations}/tabcenter-reborn/cascade-tcr.css';
    @import '${integrations}/tabcenter-reborn/tabcenter-reborn.css';
  '')
