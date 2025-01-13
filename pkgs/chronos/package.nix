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
  pname = "chronos";
  version = "0.1.4-unstable-2025-01-12";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "chronos";
    rev = "0a8e7f8efccfea519d488edb07a7670a52a1aff4";
    hash = "sha256-MfCqaVniyA0FBms+ATkjkiSqBnunIbhEFdr5eney8N0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nE7kxIbYP0oXVETASqylEVeKxIN6/Cm2yGwQmZQww0U=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/chronos"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/chronos";
    description = "Simple Pomodoro timer built using libcosmic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "chronos";
  };
}
