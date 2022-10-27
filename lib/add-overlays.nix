{
  pkgs,
  pkgsInputs,
  selections,
  override,
  ...
}: let
  pkgDescriptorSetToOverlayEntry = pkgDescriptor:
    if builtins.typeOf pkgDescriptor == "string"
    then {
      name = pkgDescriptor;
      value = pkgs.${pkgDescriptor};
    }
    else if builtins.typeOf pkgDescriptor == "set"
    then
      if builtins.hasAttr "set3" pkgDescriptor
      then {
        name = pkgDescriptor.set1;
        value = override pkgs.${pkgDescriptor.set1} {
          ${pkgDescriptor.set2} = {
            ${pkgDescriptor.set3} =
              pkgs
              .${pkgDescriptor.set1}
              .${pkgDescriptor.set2}
              .${pkgDescriptor.set3};
          };
        };
      }
      else
        (
          if builtins.hasAttr "set2" pkgDescriptor
          then {
            name = pkgDescriptor.set1;
            value = override pkgs.${pkgDescriptor.set1} {
              ${pkgDescriptor.set2} =
                pkgs
                .${pkgDescriptor.set1}
                .${pkgDescriptor.set2};
            };
          }
          else {}
        )
    else abort "Overlay descriptor not one of type \"set\" or \"string\"";
in
  override pkgsInputs {
    overlays =
      pkgsInputs.overlays
      ++ map (value: (
        _: _: let
          overlayEntry = pkgDescriptorSetToOverlayEntry value;
        in {
          ${overlayEntry.name} = overlayEntry.value;
        }
      ))
      selections;
  }
