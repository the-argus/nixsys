{
  pkgs,
  banner,
  ...
}: {
  rosepine = banner.lib.parsers.basicYamlToBanner ./rosepine.yaml;

  nord = banner.lib.parsers.basicYamlToBanner ./nord.yaml;

  gtk4 = import ./gtk4.nix;

  drifter = import ./drifter.nix;

  gruv = import ./gruv.nix;
}
