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
  version = "1.0.0-alpha.5.1-unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "9dd146bb50a5dc4c6ce4b31736df087c4d1a2a76";
    hash = "sha256-a5wzCHfp+dhtEkXsJOeEs2ZkmooSWIDGymeAdrXKE+U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hJC0t8R+cdPWzdpxHA+j7en4IrhZXt5LM3S2V6/bps0=";

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
