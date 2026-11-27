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
  version = "0-unstable-2026-11-25";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "stellarshot";
    rev = "cb880ca7deaac7df4c62b7e6771015a858e4ea75";
    hash = "sha256-2MX0viuPtcN3lWPaXrfQsMz9+M9FShzeAOyO6ARl1VQ=";
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
