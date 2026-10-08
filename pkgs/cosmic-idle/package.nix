{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  bash,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-idle";
  version = "1.10.0-unstable-2026-10-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-idle";
    rev = "21e983c63e75640ab0055495e768a5c616742c19";
    hash = "sha256-+UgxU3jlNJa6Io6p5dDlslI8xIrRExwkjMzAm0tRqMc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2Lvp6HMk+bfOCT2Uo0NjW83S3lKmNApA104Pk6hIeNU=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-idle"
  ];

  postPatch = ''
    substituteInPlace src/main.rs --replace-fail '"/bin/sh"' '"${lib.getExe bash}"'
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-idle";
    description = "Idle daemon for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-idle";
  };
}
