{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.displayManager.cosmic-greeter;
in
{
  meta.maintainers = with lib.maintainers; [
    # lilyinstarlight
  ];

  options.services.displayManager.cosmic-greeter = {
    enable = lib.mkEnableOption "COSMIC greeter";
  };

  config = lib.mkIf cfg.enable {
    # greetd config
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "cosmic-greeter";
          command = ''${lib.getExe' pkgs.coreutils "env"} XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" systemd-cat -t cosmic-greeter ${lib.getExe pkgs.cosmic-comp} ${lib.getExe pkgs.cosmic-greeter}'';
        };
      };
    };

    # daemon for querying background state and such
    systemd.services.cosmic-greeter-daemon = {
      wantedBy = [ "multi-user.target" ];
      before = [ "greetd.service" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.system76.CosmicGreeter";
        ExecStart = lib.getExe' pkgs.cosmic-greeter "cosmic-greeter-daemon";
        Restart = "on-failure";
      };
    };

    # greeter user (hardcoded in cosmic-greeter)
    users.users.cosmic-greeter = {
      description = "COSMIC login greeter user";
      isSystemUser = true;
      home = "/var/lib/cosmic-greeter";
      createHome = true;
      group = "cosmic-greeter";
    };

    users.groups.cosmic-greeter = { };

    # required features
    hardware.${if lib.versionAtLeast lib.version "24.11" then "graphics" else "opengl"}.enable = true;
    services.libinput.enable = true;

    # required dbus services
    services.accounts-daemon.enable = true;

    # required for authentication
    security.pam.services.cosmic-greeter = { };

    # dbus definitions
    services.dbus.packages = with pkgs; [ cosmic-greeter ];
  };
}
