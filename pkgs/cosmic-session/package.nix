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
  version = "1.11.0-unstable-2026-10-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    rev = "4b0a0a24e98b9e755b6a7146e4cb29539cacda0a";
    hash = "sha256-HRfPlVTd97ku+KmZs55cWBg8v1MMWKsxX1oirm8oc4E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-o/ufWQ6A2c3p530jxvGwr/p/ArC4n8mzIQQKXx1MpFY=";

  postPatch = ''
    substituteInPlace data/start-cosmic \
      --replace-fail /usr/bin/cosmic-session "''${!outputBin}/bin/cosmic-session" \
      --replace-fail /usr/bin/dbus-run-session '${lib.getExe' dbus "dbus-run-session"}' \
      --replace-fail 'systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP DCONF_PROFILE' '${lib.getExe' dbus "dbus-update-activation-environment"} --systemd PATH XDG_SESSION_CLASS XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DCONF_PROFILE XDG_DESKTOP_PORTAL_DIR DISPLAY WAYLAND_DISPLAY XMODIFIERS XCURSOR_SIZE XCURSOR_THEME GDK_PIXBUF_MODULE_FILE GIO_EXTRA_MODULES GTK_IM_MODULE QT_PLUGIN_PATH QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE QT_IM_MODULE NIXOS_OZONE_WL &>/dev/null'
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
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
    "--set"
    "cosmic_dconf_profile"
    "cosmic"
  ];

  env.XDP_COSMIC = lib.getExe xdg-desktop-portal-cosmic;
  # use `orca` from PATH (instead of absolute path) if available
  env.ORCA = "orca";

  postInstall = ''
    mkdir -p $out/etc
    cp -r data/dconf $out/etc/
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
    providedSessions = [ "cosmic" ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-session";
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
  };
}
