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
  version = "0-unstable-2024-07-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "e214fe92036b902f15098277de1e1be76b7b2e85";
    hash = "sha256-nzfPdR35pqbiutnS8GjI0St54WJgTtUHEahmnQ6+NVs=";
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
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";
  };
}
