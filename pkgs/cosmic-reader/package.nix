{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-reader";
  version = "0-unstable-2026-05-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "c29b3e82c0827133b24dcdb43e1f28a1c7df37a1";
    hash = "sha256-YsRXWSf2l8RfIEXKxvJtYWxhma8N2Y+0/HZwhs7d5k8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-P9ZC7721MjC/h7sbf7x91WGfMbT4tA46HrYhDgCeiWE=";

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  passthru.updateScript = nix-update-script {
    # TODO: uncomment when there are actual tagged releases
    #extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-reader";
    description = "PDF reader for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-reader";
  };
}
