{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, pkg-config
, udev
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-osd";
  version = "0-unstable-2024-02-07";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "bc35c944e3f4c8bb98b963f8e150830838333ced";
    hash = "sha256-relTvKbhHLaN6LDcPuRNLFLUzhy1s1A/zv1xGq3MabM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-SQD6LEqKAI0A7CGLskEGXNeuSZPfVUQBZC9ymsCoVE8=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-jtWMF9lj5oF1vebLbLPtcpLlmMBohN6OuFIqmgrw+Qk=";
      "cosmic-text-0.10.0" = "sha256-y9H13YM9EaZVtQ81gm6QERYke3HonPS436dYy578ZiM=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-YPPRicmBHpNX9JHDWt2x5z4m3VT2caYpo5GwGD18O/o=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-CACVCnyFgefkpDlll6IeaPWB8a3gbF6BW8MnlkytV8o=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook pkg-config ];
  buildInputs = [ udev ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
