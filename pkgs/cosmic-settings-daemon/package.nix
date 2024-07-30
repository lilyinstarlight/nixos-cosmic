{ lib
, fetchFromGitHub
, rustPlatform
, geoclue2-with-demo-agent
, libinput
, pkg-config
, udev
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-settings-daemon";
  version = "0-unstable-2024-07-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "54700dfee57d1569efb2179896e36d754c2bf270";
    hash = "sha256-XMTh7w6qm7ATMnu/IxMavbHKaT8EbNiL+cBCB6wuwfE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-comp-config-0.1.0" = "sha256-224Z6/KF6x0mOOe81Ny+9RTjHt+Y63UZ+4+mQ8Y7aqU=";
      "cosmic-config-0.1.0" = "sha256-S7/SZgOCeiuFkKNoPfG5YizAs3cGdjb7XIiMbHZ56ss=";
      "cosmic-text-0.12.0" = "sha256-VUUCcW5XnkmCB8cQ5t2xT70wVD5WKXEOPNgNd2xod2A=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "geoclue2-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libinput udev ];

  env.GEOCLUE_AGENT = "${lib.getLib geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings Daemon for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
  };
}
