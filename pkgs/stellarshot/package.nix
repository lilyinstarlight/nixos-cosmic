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
  pname = "stellarshot";
  version = "0-unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "stellarshot";
    rev = "ed916e43e75525e4278506a010c7946c91cfc884";
    hash = "sha256-bpzMEZ5OG9OEBfmIS7MMjPgPb1apfS5dAdOklQqB5HM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xHrHDYZTw8dyxHYLZ8fxO5qHnd2M5NEbc0euaSYbH1o=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/stellarshot"
  ];

  # TODO: upstream depends on inter-test side effects and therefore depends on test ordering and lack of concurrency, but tests also do not seem useful
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/stellarshot";
    description = "Simple backup application using Rustic for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "stellarshot";
  };
}
