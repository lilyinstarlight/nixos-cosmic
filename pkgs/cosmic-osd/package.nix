{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  pkg-config,
  pulseaudio,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-osd";
  version = "1.11.0-unstable-2026-11-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "552753febb27baa2f54c6098033d4bd60a7473ed";
    hash = "sha256-ewTXoqWDOLJSi8vKK0ImRzHfw1CbEVC3rKCP6vDimJs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xKgvlEqBf8uKKMdS9/RgLULfC16J6rqEWy25lQjv8NI=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];
  buildInputs = [
    pulseaudio
    udev
  ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-osd";
  };
}
