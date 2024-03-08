{ pkgs ? null, final ? null, prev ? null }:

let
  dir = builtins.readDir ./.;
  pkgsPaths = builtins.filter (pkgPath: pkgPath != null) (builtins.map (name: if dir.${name} == "directory" then { inherit name; value = "${builtins.toString ./.}/${name}/package.nix"; } else null) (builtins.attrNames dir));
  callPackage = if final != null then final.callPackage else pkgs.lib.callPackageWith (pkgs // finalPkgs // { buildPackages = finalPkgs; targetPackages = finalPkgs; inherit callPackage; });
  finalPkgs = builtins.listToAttrs (builtins.map (pkgPath: { inherit (pkgPath) name; value = callPackage pkgPath.value {}; }) pkgsPaths);
in finalPkgs
