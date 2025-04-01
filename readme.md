# NixOS COSMIC

Nix package set and NixOS module for using COSMIC. It is mainly a repository for testing COSMIC as it is developed.

Dedicated development matrix room: <https://matrix.to/#/#cosmic:nixos.org>

## Usage

### Flakes

If you have an existing `configuration.nix`, you can use the `nixos-cosmic` flake with the following in an adjacent `flake.nix` (e.g. in `/etc/nixos`):

**Note:** If switching from traditional evaluation to flakes, `nix-channel` will no longer have any effect on the nixpkgs your system is built with, and therefore `nixos-rebuild --upgrade` will also no longer have any effect. You will need to use `nix flake update` from your flake directory to update nixpkgs and nixos-cosmic.

```nix
{
  inputs = {
    nixpkgs.follows = "nixos-cosmic/nixpkgs"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
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

To use COSMIC Store to manage Flatpaks, set `services.flatpak.enable = true` and then run `flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo` in your user terminal to add the Flathub repository.


## Build Requirements

Although there is a provided binary cache built against the current `nixos-unstable` and `nixos-24.11` branches, if you are not using a current `nixos-unstable` or `nixos-24.11` then you may need to build packages locally.

Generally you will need roughly 16 GiB of RAM and 40 GiB of disk space, but it can be built with less RAM by reducing build parallelism, either via `--cores 1` or `-j 1` or both, on `nix build`, `nix-build`, and `nixos-rebuild` commands.


## Troubleshooting

### Phantom non-existent display on Nvidia ([cosmic-randr#13](https://github.com/pop-os/cosmic-randr/issues/13))

If while using an Nvidia GPU, `cosmic-settings` and `cosmic-randr list` show an additional display that can not be disabled, try Nvidia's experimental framebuffer device.

Add to your configuration:

```nix
boot.kernelParams = [ "nvidia_drm.fbdev=1" ];
```

### COSMIC Utilities - Clipboard Manager not working

The zwlr\_data\_control\_manager\_v1 protocol needs to be available. Enable it in cosmic-comp via the following configuration:

```nix
environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
```

### COSMIC Utilities - Observatory not working

The monitord service must be enabled to use Observatory.

```nix
systemd.packages = [ pkgs.observatory ];
systemd.services.monitord.wantedBy = [ "multi-user.target" ];
```
