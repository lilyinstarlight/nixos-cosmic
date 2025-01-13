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
  version = "0.1.1-unstable-2025-01-12";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "calculator";
    rev = "f66f4d022f2ad7e50a44c9e50b53c95f0e8a13d6";
    hash = "sha256-0AYcqTB4K7kMcNNEaGK69boYvXv3p2Oq0QweyfqlpLI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W190Fhz6iy5oTVps70yWFDVy1KtavYdMlcK3GKgBrvo=";

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
