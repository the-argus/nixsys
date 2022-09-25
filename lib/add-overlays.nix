{
  pkgs,
  pkgsInputs,
  selections,
  override,
  ...
}:
override pkgsInputs {
  overlays =
    pkgsInputs.overlays
    # turn selections into an attrset of the packages for overlay
    # wrapped in (self: super: ...) so it works as an overlay
    ++ pkgs.lib.lists.singleton (self: super:
      builtins.listToAttrs (map (value:
        if builtins.typeOf value == "string"
        then {
          name = value;
          value = pkgs.${value};
        }
        else if builtins.typeOf value == "set"
        then
          if builtins.hasAttr "set3" value
          then {
            name = value.set1;
            value = override pkgs.${value.set1} {
              ${value.set2} = {
                ${value.set3} =
                  pkgs.${value.set1}.${value.set2}.${value.set3};
              };
            };
          }
          else
            (
              if builtins.hasAttr "set2" value
              then {
                name = value.set1;
                value = override pkgs.${value.set1} {
                  ${value.set2} = pkgs.${value.set1}.${value.set2};
                };
              }
              else {}
            )
        else abort "override not one of type \"set\" or \"string\"")
      selections));
}
