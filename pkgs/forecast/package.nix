{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "forecast";
  version = "0-unstable-2025-03-06";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "forecast";
    rev = "e46476010d89c69ae00c781e570d513f0f943b54";
    hash = "sha256-VOt4nmiqq+l6LPd6ED8QDZ8qTLYQfmIuRUWm0183ufY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mqZ2tIZzQWU39SMj8UBnScsGAg4xGhkcm51aXx3UBSk=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-forecast"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/forecast";
    description = "Weather forecast for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-forecast";
  };
}
