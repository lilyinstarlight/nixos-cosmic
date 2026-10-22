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
  version = "0.1.5-unstable-2026-07-17";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "chronos";
    rev = "9ae5322f863330bc226d18a625b50991055fa892";
    hash = "sha256-J0q4Cu0ANv1nqVelwlWfLmFeiClCEkqMOn3we6YJY3A=";
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
