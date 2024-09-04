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
, pipewire
, pkg-config
, pulseaudio
, udev
, util-linux
, nix-update-script
}:

let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override { includeSettings = false; };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "1.0.0-alpha.1-unstable-2024-09-04";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "544da2bdc87965b8f3de3486075e756b08b1c2be";
    hash = "sha256-ftHfO2wdap5b3avFq3ZqManyz19VRLH8JZuejVflfy0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-bg-config-0.1.0" = "sha256-In/aSQkxXrlTHqrdv14gL7eBu2o7fkmJFVs1HDgGhEQ=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-Qm6rc0snt2NWJMi2sOBW2tOGgAjO5/E7tXHAMWxmvFk=";
      "cosmic-config-0.1.0" = "sha256-YEPcoGzLDU32X1S+/qFk6o/WGQiTz5RF2l+bvAMhYL0=";
      "cosmic-panel-config-0.1.0" = "sha256-Hi4WVWODxtKIzhvq16LVrjvEaLN/FOgA3ycLItx70dY=";
      "cosmic-protocols-0.1.0" = "sha256-zWuvZrg39REZpviQPfLNyfmWBzMS7A7IBUTi8ZRhxXs=";
      "cosmic-randr-0.1.0" = "sha256-g9zoqjPHRv6Tw/Xn8VtFS3H/66tfHSl/DR2lH3Z2ysA=";
      "cosmic-settings-config-0.1.0" = "sha256-2lNUY1N5iAHwV277BKDLEG/fEuDibTQZS4523W8fLn8=";
      "cosmic-settings-daemon-0.1.0" = "sha256-eQZdwIHpybv/EKnZDJgdT8dfSY/NEPw9HWphk1i8szU=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-uizNRoUMLmFdIbWPpvgBxIwZn0m8gfrxRqk/xPbdIvk=";
      "cosmic-text-0.12.1" = "sha256-x0XTxzbmtE2d4XCG/Nuq3DzBpz15BbnjRRlirfNJEiU=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook' rustPlatform.bindgenHook cmake just pkg-config util-linux ];
  buildInputs = [ expat fontconfig freetype libinput pipewire pulseaudio udev ];

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
