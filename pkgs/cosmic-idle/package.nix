{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  bash,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-idle";
  version = "1.12.0-unstable-2026-11-24";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-idle";
    rev = "63a1605b0d7027e88e82402623ee0373106bf806";
    hash = "sha256-aVPiZyuaruSPw9BGPg9I/UD9TZmHVpbWteE9ruYSvII=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zirY87+JRrOp1eSB4kw2s0+3bm7SY78xqL4PyVhp6Lo=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-idle"
  ];

  postPatch = ''
    substituteInPlace src/main.rs --replace-fail '"/bin/sh"' '"${lib.getExe bash}"'
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-idle";
    description = "Idle daemon for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-idle";
  };
}
