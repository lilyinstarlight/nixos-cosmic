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
  version = "1.0.0-alpha.5.1-unstable-2025-01-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "9b4e2bebbf8cf39c49c6dfa021afbcf49e1fd777";
    hash = "sha256-FBWERVXVY8CUr4PxdnmDbt+V2b45PcpYR2Zwa6vXu+I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uhJUP4vxslpV9NlfAZ8jR4HtvUH/EgNGP/NVT1MdoCM=";

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
    platforms = lib. platforms.linux;
    mainProgram = "cosmic-osd";
  };
}
