{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, just
, pkg-config
, wayland
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-randr";
  version = "0-unstable-2024-01-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "88c570cf8b88beae1cf4f3e2d412cc64ec49cd7c";
    hash = "sha256-t1PM/uIM+lbBwgFsKnRiqPZnlb4dxZnN72MfnW0HU/0=";
  };

  cargoHash = "sha256-n6DrKVUWUrTV2agUsN5dXAzxECuarVzZ0CYRfJQn1KI=";

  nativeBuildInputs = [ just pkg-config ];
  buildInputs = [ wayland ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-randr"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-randr";
    description = "Library and utility for displaying and configuring Wayland outputs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";
  };
}
