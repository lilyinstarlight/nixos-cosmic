{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  util-linux,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "1.11.0-unstable-2026-11-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "69d506ca58d5fcd05205cc77aec5a9e58aac2df6";
    hash = "sha256-t7gD4ackAJqOlAHBn3D7rXu6qF7uCp1xfXtKLr7CY90=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Qnvd3M9xXd/tNzJvUmF1f1vv4fjfNbxD/8YZTh7nslk=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    util-linux
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-panel"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-panel";
  };
}
