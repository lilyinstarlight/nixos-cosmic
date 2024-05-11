{ lib
, fetchFromGitHub
, rustPlatform
, just
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-screenshot";
  version = "0-unstable-2024-05-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "a8130eb9dc74ea8720240e3890a87b1fbe7f234f";
    hash = "sha256-pfjOyHq7YdlyRGnLQRrNYOrk0Uqu6RjDxuTmLYyYdKg=";
  };

  cargoHash = "sha256-fNE4mCC3aLishhP3s7wKsmiVXf16Q7lfXEiH294nvnY=";

  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-screenshot"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}
