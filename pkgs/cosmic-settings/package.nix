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
, nix-update-script
}:

let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override { includeSettings = false; };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "1.0.0-alpha.1-unstable-2024-08-12";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "66f32168cabc30ec990befeb3e6bb788e786cd9c";
    hash = "sha256-GJ+5MlNTk04pqltiRTk3nwnxEPK8UV6kzKU3xo/6Ors=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-bg-config-0.1.0" = "sha256-keKTWghlKehLQA9J9SQjAvGCaZY/7xWWteDtmLoThD0=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-2Q1gZLvOnl5WHlL/F3lxwOh5ispnOdYSw7P6SEgwaIY=";
      "cosmic-config-0.1.0" = "sha256-zdhdsGpf+/38WLDL1goKH22FbZx/Ntz4GUedaToGgEo=";
      "cosmic-panel-config-0.1.0" = "sha256-u4JGl6s3AGL/sPl/i8OnYPmFlGPREoy6V+sNw+A96t0=";
      "cosmic-protocols-0.1.0" = "sha256-zWuvZrg39REZpviQPfLNyfmWBzMS7A7IBUTi8ZRhxXs=";
      "cosmic-randr-0.1.0" = "sha256-g9zoqjPHRv6Tw/Xn8VtFS3H/66tfHSl/DR2lH3Z2ysA=";
      "cosmic-settings-config-0.1.0" = "sha256-/Qav6r4VQ8ZDSs/tqHeutxYH3u4HiTBFWTfAYUSl2HQ=";
      "cosmic-settings-daemon-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "cosmic-text-0.12.1" = "sha256-x0XTxzbmtE2d4XCG/Nuq3DzBpz15BbnjRRlirfNJEiU=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
