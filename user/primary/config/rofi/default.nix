{
  pkgs,
  config,
  ...
}: let
  font-lookups = {
    # replacements for fonts that don't work or look better in other versions
    "Victor Mono" = {
      name = "Fira Code Semibold";
      size = 14;
      package = pkgs.fira-code;
    };
  };

  replaceFont =
    builtins.hasAttr
    config.system.theme.font.display.name
    font-lookups;

  font = let
    inherit (config.system.theme.font) display;
  in
    if replaceFont
    then font-lookups.${display.name}
    else display;

  rasi = ''
    /*
     *
     * Author  : Aditya Shakya
     * Mail    : adi1090x@gmail.com
     * Github  : @adi1090x
     * Twitter : @adi1090x
     *
     */

    configuration {
    	font:							"${font.name} ${builtins.toString font.size}";
      show-icons:                     true;
    	icon-theme: 					"rose-pine-icons";
      display-drun: 					"";
      drun-display-format:            "{name}";
      disable-history:                false;
    	sidebar-mode: 					false;
    	padding:			0% 0% 0% 0%;
    }

    * {
      background:                     #00000060;
      background-alt:                 #00000000;
      background-bar:                 #f2f2f215;
      foreground:                     #f2f2f2EE;
      accent:                         #ffffff66;
    }

    window {
      transparency:                   "real";
      background-color:               @background;
      text-color:                     @foreground;
    	border:							0px;
    	border-color:					@border;
      border-radius:                  0px;
    	width:							100%;
    	height:							100%;
    }

    prompt {
      enabled: 						true;
    	padding: 						-0.4% 0.7% -0.9% 0%;
    	background-color: 				@background-alt;
    	text-color: 					@foreground;
    	font:							"Fira Code Semibold 14";
    }

    entry {
      background-color:               @background-alt;
      text-color:                     @foreground;
      placeholder-color:              @foreground;
      expand:                         true;
      horizontal-align:               0.5;
      placeholder:                    "Search";
      padding:                        0.0% 0% 0% 0%;
      blink:                          true;
    }

    inputbar {
    	children: 						[ prompt, entry ];
      orientation:                    vertical;
      background-color:               @background-bar;
      text-color:                     @foreground;
      expand:                         false;
    	border:							0.1%;
      border-radius:                  6px;
    	border-color:					@accent;
      margin:                         0% 30% 0% 30%;
      padding:                        0% 1% 1% 1%;
    }

    listview {
      background-color:               @background-alt;
      columns:                        4;
      lines:                          4;
      spacing:                        2%;
      cycle:                          false;
      dynamic:                        true;
      layout:                         vertical;
    }

    mainbox {
      background-color:               @background-alt;
    	border:							0% 0% 0% 0%;
      border-radius:                  0% 0% 0% 0%;
    	border-color:					@accent;
      children:                       [ inputbar, listview ];
      spacing:                       	8%;
      padding:                        10% 8.5% 10% 8.5%;
    }

    element {
      background-color:               @background-alt;
      text-color:                     @foreground;
      orientation:                    vertical;
      border-radius:                  0%;
      padding:                        2.5% 0% 2.5% 0%;
    }

    element-icon {
      background-color: 				@background-alt;
      text-color:       				inherit;
      horizontal-align:               0.5;
      vertical-align:                 0.5;
      size:                           64px;
      border:                         0px;
    }

    element-text {
      background-color: 				@background-alt;
      text-color:       				inherit;
      expand:                         true;
      horizontal-align:               0.5;
      vertical-align:                 0.5;
      margin:                         0.5% 0.5% -0.5% 0.5%;
    }

    element selected {
      background-color:               @background-bar;
      text-color:                     @foreground;
    	border:							0% 0% 0% 0%;
      border-radius:                  12px;
      border-color:                  	@accent;
    }
  '';
in {
  home.file = {
    ".config/rofi/launchpad.rasi" = {
      source = rasi;
    };
  };

  home.packages = pkgs.lib.lists.optionals replaceFont [font.package];
}
