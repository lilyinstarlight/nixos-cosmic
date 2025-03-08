{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "quick-webapps";
  version = "1.0.2-unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "web-apps";
    rev = "3d509568a90204d4ccb77643ebeb685d570cc89a";
    hash = "sha256-CKi1p+4ms5kc8ij2Y1UYS/iVrbkSYFuDUOiLKzGi7sM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tk3e1lWfoeO6FSc9glw+u2/QlhfyLU0UlRQr2xDX/6g=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/quick-webapps"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/web-apps";
    description = "Web app manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "quick-webapps";
  };
}
