{
  config,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        modules-left = [
          "sway/window"
          "sway/mode"
        ];
        modules-center = ["sway/workspaces"];
        modules-right = [
          "custom/media"
          "tray"
          "network"
          "battery"
          "clock"
          "custom/powerbutton"
        ];
        margin-left = 0;
        margin-right = 0;
        margin-top = 0;
        margin-bottom = 0;
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "sway/window" = {
          format = "{}";
          all-outputs = true;
          max-length = 70;
        };
        clock = {
          format = "{:%I:%M %p}";
          format-alt = "{:%a, %d. %b  %H:%M}";
        };
        tray = {
          icon-size = 20;
          spacing = 10;
          show-passive-items = false;
        };
        network =
          {
            format = "{ifname}";
            format-wifi = "{essid} ";
            format-disconnected = ""; # An empty format will hide the module.
            tooltip-format-wifi = ''{signalStrength}% strength,\n{frequency} MHz.'';
            tooltip-format-disconnected = "Disconnected";
            max-length = 50;
          }
          // (
            if config.system.hardware.usesWireless
            then {
              on-click = "nm-connection-editor";
            }
            else {}
          );
        "custom/media" = {
          format = "{icon}{}";
          return-type = "json";
          format-icons = {
            Playing = " ";
            Paused = " ";
          };
          max-length = 50;
          exec = ''playerctl metadata --format '{\"text\": \"{{title}}\", \"tooltip\": \"{{playerName}} : {{title}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F'';
          on-click = "playerctl play-pause";
          on-scroll-down = "playerctl next";
          on-scroll-up = "playerctl previous";
        };
        "custom/powerbutton" = {
          format = "⏻";
          max-length = 50;
          on-click = "~/.scripts/rofi-powermenu.sh";
        };
      }
    ];

    style = let
      mkCssColor = name: color: ''@define-color ${name} #${color};'';
      font = config.system.theme.font.display;
    in ''
      /*  insert the nix configured banner palette as css */
      ${builtins.concatStringsSep "\n"
        (lib.lists.remove (mkCssColor "author" config.banner.palette.author)
          (lib.lists.remove (mkCssColor "scheme" config.banner.palette.scheme)
            (lib.attrsets.mapAttrsToList mkCssColor config.banner.palette)))}

      * {
      	border: none;
      	border-radius: 0;
      	font-family: "${font.name}";
      	font-size: ${builtins.toString font.size}px;
      	min-height: 0;
      	margin: 0px;
      }

      window#waybar {
      	/*background: #000000;*/
        /* TRANSPARENT */
      	/* background: rgba(0, 0, 0, 0); */
        background: @base02;
        color: @base05;
        /* border-radius: 8px; */
      }

      #workspaces {
      	padding: 0px;
      	margin: 0px;
      }

      #workspaces button {
        border-radius: 0px;
      	/*background: transparent;*/
        background: @base00;
      	/*color: @highlight;*/
        color: @base03;
        /*background-color: @pfg-highlight;*/
      	font-weight: bold;
      	/*border: 2px solid @highlight;*/
      	border: 0px solid @base00;
        border-radius: 0px;
        padding: 6px 9px 5px 10px;
        margin: 0px 4px;
      }
      #workspaces button:hover {
      	box-shadow: inherit;
      	text-shadow: inherit;
      }

      #workspaces button.focused {
        background: @highlight;
        color: @pfg-highlight;
      }

      #workspaces button.urgent {
      	background: @urgent;
      	color: @pf-urgent;
      }

      #mode {
      	background: @hialt0;
      	color: @pfg-hialt0;
        padding: 10px 0px;
      }
      #clock, #custom-powerbutton, #custom-media, #window, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
        background: @highlight;
        color: @pfg-highlight;
        border-radius: 0px;
        padding: 6px 20px 4px 20px;
      }

      window#waybar.empty #window {
        background:none;
      }

      #window {
      	font-weight: bold;
      }

      #clock {
      }

      #battery {
        background: @hialt1;
        color: @pfg-hialt0;
      }

      #battery icon {
        color: red;
      }

      #battery.charging {
      }

      @keyframes blink {
        to {
          background-color: @base05;
        }
      }

      #battery.warning:not(.charging) {
      	background-color: @base01;
      	color: @warn;
      }

      #battery.critical:not(.charging) {
        color: @urgent;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #cpu {
      }

      #memory {
      }

      #network {
        background: @hialt0;
        color: @pfg-hialt0;
      }

      #network.disconnected {
        background: @base00;
        color: @base05;
      }

      #pulseaudio {
      }

      #pulseaudio.muted {
      }

      #custom-media {
        /* spotify color */
        /* color: rgb(102, 220, 105); */
      }

      #custom-powerbutton {
        background: @base05;
        color: @base02;
      	font-weight: bold;
      	font-size: ${builtins.toString (font.size + 2)}px;
        padding: 5px 10px 0px 10px;
      	margin: 0 0 0 0px;
      }

      #tray {
        /*padding: 0px 8px 3px 0px;*/
        background: @ansi00;
        color: @ansi07;
      }
    '';
  };
}
