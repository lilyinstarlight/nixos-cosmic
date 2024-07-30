{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, just
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applibrary";
  version = "0-unstable-2024-07-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    rev = "d88d0ba4bc19c35db49e3f1c581e79cf391a28fe";
    hash = "sha256-yP5RE+1Hdg/91vmQVh7/3N3AML6va69j8dBDBy9kbl8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-app-list-config-0.1.0" = "sha256-F0DU4QNt8Euo8jDd1OpuicPeIV57Rz9UxiEAizAkMwE=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-FvAxWnwiqsgy643VIDn9PDTC+lg7yZWbWgFihdExBzU=";
      "cosmic-panel-config-0.1.0" = "sha256-XbyZCOyr0HAkoyjY5Q/IuZgkWVzc3lOfGjGTqvBi1rg=";
      "cosmic-settings-daemon-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "cosmic-text-0.12.0" = "sha256-Xqkh4vrbskW6c1E//DEp9P2dpdDT1D/umbYMhvBLYTw=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
