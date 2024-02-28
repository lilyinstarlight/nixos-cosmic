# NixOS COSMIC

Nix package set and NixOS module for using COSMIC from NixOS. This is a temporary repository for testing COSMIC on NixOS as it is developed. When COSMIC gets more stable and it is fully working on NixOS, these packages and module are intended to be merged upstream into nixpkgs.

## Usage

### Flakes

If you have an existing `configuration.nix`, you can use the `nixos-cosmic` flake with the following:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-cosmic }: {
    nixosConfigurations = {
      host = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./configuration.nix
        ];
      };
    };
  };
}
```

And then enable COSMIC with `services.xserver.desktopManager.cosmic.enable = true` and `services.xserver.displayManager.cosmic-greeter.enable = true` in your NixOS configuration
