{banner, ...}: {
  rosepine = banner.lib.parsers.basicYamlToBanner ./rosepine.yaml;

  nord = import ./nord.nix;

  gtk4 = import ./gtk4.nix;

  drifter = import ./drifter.nix;

  gruv = import ./gruv.nix;
}
