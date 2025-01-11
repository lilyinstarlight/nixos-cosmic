{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  stdenv,
  glib,
  just,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-files";
  version = "1.0.0-alpha.5-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    rev = "fce981ee8f95fe59a0c5d213c2314edfcfb0a681";
    hash = "sha256-Df9vMCfCHIoFXMyCjHk/cCiEmipUb2LHfueV82QtiDE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RPvxE+V4WeyA96BO6Hurb5BrTMXxlTZUBaae1zgdBNA=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];
  buildInputs = [ glib ];

  cargoBuildFlags = [
    "--package"
    "cosmic-files"
    "--package"
    "cosmic-files-applet"
  ];
  cargoTestFlags = [
    "--package"
    "cosmic-files"
    "--package"
    "cosmic-files-applet"
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
    "--set"
    "applet-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files-applet"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-files";
  };
}
