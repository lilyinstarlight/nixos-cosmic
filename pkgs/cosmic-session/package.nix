{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bash,
  dbus,
  just,
  stdenv,
  xdg-desktop-portal-cosmic,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-session";
  version = "1.0.0-alpha.3-unstable-2024-11-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    rev = "53237d147fde1fc63a4be88cf57ec5aaa83d5581";
    hash = "sha256-J+d/AvPvkoSE6YbOTj6afAdOPXPWl9yQy9x5Nv/WrK8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-dbus-a11y-0.1.0" = "sha256-TRXYsnodKjKacc2eVndviEPpma/NNOWstG+ipGcQ0s4=";
      "cosmic-notifications-util-0.1.0" = "sha256-yB8XGr/Glj6iUMp4Rj4CEsHpWQgLeF5h/KyIDiqfmfI=";
      "launch-pad-0.1.0" = "sha256-TOnVCF1XWwfi3g/Z0LUJ/uwxSd1NBSRlArBnlXeeMTQ=";
    };
  };

  postPatch = ''
    substituteInPlace Justfile \
      --replace-fail '{{cargo-target-dir}}/release/cosmic-session' 'target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-session'
    substituteInPlace data/start-cosmic \
      --replace-fail /usr/bin/cosmic-session "''${!outputBin}/bin/cosmic-session" \
      --replace-fail /usr/bin/dbus-run-session '${lib.getExe' dbus "dbus-run-session"}' \
      --replace-fail 'systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP' '${lib.getExe' dbus "dbus-update-activation-environment"} --systemd PATH XDG_SESSION_CLASS XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DCONF_PROFILE XDG_DESKTOP_PORTAL_DIR DISPLAY WAYLAND_DISPLAY XMODIFIERS XCURSOR_SIZE XCURSOR_THEME GDK_PIXBUF_MODULE_FILE GIO_EXTRA_MODULES GTK_IM_MODULE QT_PLUGIN_PATH QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE QT_IM_MODULE NIXOS_OZONE_WL &>/dev/null'
    substituteInPlace data/cosmic.desktop \
      --replace-fail /usr/bin/start-cosmic "''${!outputBin}/bin/start-cosmic"
  '';

  nativeBuildInputs = [ just ];
  buildInputs = [ bash ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  env.XDP_COSMIC = lib.getExe xdg-desktop-portal-cosmic;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
    providedSessions = [ "cosmic" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    mainProgram = "cosmic-session";
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
  };
}
