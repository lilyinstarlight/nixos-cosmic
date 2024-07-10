{ lib
, fetchFromGitHub
, rustPlatform
, geoclue2-with-demo-agent
, pkg-config
, udev
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-settings-daemon";
  version = "0-unstable-2024-07-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "81a5305326cf79fe0ca93c9d17d9c3032a9f491d";
    hash = "sha256-LBXHqM3PO3mJCN4Gi5pEf3T5pMW29QvP+l+bVb0Fxnc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-comp-config-0.1.0" = "sha256-vHvoW0tBgM0JR2i6Dr+LuB6qm39j8jQAUej6DyXmLV4=";
      "cosmic-config-0.1.0" = "sha256-MClnsRE3xq12eib4Y9u32nIBf3/jydzfJhEwuyjyn0U=";
      "cosmic-text-0.12.0" = "sha256-x7UMzlzYkWySFgSQTO1rRn+pyPG9tXKpJ7gzx/wpm8U=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "geoclue2-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  env.GEOCLUE_AGENT = "${lib.getLib geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings Daemon for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
