{ lib
, rustPlatform
, fetchFromGitHub
, libcosmicAppHook
, pkg-config
, libinput
, mesa
, udev
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-workspaces-epoch";
  version = "0-unstable-2024-07-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "ef0d7bbc631933b923f2d6b2e831e48a605e4513";
    hash = "sha256-TB/TqCbIqjMR2E18Gtfa9loxYvLHfFCgvDD/EIOEkD8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-bg-config-0.1.0" = "sha256-keKTWghlKehLQA9J9SQjAvGCaZY/7xWWteDtmLoThD0=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-NsF5xB6xXPalNS3KCXPxLn+t+XZX37/zs+2eQigIeTo=";
      "cosmic-config-0.1.0" = "sha256-qULPMuuxmU44qdnHoGW2F9VNmuSkRy7EZPktRiNKVS8=";
      "cosmic-text-0.12.0" = "sha256-VUUCcW5XnkmCB8cQ5t2xT70wVD5WKXEOPNgNd2xod2A=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook pkg-config ];
  buildInputs = [ libinput mesa udev ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
  };
}
