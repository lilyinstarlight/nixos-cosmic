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
  version = "0.1.5-unstable-2025-03-24";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "chronos";
    rev = "93a8f9a202dac704061ceeee4b7c40b24e2641fd";
    hash = "sha256-L0HBACOnXRxb2nHqJ4IaZXJRijkWkbbyPAKwxwrM9hE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7zCs/OHFQuXlgGbWfcx35NhP0nPxWt2AuHQYXI27eec=";

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
