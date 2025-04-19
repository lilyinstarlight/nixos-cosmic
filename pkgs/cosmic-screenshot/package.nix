{
  lib,
  fetchFromGitHub,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-screenshot";
  version = "1.0.0-alpha.6-unstable-2025-04-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "1747b8a53eb3d6a3b72c90f4247e462da6289ffa";
    hash = "sha256-VvU/9vYdoTvy3yzdeXrhKrtS9tUHMKnaSAeNTEKk5PA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1r0Uwcf4kpHCgWqrUYZELsVXGDzbtbmu/WFeX53fBiQ=";

  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-screenshot"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}
