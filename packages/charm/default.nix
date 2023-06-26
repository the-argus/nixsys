{
  stdenv,
  cmake,
  qt6,
  extra-cmake-modules,
  libsodium,
  qtkeychain,
  ...
}: let
  kdextra-cmake-modules = builtins.fetchGit {
    url = "ssh://codereview.kdab.com:29418/kdab/extra-cmake-modules";
    rev = "890af7af29afbdf838039d9053956f2db70c4c55";
  };
in
  stdenv.mkDerivation {
    name = "charm";
    src = builtins.fetchGit {
      url = "ssh://ian.mcfarlane@codereview.kdab.com:29418/Charm.git";
      rev = "d81896861c837fc5e9bd927e2b2a0fa596e63fb1";
    };

    cmakeFlags = [
      "-DCMAKE_MODULE_PATH=${kdextra-cmake-modules}/modules"
      "-DBUILD_INTERNAL_QTKEYCHAIN=OFF"
    ];

    patches = [
      ./remove-fetchcontent.patch
      ./remove-changelog.patch
    ];

    buildInputs = [cmake qt6.wrapQtAppsHook];

    nativeBuildInputs = with qt6; [
      qtbase
      qt5compat
      qttools
      qtscxml
      qtsvg
      qtconnectivity
      qtkeychain
      qtwayland
      libsodium
      extra-cmake-modules
    ];
  }
