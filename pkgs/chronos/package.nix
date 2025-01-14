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
  version = "0.1.5-unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "chronos";
    rev = "cb1acf1bf299ee082cc60597032e62ac3bf2cbba";
    hash = "sha256-iGkuURCDx5jWDqf9T5TK2vfErMSRlEsYwUcwa0OTies=";
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
