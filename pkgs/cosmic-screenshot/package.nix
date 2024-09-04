{ lib
, fetchFromGitHub
, rustPlatform
, just
, stdenv
, nix-update-script
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-screenshot";
  version = "1.0.0-alpha.1-unstable-2024-07-25";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "031eb6686196e3dd4d7876ae30572522edc110b9";
    hash = "sha256-+yHpRbK+AWnpcGrC5U0wKbt0u8tm3CFGjKTCDQpb3G0=";
  };

  cargoHash = "sha256-UTkE0PPYb7Q27KUWwdHOAOoJRRsnxy9HM2Sy3Kckxpk=";

  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-screenshot"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}
