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
  version = "1.0.0-alpha.4-unstable-2024-12-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    rev = "ee7954e8d6f5cca93f0151aa920c95071ec1cae0";
    hash = "sha256-O97R0yuI9cq5/sXFTPVJH+e6vTUCs4ptqDTuXDYUxoY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZuKb654nfSt+v50l07z8uVAVP52IxCZG4Z2qDfyM6pk=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];
  buildInputs = [ glib ];

  # TODO: uncomment if these packages ever stop requiring mutually exclusive features
  #cargoBuildFlags = [ "--package" "cosmic-files" "--package" "cosmic-files-applet" ];
  #cargoTestFlags = [ "--package" "cosmic-files" "--package" "cosmic-files-applet" ];

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

  # TODO: remove next two phases if these packages ever stop requiring mutually exclusive features
  buildPhase = ''
    baseCargoBuildFlags="$cargoBuildFlags"
    cargoBuildFlags="$baseCargoBuildFlags --package cosmic-files"
    runHook cargoBuildHook
    cargoBuildFlags="$baseCargoBuildFlags --package cosmic-files-applet"
    runHook cargoBuildHook
  '';

  checkPhase = ''
    baseCargoTestFlags="$cargoTestFlags"
    cargoTestFlags="$baseCargoTestFlags --package cosmic-files"
    runHook cargoCheckHook
    cargoTestFlags="$baseCargoTestFlags --package cosmic-files-applet"
    runHook cargoCheckHook
  '';

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
