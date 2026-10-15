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
  version = "1.10.0-unstable-2026-10-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "07e27587eb387ecf38cb4692ccbf25ad20760d22";
    hash = "sha256-21GNvnlCO+Rw+mx/XseLvfOpXHpaZbe3khPg1x6orLY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vufeXvzzVDpVBxmm+pUIRai2aO3FpwVjg4RlhT4Ubeo=";

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
