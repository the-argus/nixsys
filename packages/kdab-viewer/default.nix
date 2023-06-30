{
  stdenv,
  qt6,
  pkg-config,
  cmake,
  coreutils-full,
  runCommandLocal,
  libsecret,
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

  qsimpleupdater = builtins.fetchGit {
    url = "ssh://codereview.kdab.com:29418/kdab/QSimpleUpdater";
    rev = "ed57cbd30a4e7c8233fb7175f7c7b5838e9228f6";
    allRefs = true;
  };

  strong-typedef = builtins.fetchGit {
    url = "https://github.com/dangelog/strong_typedef.git";
    rev = "2dce606bc04ea5c8e8ed750b0c68fba477e88c22";
    allRefs = true;
  };

  kdalgorithms = builtins.fetchGit {
    url = "https://github.com/KDAB/KDAlgorithms.git";
    rev = "0ec6c63edf3bca56398f11600f9a7a2f25e3d711";
  };

  qxlsx = builtins.fetchGit {
    url = "https://github.com/QtExcel/QXlsx.git";
    rev = "bdda6568230ae8fc199ffcc88c598ce42d77a311";
  };

  mk3rdParty = name: drv: ''
    rm -rf 3rdparty/${name}
    cp -r ${drv} 3rdparty/${name}
    ${coreutils-full}/bin/chmod +wr 3rdparty -R
    touch 3rdparty/${name}/.git # hack
  '';

  kdchart = builtins.fetchGit {
    url = "https://github.com/KDAB/KDChart";
    rev = "3c3f13d99c0e9d266538939b209027cdad267217";
  };

  kdreports = builtins.fetchGit {
    url = "https://github.com/KDAB/KDReports";
    rev = "81e77cd97ba1175a54e43bcfe6fa087b38f63e68";
  };

  kddockwidgets = builtins.fetchGit {
    url = "https://github.com/KDAB/KDDockWidgets";
    rev = "b1379f0bef49ad58c2f7d5520460ee8399821104";
  };

  qt6keychain = builtins.fetchGit {
    url = "https://github.com/frankosterfeld/qtkeychain";
    ref = "v0.14.0";
    rev = "e63da2868465db18eb35a312b2635c26fdc46923";
    allRefs = true;
  };

  externalprojects = runCommandLocal "glue-external-projects" {} ''
    mkdir -p $out
    ln -sf ${kdchart} $out/KDChart
    ln -sf ${kdreports} $out/KDReports
    ln -sf ${kddockwidgets} $out/KDDockWidgets
    ln -sf ${qt6keychain} $out/Qt6Keychain
  '';
in
  stdenv.mkDerivation {
    name = "kdab-viewer";

    src = builtins.fetchGit {
      url = "ssh://@codereview.kdab.com:29418/kdab/KDABViewer";
      rev = "092f163694d940381c4c9405c9cdc3f5ba3f3a2f";
    };

    prePatch =
      (mk3rdParty "KDToolBox" kdtoolbox)
      + (mk3rdParty "QSimpleUpdater" qsimpleupdater)
      + (mk3rdParty "kdalgorithms" kdalgorithms)
      + (mk3rdParty "QXlsx" qxlsx)
      + (mk3rdParty "strong_typedef" strong-typedef)
      # patch which makes the kdaddexternalproject function use a nix store dir
      # instead of git
      + ''
        sed -i "/GIT_TAG/d" cmake/KDABViewerFunctions.cmake
        sed -i "s|GIT_REPOSITORY\(.*\)|SOURCE_DIR ${externalprojects}/${"\\$\\{name\\}"}|" cmake/KDABViewerFunctions.cmake
        sed -i "s|/external||g" cmake/KDABViewerFunctions.cmake
      '';

    buildInputs = [pkg-config cmake qt6.wrapQtAppsHook];

    cmakeFlags = [
      "-DECM_SKIP_INTERNAL_BUILD=ON"
    ];

    nativeBuildInputs = with qt6; [
      qtbase
      qtsvg
      qt5compat
      qtscxml
      qttools
      extra-cmake-modules
      sonnet
      libsecret
    ];
  }
