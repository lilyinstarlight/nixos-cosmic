{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:nix-community/flake-compat";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      rust-overlay,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      rustPlatformFor =
        pkgs:
        if nixpkgs.lib.versionAtLeast pkgs.rustc.version "1.85.0" then
          pkgs.rustPlatform
        else
          let
            rust-bin = rust-overlay.lib.mkRustBin { } pkgs;
          in
          pkgs.makeRustPlatform {
            cargo = rust-bin.stable.latest.default;
            rustc = rust-bin.stable.latest.default;
            cargo-auditable =
              if nixpkgs.lib.versionAtLeast pkgs.cargo-auditable.version "0.6.5" then
                pkgs.cargo-auditable
              else
                pkgs.cargo-auditable.overrideAttrs (attrs: {
                  meta = attrs.meta // {
                    broken = true;
                  };
                });
          };
    in
    {
      lib = {
        packagesFor =
          pkgs:
          import ./pkgs {
            inherit pkgs;
            rustPlatform = rustPlatformFor pkgs;
          };
      };

      packages = forAllSystems (system: self.lib.packagesFor nixpkgs.legacyPackages.${system});

      overlays = {
        default =
          final: prev:
          import ./pkgs {
            inherit final prev;
            rustPlatform = rustPlatformFor prev;
          };
      };

      nixosModules = {
        default = import ./nixos { cosmicOverlay = self.overlays.default; };
      };

      legacyPackages = forAllSystems (
        system:
        let
          lib = nixpkgs.lib;
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          update = pkgs.writeShellApplication {
            name = "cosmic-unstable-update";
            bashOptions = [ ];

            text = lib.concatStringsSep "\n" (
              lib.mapAttrsToList (
                attr: drv:
                let
                  packageUpdateScript =
                    if drv ? updateScript && (lib.isList drv.updateScript) && (lib.length drv.updateScript) > 0 then
                      lib.escapeShellArgs (
                        if (lib.match "nix-update|.*/nix-update" (lib.head drv.updateScript) != null) then
                          [ (lib.getExe pkgs.nix-update) ]
                          ++ (lib.tail drv.updateScript)
                          ++ [
                            "--version"
                            "branch=HEAD"
                            "--commit"
                            attr
                          ]
                        else
                          drv.updateScript
                      )
                    else
                      builtins.toString drv.updateScript or "";
                in
                  if packageUpdateScript == "" then "" else ''
                    echo "::group::Updating ${attr}"
                    ${packageUpdateScript}
                    status=$?
                    echo "::endgroup::"
                    if [ $status -eq 0 ]; then
                        echo "Update of ${attr} successful"
                    else
                        echo "::warning::Update of ${attr} failed"
                    fi
                  ''
              ) (self.lib.packagesFor pkgs)
            );
          };

          vm = nixpkgs.lib.makeOverridable (
            { nixpkgs }:
            let
              nixosConfig = nixpkgs.lib.nixosSystem {
                modules = [
                  (
                    {
                      lib,
                      pkgs,
                      modulesPath,
                      ...
                    }:
                    {
                      imports = [
                        self.nixosModules.default

                        "${builtins.toString modulesPath}/virtualisation/qemu-vm.nix"
                      ];

                      services.desktopManager.cosmic.enable = true;
                      services.displayManager.cosmic-greeter.enable = true;

                      services.flatpak.enable = true;
                      services.gnome.gnome-keyring.enable = true;

                      environment.systemPackages =
                        with pkgs;
                        [
                          andromeda
                          chronos
                          cosmic-ext-applet-caffeine
                          cosmic-ext-applet-clipboard-manager
                          cosmic-ext-applet-emoji-selector
                          cosmic-ext-applet-external-monitor-brightness
                          cosmic-ext-calculator
                          cosmic-ext-ctl
                          examine
                          forecast
                          tasks
                          cosmic-ext-tweaks
                          (lib.lowPrio cosmic-comp)
                          cosmic-reader
                          drm_info
                          firefox
                          quick-webapps
                          stellarshot
                        ]
                        ++ lib.optionals stdenv.hostPlatform.isx86 [
                          observatory
                        ];

                      environment.sessionVariables = {
                        COSMIC_DATA_CONTROL_ENABLED = "1";
                      };

                      systemd.packages = with pkgs; lib.optionals stdenv.hostPlatform.isx86 [ observatory ];
                      systemd.services.monitord.wantedBy = [ "multi-user.target" ];

                      boot.kernelParams = [
                        "quiet"
                        "udev.log_level=3"
                      ];
                      boot.initrd.kernelModules = [ "bochs" ];

                      boot.initrd.verbose = false;

                      boot.initrd.systemd.enable = true;

                      boot.loader.systemd-boot.enable = true;
                      boot.loader.timeout = 0;

                      boot.plymouth.enable = true;
                      boot.plymouth.theme = "nixos-bgrt";
                      boot.plymouth.themePackages = [ pkgs.nixos-bgrt-plymouth ];

                      services.openssh = {
                        enable = true;
                        settings.PermitRootLogin = "yes";
                      };

                      documentation.nixos.enable = false;

                      users.mutableUsers = false;
                      users.users.root.password = "meow";
                      users.users.user = {
                        isNormalUser = true;
                        password = "meow";
                      };

                      virtualisation.useBootLoader = true;
                      virtualisation.useEFIBoot = true;
                      virtualisation.mountHostNixStore = true;

                      virtualisation.memorySize = 4096;
                      # TODO: below option can be removed once NixOS/nixpkgs#279009 is merged
                      virtualisation.qemu.options = [
                        "-vga none"
                        "-device virtio-gpu-gl-pci"
                        "-display default,gl=on"
                      ];

                      virtualisation.forwardPorts = [
                        {
                          from = "host";
                          host.port = 2222;
                          guest.port = 22;
                        }
                      ];

                      nixpkgs.config.allowAliases = false;
                      nixpkgs.hostPlatform = system;

                      system.stateVersion = lib.trivial.release;
                    }
                  )
                ];
              };
            in
            nixosConfig.config.system.build.vm
            // {
              closure = nixosConfig.config.system.build.toplevel;
              inherit (nixosConfig) config pkgs;
            }
          ) { inherit nixpkgs; };

          vm-stable = self.legacyPackages.${system}.vm.override { nixpkgs = nixpkgs-stable; };
        }
      );

      checks = forAllSystems (system: {
        vm = self.legacyPackages.${system}.vm.closure;
        vm-stable = self.legacyPackages.${system}.vm-stable.closure;
      });
    };
}
