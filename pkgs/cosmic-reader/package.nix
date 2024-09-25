{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-reader";
  version = "0-unstable-2024-06-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "c54e8ecee535a897bed3f1bb5d64eecae60f36c2";
    hash = "sha256-u2aKESCgg9lwU0oFvujt5avLoPWunl3dkzufCzE0j0Y=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-G6r7cUmdom8LhIUzm3JTVry+WQzHyxUFWbQ0gry11Eo=";
      "cosmic-config-0.1.0" = "sha256-C+7gESljo1Dpz8+NoeOba67E3RO+o6qm3shNLXQMNgo=";
      "cosmic-text-0.11.2" = "sha256-K4YQjGsLjSTdu3FhXMCZP8XHQoqIcS/4BqUnfaSJGiU=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "lopdf-0.32.0" = "sha256-NqlIYMfHkah9eLxMf9uVXZ0BbyvKFR1/iA86zU4FF4Q=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  passthru.updateScript = nix-update-script {
    # TODO: uncomment when there are actual tagged releases
    #extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-reader";
    description = "PDF reader for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers =
      with maintainers;
      [
        # lilyinstarlight
      ];
    platforms = platforms.linux;
    mainProgram = "cosmic-reader";
  };
}
