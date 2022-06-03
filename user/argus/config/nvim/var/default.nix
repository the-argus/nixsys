{ pkgs, config, lib, ... }:
let
  cfg = config.nvim;
  inherit (lib) mkIf mkOption;
in
{
  options.nvim = {
    lsp.profile = mkOption {
      type = lib.types.str;
      default = "no-csharp";
      description = "LSP Profile";
    };
  };

  config = {
    home.file = {
      ".config/nvim/lua/plugin-config/lsp/configs.lua" = {
        source = "./${lib.escapeShellArg cfg.lsp.profile}.lua";
      };
    };
  };
}
