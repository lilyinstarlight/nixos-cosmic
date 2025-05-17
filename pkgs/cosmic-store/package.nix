{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  flatpak,
  glib,
  just,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-store";
  version = "1.0.0-alpha.7-unstable-2025-05-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-store";
    rev = "c5ef69f48c40b4cf02cd4183863103d0fd315314";
    hash = "sha256-TlBKucCeUk/PyG6PAhvsWkWkuYWuQOu8MaVZym+W4G8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2iWJFPSvNQ6JwQwzowKYbgjog2gsjOUlReai/j0d3Do=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];
  buildInputs = [
    glib
    flatpak
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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-store"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-store";
    description = "App Store for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-store";
  };
}
