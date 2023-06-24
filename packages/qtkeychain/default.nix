{
  stdenv,
  qt6Packages,
  fetchFromGitHub,
  ...
}:
qt6Packages.qtkeychain.overrideAttrs (oa: rec {
  version = "0.14.0";
  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = "v${version}";
    sha256 = "sha256-YHq06Pc7VGMv0JxzlLPc8U0aSQ5EzmOF+4+1CQghI04=";
  };

  patches = [];

  doInstallCheck = false;

  cmakeFlags =
    oa.cmakeFlags
    ++ [
      "-DBUILD_WITH_QT6=ON"
      "-DBUILD_SHARED_LIBS=${
        if stdenv.isDarwin
        then "OFF"
        else "ON"
      }"
      "-DCMAKE_POSITION_INDEPENDENT_CODE=on"
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.10"
      "-DBUILD_TEST_APPLICATION=OFF"
      "-DBUILD_TRANSLATIONS=OFF"
    ];
})
