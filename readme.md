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
      # NOTE: change "host" to your system's hostname
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

After rebuilding with that configuration to get the binary cache substituters set up, enable COSMIC with `services.desktopManager.cosmic.enable = true` and `services.displayManager.cosmic-greeter.enable = true` in your NixOS configuration

## Troubleshooting

### Phantom non-existent display on Nvidia ([cosmic-randr#13](https://github.com/pop-os/cosmic-randr/issues/13))

If while using an Nvidia GPU, `cosmic-settings` and `cosmic-randr list` show an additional display that can not be disabled, try Nvidia's experimental framebuffer device.

Add to your configuration:

```nix
boot.kernelParams = [ "nvidia_drm.fbdev=1" ];
```

