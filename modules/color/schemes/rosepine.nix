{
  pkgs,
  banner,
}: {
  imports = [banner.module];
  banner.palette = banner.lib.parsers.basicYamlToBanner ./rosepine.yaml;
}
