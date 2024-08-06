{ lib
, fetchFromGitHub
, rustPlatform
, bash
, fd
, just
, libqalculate
, libxkbcommon
, pkg-config
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "pop-launcher";
  version = "1.2.1-unstable-2024-08-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = "c994240676e8fe20aaf631f657545e456725d924";
    sha256 = "sha256-ZK7giScXm2dnjHhPG4dfX77X/4WVNB4ZQG1Tl/9PHFc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-client-toolkit-0.1.0" = "sha256-YLaC59g5VI0R1IohE+T2Drah8eCzGXReOMarY+3m6Ok=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "switcheroo-control-0.1.0" = "sha256-Bz/bzXCm60AF0inpZJDF4iNZIX3FssImORrE5nZpkyQ=";
    };
  };

  nativeBuildInputs = [ just pkg-config ];
  buildInputs = [ bash libxkbcommon ];

  cargoBuildFlags = [ "--package" "pop-launcher-bin" ];
  cargoTestFlags = [ "--package" "pop-launcher-bin" ];

  dontUseJustBuild = true;

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
      --replace-fail 'Command::new("qalc")' 'Command::new("${libqalculate}/bin/qalc")'
    substituteInPlace plugins/src/find/mod.rs \
      --replace-fail 'spawn("fd")' 'spawn("${fd}/bin/fd")'
    substituteInPlace plugins/src/terminal/mod.rs \
      --replace-fail '/usr/bin/gnome-terminal' 'gnome-terminal'

    substituteInPlace justfile \
      --replace-fail '#!/usr/bin/env sh' "#!$SHELL"
  '';

  postInstall = ''
    chmod +x $out/share/pop-launcher/scripts/**/*.sh
  '';

  meta = with lib; {
    description = "Modular IPC-based desktop launcher service";
    homepage = "https://github.com/pop-os/launcher";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ samhug /*lilyinstarlight*/ ];
    mainProgram = "pop-launcher";
  };
}
