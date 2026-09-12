{...}: {
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings.main = {
        capslock = "leftcontrol";
        esc = "capslock";
        leftcontrol = "esc";
      };
    };
  };

  # treat keyd as a physical keyboard so that palm rejection while typing on a laptop works properly
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [keyd virtual device]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
