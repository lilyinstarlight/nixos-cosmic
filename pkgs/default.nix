{
  pkgs ? null,
  final ? null,
  prev ? null,
  rustPlatform ? null,
}:

let
  dir = builtins.readDir ./.;
  pkgsPaths = builtins.filter (pkgPath: pkgPath != null) (
    builtins.map (
      name:
      if dir.${name} == "directory" then
        {
          inherit name;
          value = "${builtins.toString ./.}/${name}/package.nix";
        }
      else
        null
    ) (builtins.attrNames dir)
  );
  pkgsOverrides =
    if rustPlatform != null then
      {
        inherit rustPlatform;
      }
    else
      { };
  callPackage =
    if final != null then
      (
        path: args:
        let
          drvFunc = import path;
          drvArgs = builtins.functionArgs drvFunc;
          drvArgsOverrides = builtins.intersectAttrs drvArgs pkgsOverrides;
        in
        final.callPackage drvFunc (drvArgsOverrides // args)
      )
    else
      pkgs.lib.callPackageWith (
        pkgs
        // pkgsOverrides
        // finalPkgs
        // {
          buildPackages = finalPkgs;
          targetPackages = finalPkgs;
          inherit callPackage;
        }
      );
  finalPkgs = builtins.listToAttrs (
    builtins.map (pkgPath: {
      inherit (pkgPath) name;
      value = callPackage pkgPath.value { };
    }) pkgsPaths
  );
in
finalPkgs
