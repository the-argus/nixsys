{ pkgs, ... }:
{
  fluent = pkgs.fetchgit {
    url = "https://github.com/DiscordStyles/Fluent";
    rev = "7a7b62e89648d845c7b388aab0a77febb628ea4b";
    sha256 = "0lz8h48wf1ja31yb9sb8n7a2gfwncqldf8dar7d0k8wcl09z782y";
  };

  softx = pkgs.fetchgit {
    url = "https://github.com/DiscordStyles/SoftX";
    rev = "ef11558a47b3ce6b590e8d8ea47e34fc1de32d9c";
    sha256 = "1b8k640jymd6hcqr9930i6m98ihxcya18biaazsp5hcvkxh25ac6";
  };

  rosepine = pkgs.fetchgit {
    url = "https://github.com/rose-pine/discord";
    rev = "fafe99d677079a07d00e37e9b455641c194444e1";
    sha256 = "0wl0f1jgqmfgfxmgahkwhpx4ngnm57gsyv663p2mn552768iihl3";
  };

  slate = pkgs.fetchgit {
    url = "https://github.com/DiscordStyles/Slate";
    rev = "9eda73ab6a05be53fcf4879c3ca7543bd6d02c9e";
    sha256 = "06sdlvk8v90x9x5m8qxpmxxhq6g9cbn8yw7acwi0j08h9qrsg0a0";
  };

  lavender = pkgs.fetchgit {
    url = "https://github.com/Lavender-Discord/Lavender";
    rev = "a3a3b3692f13a2e4f717960476ffe6e30a1febae";
    sha256 = "08zyzd57d6h5rlg1mxscxfd055vg8pyd490rg90wp303a6a0igm3";
  };

  darkmatter = pkgs.fetchgit {
    url = "https://github.com/DiscordStyles/DarkMatter";
    rev = "50a19c54b417357aadd885e38fc222db0b8f6520";
    sha256 = "0wjwxdhjdixmzgayb0r70hj65w8jsd47ifha9hxrrkzk6ws3fl58";
  };

  mkFrostedGlass = url: (pkgs.stdenv.mkDerivation {
    name = "webcord-frosted-glass-theme";
    src = pkgs.fetchgit {
      url = "https://github.com/DiscordStyles/FrostedGlass";
      rev = "2a90edc19f7c30dd6cbb4aaa99f9d5f15d69f093";
      sha256 = "08g5hhm59c2qypppx3jf4afms7zsk8gq2xzwa1l1ak9l8pz075b7";
    };

    patchPhase = ''
      # replace default url with ours
      sed -i "s|https://i.imgur.com/kYW2H5C.jpg|${url}|g" "FrostedGlass.theme.css"
    '';

    dontPatch = false;
    installPhase = "cp -r . $out";
  });

  nordic = pkgs.fetchgit {
    url = "https://github.com/orblazer/discord-nordic";
    rev = "9808387ffcd2824e5b9a440f7e5e15ba2c8b7d00";
    sha256 = "0ahrwxkla9gqjlgff337jcna20v5ncxlkcyssli89k75axvypzr1";
  };

  inScheme = with (pkgs.callPackage ../themes.nix {}).scheme; let
    font = (pkgs.callPackage ../themes.nix {}).font.display;
    # light mode literally not supported lol
    css = builtins.toFile "scheme.theme.css" ''
      .theme-dark {
          --background-primary: #${altfg2};
          --background-secondary: #${altbg2};
          --background-secondary-alt: #${altfg2};
          --channeltextarea-background: #${altbg};
          --background-tertiary: #${bg};
          --background-accent: #${hi1};
          --text-normal: #${fg};
          --text-spotify: #${green};
          --text-muted: #${altfg3};
          --text-link: #${blue};
          --background-floating: #${altbg2};
          --header-primary: #${fg};
          --header-secondary: #${blue};
          --header-spotify: #${blue};
          --interactive-normal: #${fg};
          --interactive-hover: #${hi1};
          --interactive-active: #${fg};
          --ping: #${red};
          --background-modifier-selected: #${altfg2}b4;
          --scrollbar-thin-thumb: #${bg}; 
          --scrollbar-thin-track: transparent; 
          --scrollbar-auto-thumb: #${bg}; 
          --scrollbar-auto-track: transparent; 
      }

      .theme-light {
          --background-primary: #faf4ed;
          --background-secondary: #fffaf3;
          --background-secondary-alt: #f2e9de;
          --channeltextarea-background: #f2e9de;
          --background-tertiary: #f2e9de;
          --background-accent: #d7827e;
          --text-normal: #575279;
          --text-spotify: #575279;
          --text-muted: #6e6a86;
          --text-link: #286983;
          --background-floating: #f2e9de;
          --header-primary: #575279;
          --header-secondary: #575279;
          --header-spotify: #56949f;
          --interactive-normal: #575279;
          --interactive-hover: #6e6a86;
          --interactive-active: #575279;
      }

      body {
          --font-display: ${font.name};
      }

      .body-2wLx-E, .headerTop-3GPUSF, .bodyInnerWrapper-2bQs1k, .footer-3naVBw {
          background-color: var(--background-tertiary);
      }

      .title-17SveM, .name-3Uvkvr{
          font-size: ${builtins.toString font.size}px;
      }

      .panels-3wFtMD {
          background-color: var(--background-secondary);
          padding-left: 5px;
          padding-right: 5px;
      }

      .username-h_Y3Us {
          font-family: var(--font-display);
          font-size: ${builtins.toString font.size}px;
      }

      .peopleColumn-1wMU14, .panels-j1Uci_, .peopleColumn-29fq28, .peopleList-2VBrVI, .content-2hZxGK, .header-1zd7se, .root-g14mjS .small-23Atuv .fullscreenOnMobile-ixj0e3{
          background-color: var(--background-secondary);
      }

      .textArea-12jD-V, .lookBlank-3eh9lL,  .threadSidebar-1o3BTy, .scrollableContainer-2NUZem, .perksModalContentWrapper-3RHugb, .theme-dark .footer-31IekZ, .theme-light .footer-31IekZ{
          background-color: var(--background-tertiary);
      }

      .numberBadge-2s8kKX, .base-PmTxvP, .baseShapeRound-1Mm1YW, .bar-30k2ka, .unreadMentionsBar-1Bu1dC, .mention-1f5kbO, .active-1SSsBb, .disableButton-220a9y {
          background-color: var(--ping) !important;
      }

      .lookOutlined-3sRXeN.colorRed-1TFJan, .lookOutlined-3sRXeN.colorRed-1TFJan {
          color: var(--ping) !important;
      }

      .header-3OsQeK, .container-ZMc96U {
          box-shadow: none!important;
          border: none!important;
      }

      .content-1gYQeQ, .layout-1qmrhw, .inputDefault-3FGxgL, .input-2g-os5, .input-2z42oC, .role-2TIOKu, .searchBar-jGtisZ {
          border-radius: 6px;
      }

      .layout-1qmrhw:hover, .content-1gYQeQ:hover {
          background-color: var(--background-modifier-selected)!important;
      }
    '';
  in
  (pkgs.stdenv.mkDerivation {
    name = "discord-theme-in-color";
    buildPhase = ''
    '';
    installPhase = ''
        mkdir $out
        cp ${css} $out/scheme.theme.css
    '';
    dontUnpack = true;
  });
}
