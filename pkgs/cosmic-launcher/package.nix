{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, just
, stdenv
, nix-update-script
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-launcher";
  version = "1.0.0-alpha.1-unstable-2024-09-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-launcher";
    rev = "9269534c986609508ad6e6b7e0ce65ab0699934f";
    sha256 = "sha256-15ODff+H6xQ17DgR5fio9GOh7zozNTq4ZY2rFAyGWSA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-FRSM3YQuP5eJhUlD5uS6l5A/d422W7ZtT4GcVOubxWw=";
      "cosmic-settings-daemon-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "cosmic-text-0.12.1" = "sha256-x0XTxzbmtE2d4XCG/Nuq3DzBpz15BbnjRRlirfNJEiU=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "pop-launcher-1.2.2" = "sha256-tQtjPwSBKrT1Uq62hQLR+MBbn6UJ3OSlkNSSNCJcYas=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-launcher"
  ];

  env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" = "--cfg tokio_unstable";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-launcher";
    description = "Launcher for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
    mainProgram = "cosmic-launcher";
  };
}
