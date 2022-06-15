{ pkgs, config, inputs, lib, ... }:
let
    cfg = config.host;
in
{
    options.host.configuration = lib.mkOption {
        type = lib.types.enum [ "laptop" "pc" ];
        default = "laptop";
        description = "The version of the configurations to use.";
    };
    config = lib.mkIf (cfg.configuration == "laptop")
        import ./laptop {inherit config; inherit pkgs;};
    config = lib.mkIf (cfg.configuration == "pc") 
        import ./pc {inherit config; inherit pkgs;};
}
