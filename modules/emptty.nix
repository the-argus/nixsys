{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types mkDefault;
  inherit (lib.strings) optionalString;
  cfg = config.services.xserver.displayManager.emptty;

  defaultConfig = {
    # 1:1 with https://github.com/tvrzna/emptty/blob/master/res/conf
    TTY_NUMBER = 7;
    SWITCH_TTY = true;
    PRINT_ISSUE = true;
    PRINT_MOTD = true;
    DEFAULT_USER = null;
    AUTOLOGIN = false;
    AUTOLOGIN_SESSION = null;
    AUTOLOGIN_MAX_RETRY = null;
    LANG = null;
    DBUS_LAUNCH = true;
    XINITRC_LAUNCH = false;
    VERTICAL_SELECTION = false;
    LOGGING = null;
    LOGGING_FILE = null;
    XORG_ARGS = null;
    DYNAMIC_MOTD = null;
    DYNAMIC_MOTD_PATH = null;
    MOTD_PATH = null;
    FG_COLOR = null;
    BG_COLOR = null;
    ENABLE_NUMLOCK = null;
    SESSION_ERROR_LOGGING = null;
    SESSION_ERROR_LOGGING_FILE = null;
    DEFAULT_XAUTHORITY = null;
    ROOTLESS_XORG = null;
    IDENTIFY_ENVS = false;
  };

  # TODO: update this to include all colors
  availableColors = ["BLACK" "LIGHT_BLACK"];

  empttyToString = type:
    if builtins.typeOf type == "bool"
    then
      (
        if type
        then "true"
        else "false"
      )
    else builtins.toString type;

  optionsToString = optionsSet:
    lib.attrsets.mapAttrsToList
    (name: value: (
      optionalString (value != null) "${name}=${empttyToString value}"
    ))
    optionsSet;
in {
  options = {
    services.xserver.displayManager.emptty = {
      enable = mkEnableOption (lib.mdDoc "Whether to enable emptty as the display manager.");

      package = mkOption {
        type = types.package;
        default = pkgs.myPackages.emptty;
        description = lib.mdDoc "Derivation to use for emptty.";
      };

      restart = mkOption {
        type = types.bool;
        default = true;
        # TODO: set up autologin to see if this is actually true for emptty. it
        # is true for greetd
        description = lib.mdDoc ''
          Whether to restart emptty when it terminates (e.g. on failure).
          This is usually desirable so a user can always log in, but should be disabled when using autologin,
          because every emptty restart will trigger the autologin again.
        '';
      };

      configuration = mkOption {
        default = defaultConfig;
        type = types.submodule {
          options = {
            TTY_NUMBER = mkOption {
              type = types.int;
              default = defaultConfig.TTY_NUMBER;
              description = lib.mdDoc "TTY where emptty will start.";
            };
            SWITCH_TTY = mkOption {
              type = types.bool;
              default = defaultConfig.SWITCH_TTY;
              description = lib.mdDoc "Enables switching to defined TTY number.";
            };
            PRINT_ISSUE = mkOption {
              type = types.bool;
              default = defaultConfig.PRINT_ISSUE;
              description = lib.mdDoc "Enables printing of /etc/issue in daemon mode.";
            };
            PRINT_MOTD = mkOption {
              type = types.bool;
              default = defaultConfig.PRINT_MOTD;
              description = lib.mdDoc "Enables printing of default motd, /etc/emptty/motd or /etc/emptty/motd-gen.sh.";
            };
            DEFAULT_USER = mkOption {
              type = types.nullOr types.string;
              default = defaultConfig.DEFAULT_USER;
              description = lib.mdDoc "Preselected user, if AUTOLOGIN is enabled, this user is logged in.";
            };
            AUTOLOGIN = mkOption {
              type = types.bool;
              default = defaultConfig.AUTOLOGIN;
              description = lib.mdDoc "Enables Autologin, if DEFAULT_USER is defined and part of nopasswdlogin group.";
            };
            AUTOLOGIN_SESSION = mkOption {
              type = types.nullOr types.string;
              default = defaultConfig.AUTOLOGIN_SESSION;
              description =
                lib.mdDoc
                "The default session used, if Autologin is enabled. If session is not found in list of sessions, it proceeds to manual selection.";
              example = "i3";
            };
            AUTOLOGIN_MAX_RETRY = mkOption {
              type = types.nullOr types.int;
              default = defaultConfig.AUTOLOGIN_MAX_RETRY;
              description = lib.mdDoc "If Autologin is enabled and session does not start correctly, the number of retries in short period is kept to eventually stop the infinite loop of restarts. -1 is for infinite retries, 0 is for no retry.";
            };
            LANG = mkOption {
              type = types.nullOr types.string;
              default = defaultConfig.LANG;
              description = lib.mdDoc "Default LANG, if user does not have set own in init script.";
              example = "en_US.UTF-8";
            };
            DBUS_LAUNCH = mkOption {
              type = types.bool;
              default = defaultConfig.DBUS_LAUNCH;
              description = lib.mdDoc "Starts desktop with calling \"dbus-launch\".";
            };
            XINITRC_LAUNCH = mkOption {
              type = types.bool;
              default = defaultConfig.XINITRC_LAUNCH;
              description = lib.mdDoc "Starts Xorg desktop with calling \"~/.xinitrc\" script, if is true, file exists and selected WM/DE is Xorg session, it overrides DBUS_LAUNCH.";
            };
            VERTICAL_SELECTION = mkOption {
              type = types.bool;
              default = defaultConfig.XINITRC_LAUNCH;
              description = lib.mdDoc "Prints available WM/DE each on new line instead of printing on single line.";
            };
            LOGGING = mkOption {
              type = types.nullOr (types.enum ["default" "appending" "disabled"]);
              default = defaultConfig.LOGGING;
              description = lib.mdDoc "Defines the way, how is logging handled. Possible values are \"default\", \"appending\" or \"disabled\".";
            };
            LOGGING_FILE = mkOption {
              type = types.nullOr (types.oneOf [types.string types.path]);
              default = defaultConfig.LOGGING_FILE;
              description = lib.mdDoc "Overrides path of log file";
              example = "/var/log/emptty/$\{TTY_NUMBER}.log";
            };
            XORG_ARGS = mkOption {
              type = types.nullOr types.string;
              default = defaultConfig.XORG_ARGS;
              description = lib.mdDoc "Arguments passed to Xorg server.";
            };
            DYNAMIC_MOTD = mkOption {
              type = types.nullOr types.bool;
              default = defaultConfig.DYNAMIC_MOTD;
              description = lib.mdDoc "Allows to use dynamic motd script to generate custom MOTD.";
            };
            DYNAMIC_MOTD_PATH = mkOption {
              type = types.nullOr (types.oneOf [types.package types.string types.path]);
              default = defaultConfig.DYNAMIC_MOTD_PATH;
              description = lib.mdDoc "Overrides the default path to the dynamic motd.";
            };
            MOTD_PATH = mkOption {
              type = types.nullOr (types.oneOf [types.string types.path]);
              default = defaultConfig.MOTD_PATH;
              description = lib.mdDoc "Overrides the default path to the static motd.";
            };
            FG_COLOR = mkOption {
              type = types.nullOr (types.enum availableColors);
              default = defaultConfig.FG_COLOR;
              description = lib.mdDoc "Foreground color, available only in daemon mode.";
            };
            BG_COLOR = mkOption {
              type = types.nullOr (types.enum availableColors);
              default = defaultConfig.BG_COLOR;
              description = lib.mdDoc "Background color, available only in daemon mode.";
            };
            ENABLE_NUMLOCK = mkOption {
              type = types.nullOr types.bool;
              default = defaultConfig.ENABLE_NUMLOCK;
              description = lib.mdDoc "Enables numlock in daemon mode.";
            };
            SESSION_ERROR_LOGGING = mkOption {
              type = types.nullOr (types.enum ["default" "appending" "disabled"]);
              default = defaultConfig.SESSION_ERROR_LOGGING;
              description = lib.mdDoc "Defines how the logging of session errors handled. Possible values are \"default\", \"appending\" or \"disabled\".";
            };
            SESSION_ERROR_LOGGING_FILE = mkOption {
              type = types.nullOr (types.oneOf [types.path types.string]);
              default = defaultConfig.SESSION_ERROR_LOGGING_FILE;
              description = lib.mdDoc "Overrides path of session errors log file.";
              example = "/var/log/emptty/session-errors.$\{TTY_NUMBER}.log";
            };
            DEFAULT_XAUTHORITY = mkOption {
              type = types.nullOr types.bool;
              default = defaultConfig.DEFAULT_XAUTHORITY;
              description =
                lib.mdDoc
                "If set true, it will not use `.emptty-xauth` file, but the standard `~/.Xauthority` file. This allows to handle xauth issues.";
            };
            ROOTLESS_XORG = mkOption {
              type = types.nullOr types.bool;
              default = defaultConfig.ROOTLESS_XORG;
              description = lib.mdDoc "If true, and emptty is running in daemon mode, Xorg will be started in rootless mode (provided the system allows it).";
            };
            IDENTIFY_ENVS = mkOption {
              type = types.bool;
              default = defaultConfig.IDENTIFY_ENVS;
              description = lib.mdDoc "If set true, environmental groups are printed to differ Xorg/Wayland/Custom/UserCustom desktops.";
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.xserver.enable;
        message = ''
          emptty requires services.xserver.enable to be true
        '';
      }
    ];

    # symlink configuration for use by the program
    environment.etc."emptty/conf".text = builtins.concatStringsSep "\n" (optionsToString cfg.configuration);
    # services.emptty.settings.terminal.vt = mkDefault cfg.configuration.TTY_NUMBER;

    # This prevents nixos-rebuild from killing emptty by activating getty again (TODO: check if this is actually true lol)
    systemd.services."autovt@${builtins.toString cfg.configuration.TTY_NUMBER}".enable = false;

    systemd.services.emptty = {
      unitConfig = {
        Wants = [
          "systemd-user-sessions.service"
        ];
        After = [
          "systemd-user-sessions.service"
          "plymouth-quit-wait.service"
          "getty@${builtins.toString cfg.configuration.TTY_NUMBER}.service"
        ];
        Conflicts = [
          "getty@${builtins.toString cfg.configuration.TTY_NUMBER}.service"
        ];
      };

      serviceConfig = {
        # this does have the --config option, but I'm choosing to symlink it to
        # /etc/emptty/conf for easier discoverability by new users
        ExecStart = "${cfg.package}bin/emptty -d";

        Restart = mkIf cfg.restart "always";

        # Defaults from emptty upstream configuration

        # i think we could do:
        # services.xserver.displayManager.job.environment = config.services.xserver.displayManager.job.environment // cfg.configuration;
        # but im hoping that the emptty maintainer will stop using environment variables at some point...
        EnvironmentFile = "/etc/emptty/conf";
        Type = "idle";
        TTYPath = "/dev/tty${builtins.toString cfg.configuration.TTY_NUMBER}";
        TTYReset = "yes";
        KillMode = "process";
        IgnoreSIGPIPE = "no";
        SendSIGHUP = "yes";
      };

      # Don't kill a user session when using nixos-rebuild
      restartIfChanged = false;

      wantedBy = ["graphical.target"];
    };

    systemd.defaultUnit = "graphical.target";

    # services.emptty.settings.default_session.user = mkDefault "emptty";

    # users.users.emptty = {
    #   isSystemUser = true;
    #   group = "emptty";
    # };

    # users.groups.emptty = {};

    security.pam.services.emptty = {
      allowNullPassword = true;
      startSession = true;
      text = ''
        auth            sufficient      pam_succeed_if.so user ingroup nopasswdlogin
        auth            include         system-login
        -auth           optional        pam_gnome_keyring.so
        -auth           optional        pam_kwallet5.so
        account         include         system-login
        password        include         system-login
        session         include         system-login
        -session        optional        pam_gnome_keyring.so auto_start
        -session        optional        pam_kwallet5.so auto_start force_run
      '';
    };

    # systemd.defaultUnit = "graphical.target";

    environment.systemPackages = [cfg.package];
    services.xserver.displayManager.lightdm.enable = false;
    systemd.services.emptty.enable = true;
  };
}
