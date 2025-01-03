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
  version = "1.0.0-alpha.4-unstable-2025-01-02";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "86b2e152a64cea5d6bef22b04b8c2677ca88acef";
    hash = "sha256-h3uBvmXmokip4cFg81eHrZ7F0GaYQZbesOuUGCv334s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VFsRYGgQW+j3efwiORz8owFs09qdhXUatBi1bnaNcJg=";

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

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-osd";
  };
}
