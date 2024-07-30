{ lib
, fetchFromGitHub
, rustPlatform
, just
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-screenshot";
  version = "0-unstable-2024-07-25";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "031eb6686196e3dd4d7876ae30572522edc110b9";
    hash = "sha256-+yHpRbK+AWnpcGrC5U0wKbt0u8tm3CFGjKTCDQpb3G0=";
  };

  cargoHash = "sha256-jg2pOOZ9KoyeNLlJ4C4kHXSpCVohuYPIZXtSgPP1ssw=";

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
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}
