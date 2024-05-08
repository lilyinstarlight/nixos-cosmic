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
  version = "0-unstable-2024-05-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "8ad117e7c57848f113fbc87986e91209f2262b5a";
    hash = "sha256-cQLTL17/k4uyxhnuJiAChp7ad4RGKwW8fgj77EyCbIA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-protocols-0.1.0" = "sha256-W7egL3eR6H6FIHWpM67JgjWhD/ql+gZxaogC1O31rRI=";
    };
  };

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
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";
  };
}
