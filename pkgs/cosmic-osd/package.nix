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
  version = "1.0.0-alpha.6-unstable-2025-04-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "54c9672fa28c083953b2eae33c38fa4c6ebf3881";
    hash = "sha256-POjuxrNBajp4IOw7YwF2TS4OfoM8Hxo1fO48nkhKj8U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kfExKggQo3MoTXw1JbKWjLu5kwYF0n7DzSQcG6e1+QQ=";

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
