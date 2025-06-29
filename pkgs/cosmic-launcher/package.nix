{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-launcher";
  version = "1.0.0-alpha.7-unstable-2025-06-23";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-launcher";
    rev = "84b16525b2603149f2066b891aaae9928e8bece6";
    hash = "sha256-SeUUjRCT6QJKYy25dYIz+tqi3C4AQ0nX0XYChkSQWts=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9N9B5eb3FkONTwaFv3+trCf9K0K0l8tE/Db/RN+UHMo=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-launcher"
  ];

  env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" = "--cfg tokio_unstable";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-launcher";
    description = "Launcher for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-launcher";
  };
}
