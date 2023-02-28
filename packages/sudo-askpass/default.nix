{
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "sudo-askpass";
  version = "v1.1.0";

  src = fetchFromGitHub {
    owner = "Absolpega";
    repo = "simple-terminal-sudo-askpass";
    rev = "aa0caa13801a19037af607016c0b719aaf97939d";
    sha256 = "15wy59j5hxlin30nzm4kkx8jvd78pq0mccx6895b3f10khywhjxf";
  };

  cargoSha256 = "sha256-AZpzhaNiWvve/XiFc+Ba/ZN7mG5DzbE8DZofXdq6mJ0=";
}
