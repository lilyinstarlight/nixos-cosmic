{ lib
, fetchFromGitHub
, rustPlatform
, just
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-screenshot";
  version = "0-unstable-2024-02-26";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "f853446dbe1ff6e124749cdfd0eeb94dc43e884a";
    hash = "sha256-/sEM+607/W1e7CrrBc0+7Z9Kh5JKypMJi1X6KmFfnFw=";
  };

  cargoHash = "sha256-YcbZZmApeze64qrB4zUtGYz6Qi31z7gJ1oDFaMUUJIg=";

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
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}
