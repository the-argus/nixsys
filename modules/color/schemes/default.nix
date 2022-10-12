{
  pkgs,
  banner,
  ...
}: {
  rosepine = banner.lib.parsers.basicYamlToBanner ./rosepine.yaml;

  nord = banner.lib.parsers.basicYamlToBanner ./nord.yaml;

  gtk4 = import ./gtk4.nix;

  drifter = banner.lib.parsers.basicYamlToBanner ./drifter.yaml;

  gruv = banner.lib.parsers.basicYamlToBanner ./gruvbox.yaml;
}
