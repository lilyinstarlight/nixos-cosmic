{ lib
, fetchFromGitHub
, libcosmicAppHook
, rustPlatform
, just
, libsecret
, openssl
, sqlite
, stdenv
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-tasks";
  version = "0.1.0-unstable-2024-09-04";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "tasks";
    rev = "286ef1e6af30b117d96e6e0a04284b9b03ea384c";
    hash = "sha256-h4fNWlbrzVqZ+IPlXc9a8pOFBK6E4bYkRgnlyGyOAeQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-YEPcoGzLDU32X1S+/qFk6o/WGQiTz5RF2l+bvAMhYL0=";
      "cosmic-settings-daemon-0.1.0" = "sha256-eQZdwIHpybv/EKnZDJgdT8dfSY/NEPw9HWphk1i8szU=";
      "cosmic-text-0.12.1" = "sha256-5Gk220HTiHuxDvyqwz1Dwr+BaLvH/6X7M14IirQzcsE=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    libsecret
    openssl
    sqlite
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/tasks"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/cosmic-utils/tasks";
    description = "Simple task management application for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ /*lilyinstarlight*/ ];
    platforms = platforms.linux;
    mainProgram = "tasks";
  };
}
