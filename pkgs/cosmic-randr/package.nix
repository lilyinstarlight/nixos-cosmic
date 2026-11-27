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
  version = "1.12.0-unstable-2026-11-24";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "51d8089a5d3c32470a54621ede580e499cd1e93e";
    hash = "sha256-Bzj4BARlY7CZdCL1vu7pdULa6YisRgGxmtm33I9+t4w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9X4TI5vnwTKbmrTz2TZTO/FHwhn8SN0I4PwwvzgZbLY=";

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
