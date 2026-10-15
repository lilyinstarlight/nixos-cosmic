{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  nasm,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-bg";
  version = "1.10.0-unstable-2026-10-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-bg";
    rev = "91d525b7310f5a497c9fd09a25d2710eb9f8a6f7";
    hash = "sha256-nXYCSgO5H1XwaefGft5g6pqJlFHCJJ1sZBna6zopDg8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HSAGnQieEEzMfxuDFVsf9xTdaANqfFEdbdj33ehtD3M=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    nasm
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-bg"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-bg";
    description = "Applies Background for the COSMIC Desktop Environment";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-bg";
  };
}
