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
  version = "0.2.1-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "calculator";
    rev = "d22de56b6a0d293b1d40881d57f8a26607454ada";
    hash = "sha256-lJ70+cRch3BCShwwArjwC9adMW/jCH+lDUWnEEEqrRc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-a4WckNyKXS71dT0uYbO7tUUmD0Dw8vSzrPp29O4aiAk=";

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
