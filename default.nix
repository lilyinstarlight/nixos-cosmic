{ system ? builtins.currentSystem, ... }:

let
  self = (import (
      let
        lock = builtins.fromJSON (builtins.readFile ./flake.lock);
      in fetchTarball {
        url = "https://github.com/nix-community/flake-compat/archive/${lock.nodes.${lock.nodes.${lock.root}.inputs.flake-compat}.locked.rev}.tar.gz";
        sha256 = lock.nodes.flake-compat.locked.narHash;
      }
    )
    {
      # hack to skip fetchGit when evaluating impurely and get original paths
      src = {
        outPath = ./.;
      };
    }
  ).defaultNix;
in

self.packages.${system}
