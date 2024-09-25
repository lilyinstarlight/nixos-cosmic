{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bash,
  fd,
  just,
  libqalculate,
  libxkbcommon,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "pop-launcher";
  version = "1.2.1-unstable-2024-08-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = "6a1b8b9ad0563693136872809dac2a30fb7d633f";
    sha256 = "sha256-kZs9h2Q80/xPyRFTNiEPQrywHBGHQWDplBiYuZbyiS4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-client-toolkit-0.1.0" = "sha256-YLaC59g5VI0R1IohE+T2Drah8eCzGXReOMarY+3m6Ok=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "switcheroo-control-0.1.0" = "sha256-Bz/bzXCm60AF0inpZJDF4iNZIX3FssImORrE5nZpkyQ=";
    };
  };

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [
    bash
    libxkbcommon
  ];

  cargoBuildFlags = [
    "--package"
    "pop-launcher-bin"
  ];
  cargoTestFlags = [
    "--package"
    "pop-launcher-bin"
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "base-dir"
    (placeholder "out")
    "--set"
    "target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  postPatch = ''
    substituteInPlace src/lib.rs \
      --replace-fail '/usr/lib/pop-launcher' "$out/share/pop-launcher"
    substituteInPlace plugins/src/scripts/mod.rs \
      --replace-fail '/usr/lib/pop-launcher' "$out/share/pop-launcher"
    substituteInPlace plugins/src/calc/mod.rs \
      --replace-fail 'Command::new("qalc")' 'Command::new("${lib.getExe libqalculate}")'
    substituteInPlace plugins/src/find/mod.rs \
      --replace-fail 'spawn("fd")' 'spawn("${lib.getExe fd}")'
    substituteInPlace plugins/src/terminal/mod.rs \
      --replace-fail '/usr/bin/gnome-terminal' 'gnome-terminal'

    substituteInPlace justfile \
      --replace-fail '#!/usr/bin/env sh' "#!$SHELL"
  '';

  postInstall = ''
    chmod +x $out/share/pop-launcher/scripts/**/*.sh
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Modular IPC-based desktop launcher service";
    homepage = "https://github.com/pop-os/launcher";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "pop-launcher";
  };
}
