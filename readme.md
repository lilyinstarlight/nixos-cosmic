# NixOS COSMIC


## fork

(i fully intend to abandon this within the next week)

x86_64 linux support only atm 

---

Nix package set and NixOS module for using COSMIC from NixOS. This is a temporary repository for testing COSMIC on NixOS as it is developed. When COSMIC gets more stable and it is fully working on NixOS, these packages and module are intended to be merged upstream into nixpkgs ([issue to be updated when upstreaming](https://github.com/NixOS/nixpkgs/issues/259641)).

Dedicated development matrix room: <https://matrix.to/#/#cosmic:nixos.org>

## Usage

### Flakes

If you have an existing `configuration.nix`, you can use the `nixos-cosmic` flake with the following in an adjacent `flake.nix` (e.g. in `/etc/nixos`):

**Note:** If switching from traditional evaluation to flakes, `nix-channel` will no longer have any effect on the nixpkgs your system is built with, and therefore `nixos-rebuild --upgrade` will also no longer have any effect. You will need to use `nix flake update` from your flake directory to update nixpkgs and nixos-cosmic.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # NOTE: change "unstable" to "24.05" if you are using NixOS 24.05

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

**Note:** To ensure binary substituters are set up before attempting to pull any COSMIC packages, perform a `nixos-rebuild test` with this configuration before attempting to add any COSMIC packages or settings to your NixOS configuration.

After setting up binary substituters and NixOS module, enable COSMIC with `services.desktopManager.cosmic.enable = true` and `services.displayManager.cosmic-greeter.enable = true` in your NixOS configuration.


## Build Requirements

Although there is a provided binary cache built against current `nixos-unstable` and `nixos-24.05` branches, if you are not using a current `nixos-unstable` or `nixos-24.05` then you may need to build packages locally.

Generally you will need roughly 16 GiB of RAM and 40 GiB of disk space, but it can be built with less RAM by reducing build parallelism, either via `--cores 1` or `-j 1` or both, on `nix build`, `nix-build`, and `nixos-rebuild` commands.


## Troubleshooting

### Phantom non-existent display on Nvidia ([cosmic-randr#13](https://github.com/pop-os/cosmic-randr/issues/13))

If while using an Nvidia GPU, `cosmic-settings` and `cosmic-randr list` show an additional display that can not be disabled, try Nvidia's experimental framebuffer device.

Add to your configuration:

```nix
boot.kernelParams = [ "nvidia_drm.fbdev=1" ];
```
