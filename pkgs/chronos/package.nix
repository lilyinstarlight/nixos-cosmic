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
  version = "0.1.5-unstable-2025-01-28";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "chronos";
    rev = "d19b6adf2fdceee2ffcbff270374fa0e7d169d03";
    hash = "sha256-f0+znpUxW8Isvrqw55FCop/K3vewwg0mhFtWKIqAoHU=";
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
