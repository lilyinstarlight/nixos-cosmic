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
  version = "1.2.4-unstable-2025-03-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = "926abeb37348f28a0ca6c35c706807f249fa900a";
    hash = "sha256-bx95G2k5QFBpkKYbWlajKAOXYb/+fYiN+2aEJxLmOtA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MLh6gI8Kfio655Df+o58/8aAJNxoT51feHvkjtPgPrU=";

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

  meta = {
    description = "Modular IPC-based desktop launcher service";
    homepage = "https://github.com/pop-os/launcher";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "pop-launcher";
  };
}
