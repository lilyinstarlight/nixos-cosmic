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
  version = "1.0.0-alpha.2-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "907471b6bc42151ef0ed80a6f595e82b85367dc4";
    hash = "sha256-qLobKI6+rclkGSBLz4XlHYQY+P/AZZDEsJY1Tns5Y3s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-protocols-0.1.0" = "sha256-6XM6kcM2CEGAziCkal4uO0EL1nEWOKb3rFs7hFh6r7Y=";
    };
  };

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

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-randr";
    description = "Library and utility for displaying and configuring Wayland outputs";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";
  };
}
