{ pkgs }:

let
  inherit (pkgs) lib;

  pkgsPaths = lib.filterAttrs (_: value: value != null) (lib.mapAttrs (name: type: if type == "directory" then "${toString ./.}/${name}/package.nix" else null) (builtins.readDir ./.));
  callPackage = lib.callPackageWith (pkgs // finalPkgs // { inherit callPackage; });
  finalPkgs = lib.mapAttrs (_: path: callPackage path {}) pkgsPaths;
in finalPkgs
