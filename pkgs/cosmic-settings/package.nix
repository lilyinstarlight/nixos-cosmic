{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, cmake
, cosmic-randr
, expat
, fontconfig
, freetype
, just
, libinput
, pkg-config
, udev
, util-linux
}:

let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override { includeSettings = false; };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "0-unstable-2024-07-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "b59b93625af7a00905ed3f78f6c7e43b2e2a7f76";
    hash = "sha256-6UNKAylKbEG4Atz7P0jnSucyt+MbY+vBp7lVCIytAWk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-bg-config-0.1.0" = "sha256-e195Hp0LD0bvHRi3AQvtQ9vccgWBqYwna6g+4U8rWdI=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-vHvoW0tBgM0JR2i6Dr+LuB6qm39j8jQAUej6DyXmLV4=";
      "cosmic-config-0.1.0" = "sha256-1l1X4LtfTOo28MDILiH3vxE5AyJp7XkMYRR34Wvqa9M=";
      "cosmic-panel-config-0.1.0" = "sha256-ALnSJtTp9vtkoM0t7zopOa+twRCCFUqgW9kVqShYhIE=";
      "cosmic-protocols-0.1.0" = "sha256-W7egL3eR6H6FIHWpM67JgjWhD/ql+gZxaogC1O31rRI=";
      "cosmic-randr-0.1.0" = "sha256-cQLTL17/k4uyxhnuJiAChp7ad4RGKwW8fgj77EyCbIA=";
      "cosmic-settings-config-0.1.0" = "sha256-AqpUfpog58pePL8LO2HDSAZOpGCkSBGmlLBVQ7+wsdE=";
      "cosmic-settings-daemon-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "cosmic-text-0.12.0" = "sha256-x7UMzlzYkWySFgSQTO1rRn+pyPG9tXKpJ7gzx/wpm8U=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-OjFcBzVE/fpHTK9bHxcHocEa16q6i9mVRNfJ9lLa/cw=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook' cmake just pkg-config util-linux ];
  buildInputs = [ expat fontconfig freetype libinput udev ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-settings"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ cosmic-randr ]})
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
