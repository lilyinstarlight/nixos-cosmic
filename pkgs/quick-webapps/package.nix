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
  version = "3.0.0-unstable-2026-11-20";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "web-apps";
    rev = "895da1b88fffaf2787280e99683b954611b877cf";
    hash = "sha256-+x4l5jVayvTCIQugbf1F8VvrF3Rb1hBuC1XEgcJZMQ0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mKSUYLSPGIeOL50IkxcbQK0/Ol7APpFBgsQQ4LdFhHY=";

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
