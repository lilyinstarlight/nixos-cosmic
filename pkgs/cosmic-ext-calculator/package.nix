{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-calculator";
  version = "0.2.0-unstable-2026-03-04";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "calculator";
    rev = "b28dd38bd1fedba038da44ca86bc12cb5d0a6a5e";
    hash = "sha256-8V4nGOFjlfJe2kHmSzHumLbMW7tcU89usqktCLNVSns=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nq5gjfWohq/IMNlQZtIBYYjRaqlMeaEzRGvRX66ZbRQ=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-calculator"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/calculator";
    description = "Calculator for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-calculator";
  };
}
