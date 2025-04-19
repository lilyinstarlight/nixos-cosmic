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
  version = "1.0.0-alpha.6-unstable-2025-04-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-launcher";
    rev = "77ca2085554f1d8641f58d7954fd57be232e5006";
    hash = "sha256-niMsDLVMUEr8VyubDm6RGgS7p22v5nH/F8cASJOszhs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Wh3vI42RBfXpI7mvPVUmGK3fITGi+EGyo+lG7VnZg3w=";

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
