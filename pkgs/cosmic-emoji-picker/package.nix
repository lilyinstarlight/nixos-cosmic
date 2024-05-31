{ lib
, fetchFromGitHub
, libcosmicAppHook
, rustPlatform
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-emoji-picker";
  version = "0-unstable-2024-04-01";

  src = fetchFromGitHub {
    owner = "benfuddled";
    repo = "emoji-picker";
    rev = "41bbf0030645a89922dd21dd9cd81e48274c63db";
    hash = "sha256-bGPu4CStwXmUu7MvNfSJI2JGZoTQDg2WAcnmGx5Uvqo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-PEH+aCpjDCEIj8s39nIeWxb7qu3u9IfriGqf0pYObMk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-mz3lzznFU+KNH3YyIc0K6shsNZx8pnK6PkU/gKXbASs=";
      "cosmic-config-0.1.0" = "sha256-onTA3cUsOtPFQ7ptN9ZQUss7KOEWv9KbAnLEy7yfJ3w=";
      "cosmic-text-0.11.2" = "sha256-gUIQFHPaFTmtUfgpVvsGTnw2UKIBx9gl0K67KPuynWs=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "smithay-clipboard-0.8.0" = "sha256-OZOGbdzkgRIeDFrAENXE7g62eQTs60Je6lYVr0WudlE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  meta = with lib; {
    homepage = "https://github.com/benfuddled/emoji-picker";
    description = "Emoji picker for the COSMIC Desktop Environment";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "emoji-picker";
  };
}
