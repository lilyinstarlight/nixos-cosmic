{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  just,
  pkg-config,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-randr";
  version = "1.0.0-alpha.5.1-unstable-2025-01-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "da7df14acdf18d9ae36d1fec15a8a91e0be6a192";
    hash = "sha256-mPi6TVUWKlHqLzGL84vSBZYuCjdThVVYc7hv9vq7zho=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3I4ZyZvV9ELBNCvYVYBUHbh9bGw7B/RrwUlam5fdLxU=";

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [ wayland ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-randr"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-randr";
    description = "Library and utility for displaying and configuring Wayland outputs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-randr";
  };
}
