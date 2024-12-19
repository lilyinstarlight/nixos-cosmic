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
  version = "1.2.4-unstable-2024-12-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = "c37c2a3c6a0b0167267140f2792c49ccc0c15767";
    hash = "sha256-p9jFLKvxg95S/H4nC71fbs9iD438dXIjFHCUfN3ftqM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2gPWVchzFW1rIc/1/EJ3grS3Dku0GDEE3hj8L91NSvA=";

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
