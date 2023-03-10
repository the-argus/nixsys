{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
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
    AUTOLOGIN_MAX_RETRY = 2;
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
    (name: value: "${name}=${empttyToString value}")
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

      configuration = mkOption {
        default = defaultConfig;
        type = types.submodule {
          options = {
            TTY_NUMBER = mkOption {
              type = types.int;
              default = 7;
              description = "TTY where emptty will start.";
            };
            SWITCH_TTY = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc "Enables switching to defined TTY number.";
            };
            PRINT_ISSUE = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc "Enables printing of /etc/issue in daemon mode.";
            };
            PRINT_MOTD = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc "Enables printing of default motd, /etc/emptty/motd or /etc/emptty/motd-gen.sh.";
            };
            DEFAULT_USER = mkOption {
              type = types.nullOr types.string;
              default = null;
              description = lib.mdDoc "Preselected user, if AUTOLOGIN is enabled, this user is logged in.";
            };
            AUTOLOGIN =
              mkEnableOption
              (lib.mdDoc "Enables Autologin, if DEFAULT_USER is defined and part of nopasswdlogin group.");
            AUTOLOGIN_SESSION = mkOption {
              type = types.nullOr types.string;
              default = null;
              description =
                lib.mdDoc
                "The default session used, if Autologin is enabled. If session is not found in list of sessions, it proceeds to manual selection.";
              example = "i3";
            };
            AUTOLOGIN_MAX_RETRY = mkOption {
              type = types.nullOr types.int;
              default = null;
              description = lib.mdDoc "If Autologin is enabled and session does not start correctly, the number of retries in short period is kept to eventually stop the infinite loop of restarts. -1 is for infinite retries, 0 is for no retry.";
            };
            LANG = mkOption {
              type = types.nullOr types.string;
              default = null;
              description = lib.mdDoc "Default LANG, if user does not have set own in init script.";
              example = "en_US.UTF-8";
            };
            DBUS_LAUNCH = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc "Starts desktop with calling \"dbus-launch\".";
            };
            XINITRC_LAUNCH =
              mkEnableOption
              (lib.mdDoc "Starts Xorg desktop with calling \"~/.xinitrc\" script, if is true, file exists and selected WM/DE is Xorg session, it overrides DBUS_LAUNCH.");
            VERTICAL_SELECTION =
              mkEnableOption
              (lib.mdDoc "Prints available WM/DE each on new line instead of printing on single line.");
            LOGGING = mkOption {
              type = types.nullOr (types.enum ["default" "appending" "disabled"]);
              default = null;
              description = lib.mdDoc "Defines the way, how is logging handled. Possible values are \"default\", \"appending\" or \"disabled\".";
            };
            LOGGING_FILE = mkOption {
              type = types.nullOr (types.oneOf [types.string types.path]);
              default = null;
              description = lib.mdDoc "Overrides path of log file";
              example = "/var/log/emptty/$\{TTY_NUMBER}.log";
            };
            XORG_ARGS = mkOption {
              type = types.nullOr types.string;
              default = null;
              description = lib.mdDoc "Arguments passed to Xorg server.";
            };
            DYNAMIC_MOTD = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = lib.mdDoc "Allows to use dynamic motd script to generate custom MOTD.";
            };
            DYNAMIC_MOTD_PATH = mkOption {
              type = types.nullOr (types.oneOf [types.package types.string types.path]);
              default = null;
              description = lib.mdDoc "Overrides the default path to the dynamic motd.";
            };
            MOTD_PATH = mkOption {
              type = types.nullOr (types.oneOf [types.string types.path]);
              default = null;
              description = lib.mdDoc "Overrides the default path to the static motd.";
            };
            FG_COLOR = mkOption {
              type = types.nullOr (types.enum availableColors);
              default = null;
              description = lib.mdDoc "Foreground color, available only in daemon mode.";
            };
            BG_COLOR = mkOption {
              type = types.nullOr (types.enum availableColors);
              default = null;
              description = lib.mdDoc "Background color, available only in daemon mode.";
            };
            ENABLE_NUMLOCK = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = lib.mdDoc "Enables numlock in daemon mode.";
            };
            SESSION_ERROR_LOGGING = mkOption {
              type = types.nullOr (types.enum ["default" "appending" "disabled"]);
              default = null;
              description = lib.mdDoc "Defines how the logging of session errors handled. Possible values are \"default\", \"appending\" or \"disabled\".";
            };
            SESSION_ERROR_LOGGING_FILE = mkOption {
              type = types.nullOr (types.oneOf [types.path types.string]);
              default = null;
              description = lib.mdDoc "Overrides path of session errors log file.";
              example = "/var/log/emptty/session-errors.$\{TTY_NUMBER}.log";
            };
            DEFAULT_XAUTHORITY = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description =
                lib.mdDoc
                "If set true, it will not use `.emptty-xauth` file, but the standard `~/.Xauthority` file. This allows to handle xauth issues.";
            };
            ROOTLESS_XORG = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = lib.mdDoc "If true, and emptty is running in daemon mode, Xorg will be started in rootless mode (provided the system allows it).";
            };
            IDENTIFY_ENVS =
              mkEnableOption
              "If set true, environmental groups are printed to differ Xorg/Wayland/Custom/UserCustom desktops.";
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

    services.xserver.displayManager.lightdm.enable = false;

    security.pam.services.emptty.text = ''
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

    systemd.defaultUnit = "graphical.target";

    services.xserver.displayManager.job.execCmd = ''
      exec ${cfg.package}/bin/emptty
    '';

    systemd.services.display-manager.onFailure = [
      "plymouth-quit.service"
    ];
    services.dbus.packages = [cfg.package];
    systemd.user.services.dbus.wantedBy = ["default.target"];
    systemd.services.plymouth-quit.wantedBy = lib.mkForce [];
    systemd.services.emptty.enable = true;

    environment.etc."emptty/conf".text = builtins.concatStringsSep "\n" (optionsToString cfg.configuration);
  };
}
