{
  config,
  pkgs,
  lib,
  utils,
  modulesPath,
  ...
}:

let
  cfg = config.services.desktopManager.cosmic;
in
{
  disabledModules = [
    "${toString modulesPath}/services/desktop-managers/cosmic.nix"
  ];

  meta.maintainers = with lib.maintainers; [
    # lilyinstarlight
  ];

  options = {
    services.desktopManager.cosmic = {
      enable = lib.mkEnableOption "COSMIC desktop environment";

      xwayland.enable = lib.mkEnableOption "Xwayland support for cosmic-comp" // {
        default = true;
      };
    };

    environment.cosmic.excludePackages = lib.mkOption {
      description = "List of COSMIC packages to exclude from the default environment";
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.cosmic-edit ]";
    };
  };

  config = lib.mkIf cfg.enable {
    # seed configuration in nixos-generate-config
    system.nixos-generate-config.desktopConfiguration = [
      ''
        # Enable the COSMIC Desktop Environment.
        services.displayManager.cosmic-greeter.enable = true;
        services.desktopManager.cosmic.enable = true;
      ''
    ];

    # environment packages
    environment.pathsToLink = [
      "/share/backgrounds"
      "/share/cosmic"
    ];
    environment.systemPackages = utils.removePackagesByName (
      with pkgs;
      [
        adwaita-icon-theme
        alsa-utils
        cosmic-applets
        cosmic-applibrary
        cosmic-bg
        (cosmic-comp.override {
          # avoid PATH pollution of system action keybinds (Xwayland handled below)
          useXWayland = false;
        })
        cosmic-edit
        cosmic-files
        config.services.displayManager.cosmic-greeter.package
        cosmic-icons
        cosmic-idle
        cosmic-launcher
        cosmic-notifications
        cosmic-osd
        cosmic-panel
        cosmic-player
        cosmic-randr
        cosmic-screenshot
        cosmic-session
        cosmic-settings
        cosmic-settings-daemon
        cosmic-term
        cosmic-wallpapers
        cosmic-workspaces-epoch
        hicolor-icon-theme
        playerctl
        pop-icon-theme
        pop-launcher
        xdg-user-dirs
      ]
      ++ lib.optionals cfg.xwayland.enable [
        xwayland
      ]
      ++ lib.optionals config.services.flatpak.enable [
        cosmic-store
      ]
    ) config.environment.cosmic.excludePackages;

    # xdg portal packages and config
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-cosmic
        xdg-desktop-portal-gtk
      ];
      configPackages = lib.mkDefault (
        with pkgs;
        [
          xdg-desktop-portal-cosmic
        ]
      );
    };

    # fonts
    fonts.packages = utils.removePackagesByName (with pkgs; [
      fira
      noto-fonts
      open-sans
    ]) config.environment.cosmic.excludePackages;

    # xkb config
    environment.sessionVariables.X11_BASE_RULES_XML = "${config.services.xserver.xkb.dir}/rules/base.xml";
    environment.sessionVariables.X11_EXTRA_RULES_XML = "${config.services.xserver.xkb.dir}/rules/base.extras.xml";

    # required features
    hardware.graphics.enable = true;
    services.libinput.enable = true;
    xdg.mime.enable = true;
    xdg.icons.enable = true;

    # optional features
    hardware.bluetooth.enable = lib.mkDefault true;
    services.acpid.enable = lib.mkDefault true;
    services.avahi.enable = lib.mkDefault true;
    services.pipewire = {
      enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
    };
    services.gvfs.enable = lib.mkDefault true;
    networking.networkmanager.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;

    # general graphical session features
    programs.dconf.enable = lib.mkDefault true;

    # required dbus services
    services.accounts-daemon.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = lib.mkDefault (
      !config.hardware.system76.power-daemon.enable
    );
    security.polkit.enable = true;
    security.rtkit.enable = true;
    services.geoclue2.enable = true;

    # disable geoclue2 user demo agent in session
    # TODO: rework if NixOS geoclue2 module ever allows manually including demo agent in whitelist without adding user service
    systemd.user.services.geoclue-agent.conflicts = [ "cosmic-session.target" ];

    # session packages
    services.displayManager.sessionPackages = with pkgs; [ cosmic-session ];
    systemd.packages = with pkgs; [ cosmic-session ];
    programs.dconf.packages = with pkgs; [ cosmic-session ];
    # TODO: remove when upstream has XDG autostart support
    systemd.user.targets.cosmic-session = {
      wants = [ "xdg-desktop-autostart.target" ];
      before = [ "xdg-desktop-autostart.target" ];
    };
    # TODO: remove when <https://github.com/nix-community/home-manager/pull/6332> is available on all supported home-manager branches
    systemd.user.targets.tray = {
      description = "Cosmic Tray Target";
      requires = [ "graphical-session-pre.target" ];
    };

    # required for screen locker
    security.pam.services.cosmic-greeter = { };

    # set default cursor theme
    xdg.icons.fallbackCursorThemes = lib.mkDefault [ "Cosmic" ];

    # module diagnostics
    warnings =
      lib.optional
        (
          lib.elem pkgs.cosmic-files config.environment.cosmic.excludePackages
          && !(lib.elem pkgs.cosmic-session config.environment.cosmic.excludePackages)
        )
        ''
          The COSMIC session may fail to initialise with the `cosmic-files` package excluded via
          `config.environment.cosmic.excludePackages`.

          Please do one of the following:
            1. Remove `cosmic-files` from `config.environment.cosmic.excludePackages`.
            2. Add `cosmic-session` (in addition to `cosmic-files`) to
               `config.environment.cosmic.excludePackages` and ensure whatever session starter/manager you are
               using is appropriately set up.
        '';
    assertions = [
      {
        assertion = lib.elem "libcosmic-app-hook" (
          lib.map (
            drv: lib.optionalString (lib.isDerivation drv) (lib.getName drv)
          ) pkgs.cosmic-comp.nativeBuildInputs
        );
        message = ''
          It looks like the provided `pkgs` to the NixOS COSMIC module is not usable for a working COSMIC
          desktop environment.

          If you are erroneously passing in `pkgs` to `specialArgs` somewhere in your system configuration,
          this is is often unnecessary and has unintended consequences for all NixOS modules. Please either
          remove that in favor of configuring the NixOS `pkgs` instance via `nixpkgs.config` and
          `nixpkgs.overlays`.

          If you must instantiate your own `pkgs`, then please include the overlay from the NixOS COSMIC flake
          when instantiating `pkgs` and be aware that the `nixpkgs.config` and `nixpkgs.overlays` options will
          not function for any NixOS modules.

          Note that the COSMIC packages in Nixpkgs are still largely broken as of 2025-02-08 and will not be
          usable for having a fully functional COSMIC desktop environment. The overlay is therefore necessary.
        '';
      }
    ];
  };
}
