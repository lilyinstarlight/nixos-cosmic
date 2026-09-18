{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  util-linux,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "1.8.0-unstable-2026-09-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "d6387697faf96f1a9cb04e580753089eec350249";
    hash = "sha256-MSuXxap/Miiz7Ym3OhT2Zu2KIcl6cTMUL7zQiSNjxu0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-02BfZfASrQYn/nwmxS7CRS7ONie8b22F0V3XwFVyfKE=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    util-linux
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-panel"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-panel";
  };
}
