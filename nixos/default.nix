{ lib, cosmicOverlay, ... }:

{
  imports = import ./module-list.nix { inherit lib; };

  nixpkgs.overlays = [ cosmicOverlay ];
}
