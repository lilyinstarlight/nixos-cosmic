{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  fontconfig,
  freetype,
  just,
  libinput,
  pkg-config,
  rustPlatform,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-term";
  version = "1.0.0-alpha.5-unstable-2025-01-11";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "0cc5c3d0d2b79e3e8f52777ab3b2d2caa2b9d797";
    hash = "sha256-c6g5CpJYobKGPp43zhUrWZccMYewV+HBz3kEbQ5iO6Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/cr+lu0ycqTY4mMTj5OIHR9nVUylu+/8oKO5eqCIEpM=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    libinput
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-term"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-term";
  };
}
