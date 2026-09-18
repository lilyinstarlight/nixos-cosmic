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
  version = "1.8.0-unstable-2026-09-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "3faadf56bdaea4b088ea8dc5e808b167cec86de3";
    hash = "sha256-kGYoPIE/owCdoT3uNpDA1w1D1zbRMGrxOS6Yp3BfXzo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YLrUev919xxG74F5Vk85XbJjAvb5IfsDjM6flr7HJwE=";

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
