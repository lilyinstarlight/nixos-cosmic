{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  cmake,
  cosmic-randr,
  expat,
  fontconfig,
  freetype,
  just,
  libinput,
  pipewire,
  pkg-config,
  pulseaudio,
  udev,
  util-linux,
  xkeyboard_config,
  nix-update-script,
}:

let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override {
    includeSettings = false;
  };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "1.0.0-alpha.3-unstable-2024-11-21";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "4e310024b7457921906df11bc042d40315f23de4";
    hash = "sha256-GGCdrkHhLZAA2Yss5H4fNySMFujq+XaRN68TuEMsBTk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "bluez-zbus-0.1.0" = "sha256-TRXYsnodKjKacc2eVndviEPpma/NNOWstG+ipGcQ0s4=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-bg-config-0.1.0" = "sha256-bmcMZIURozlptsR4si62NTmexqaCX1Yj5bYj49GDehQ=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-7i6tyGKx6UC0iXd6Lcy4XmutxP+4t82W/xgHrsQnQE4=";
      "cosmic-config-0.1.0" = "sha256-VVxiIJanb9gs/7sYpXtsoDdsd+QDUg0QBpBpBWVTSqo=";
      "cosmic-idle-config-0.1.0" = "sha256-+BOzbFDEoIaYkXs48RJtfomv8qdzIFiEpDpN/zDDgFM=";
      "cosmic-panel-config-0.1.0" = "sha256-XbuTvUWS3Z3FMTSm1SYcGxxa5T6FGT2AQQ9uzXH+PlI=";
      "cosmic-protocols-0.1.0" = "sha256-zWuvZrg39REZpviQPfLNyfmWBzMS7A7IBUTi8ZRhxXs=";
      "cosmic-randr-0.1.0" = "sha256-xakK4APhlNKuWbCMP6nJXLyOaQ0hFCvzOht3P8CkV/0=";
      "cosmic-settings-config-0.1.0" = "sha256-QnRicNbKKAjq12hPE6QbtyH0rV33H3RPHdISYjHX7yw=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-fCWGXR+Ky5W/D46OvZX7VyrmOjlxliZCHgsvPS6MgXY=";
      "cosmic-text-0.12.1" = "sha256-nCw3RNIHINXH4+m9wKB+0CeoXSVKKxP+ylaZhfp8u+o=";
      "dpi-0.1.1" = "sha256-whi05/2vc3s5eAJTZ9TzVfGQ/EnfPr0S4PZZmbiYio0=";
      "fast_image_resize-5.0.0" = "sha256-EQBjJlPfoPEFqEYf840jAUfHsGABbsGlGgJ+qwv68Ds=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "superblock-0.1.0" = "sha256-G5jBTr9Cn2wdHlu0mFcYxksBrS5FU3gCzFbMe9B9+VU=";
      "system-0.1.0" = "sha256-iL8DJiMdDXYCZE2npR0S/8eG5GPFthRSokhuKbzW3PQ=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook'
    rustPlatform.bindgenHook
    cmake
    just
    pkg-config
    util-linux
  ];
  buildInputs = [
    expat
    fontconfig
    freetype
    libinput
    pipewire
    pulseaudio
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

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
    libcosmicAppWrapperArgs+=(--set X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
