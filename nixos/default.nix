{ cosmicOverlay }:

{
  imports = import ./module-list.nix;

  nixpkgs.overlays = [ cosmicOverlay ];
}
