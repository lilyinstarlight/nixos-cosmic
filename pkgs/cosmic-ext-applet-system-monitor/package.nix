{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  pkgs,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-system-monitor";
  version = "0-unstable-2025-02-03";

  src = fetchFromGitHub {
    owner = "D-Brox";
    repo = "cosmic-ext-applet-system-monitor";
    rev = "f29debf726551df521aa26070c8efc54d7c0a714";
    hash = "sha256-JR1x84c7C0BNwt2QuFKLXiwGX5Pke6B1a8QotOFf68Y=";
  };

  useFetchCargoVendor = true;
  cargoPatches = [ ./pin-sctk.patch ];
  cargoHash = "sha256-yuV+U5FMNbGevXEp02ucsqyrqqvyJLXydYsyOOkj/00=";

  buildInputs = with pkgs; [ fontconfig ];
  nativeBuildInputs = with pkgs; [
    libcosmicAppHook
    just
    pkg-config
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-system-monitor"
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR="$TMP"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/D-Brox/cosmic-ext-applet-system-monitor";
    description = "Highly configurable system resource monitor for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-system-monitor";
  };
}
