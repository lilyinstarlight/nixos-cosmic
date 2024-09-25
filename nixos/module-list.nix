let
  dir = builtins.readDir ./.;
in
builtins.filter (value: value != null) (
  builtins.map (
    name: if dir.${name} == "directory" then "${builtins.toString ./.}/${name}/module.nix" else null
  ) (builtins.attrNames dir)
)
