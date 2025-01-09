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
  version = "1.0.0-alpha.5-unstable-2025-01-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    rev = "d11cfbbee29b5b3f77623a26e5679ee764f76638";
    hash = "sha256-d/vkySs40jAiPvF2wCdOqdfRqs6l1JfBsza9YEFiyzY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZuKb654nfSt+v50l07z8uVAVP52IxCZG4Z2qDfyM6pk=";

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
