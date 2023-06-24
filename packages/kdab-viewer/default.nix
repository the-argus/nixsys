{
  stdenv,
  qt6,
  cmake,
  coreutils-full,
  ...
}: let
  extra-cmake-modules = stdenv.mkDerivation {
    name = "extra-cmake-modules";
    src = builtins.fetchGit {
      url = "https://invent.kde.org/frameworks/extra-cmake-modules.git";
      rev = "8fae102d67ca454eb782a2a1d5503e4cf4b17230";
    };
    buildInputs = [cmake];
  };

  sonnet = stdenv.mkDerivation {
    name = "sonnet";
    src = builtins.fetchGit {
      url = "https://invent.kde.org/frameworks/sonnet.git";
      rev = "74645e8fd03c4944d77839b80840df46f2960ecf";
    };
    cmakeFlags = ["-DQT_MAJOR_VERSION=6"];
    buildInputs = [cmake qt6.wrapQtAppsHook];
    nativeBuildInputs = with qt6; [
      extra-cmake-modules
      qtbase
      qtdeclarative
      qt5compat
      qttranslations
    ];
  };

  kdtoolbox = builtins.fetchGit {
    url = "ssh://codereview.kdab.com:29418/kdab/KDToolBox";
    rev = "8330ae5a88aafde7e992d1ca67ab9d4d95bb2a07";
  };

  qsimpleupdater = stdenv.mkDerivation {
    name = "qsimpleupdater";
    src = builtins.fetchGit {
      url = "ssh://codereview.kdab.com:29418/kdab/QSimpleUpdater";
      rev = "9051e9ce66819913a3d36676c97e3007646335a1";
    };

    buildInputs = [cmake qt6.wrapQtAppsHook];

    nativeBuildInputs = with qt6; [qtbase];
  };
in
  stdenv.mkDerivation {
    name = "kdab-viewer";

    src = builtins.fetchGit {
      url = "ssh://ian.mcfarlane@codereview.kdab.com:29418/kdab/KDABViewer";
      rev = "092f163694d940381c4c9405c9cdc3f5ba3f3a2f";
    };

    prePatch = ''
      rm -rf 3rdparty/KDToolBox
      cp -r ${kdtoolbox} 3rdparty/KDToolBox
      ${coreutils-full}/bin/chmod +wr 3rdparty -R
      touch 3rdparty/KDToolBox/.git # hack
    '';

    buildInputs = [cmake qt6.wrapQtAppsHook];

    cmakeFlags = [
      "-DECM_SKIP_INTERNAL_BUILD=ON"
    ];

    nativeBuildInputs = with qt6; [
      qtbase
      extra-cmake-modules
      qsimpleupdater
      sonnet
    ];
  }
