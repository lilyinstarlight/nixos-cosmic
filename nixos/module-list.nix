{ lib }:

lib.filter (value: value != null) (lib.mapAttrsToList (name: type: if type == "directory" then "${toString ./.}/${name}/module.nix" else null) (builtins.readDir ./.))
