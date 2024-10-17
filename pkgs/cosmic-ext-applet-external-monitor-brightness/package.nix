{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  nix-update-script,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-external-monitor-brightness";
  version = "0-unstable-2024-07-04";

  src = fetchFromGitHub {
    owner = "maciekk64";
    repo = "cosmic-ext-applet-external-monitor-brightness";
    rev = "13b212dff8bc3f4796150d52486f8aacec83b465";
    hash = "sha256-IncYmqAZjocSSxw+5wemKjEYWfp/0YfXvHTv2rYLdSs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-l4LKJ19/5UOMm8oWhhVFvoN4Kbar/EMwBKaiA8RZ7VU=";
      "cosmic-panel-config-0.1.0" = "sha256-ALnSJtTp9vtkoM0t7zopOa+twRCCFUqgW9kVqShYhIE=";
      "cosmic-text-0.12.0" = "sha256-x7UMzlzYkWySFgSQTO1rRn+pyPG9tXKpJ7gzx/wpm8U=";
      "cosmic-time-0.4.0" = "sha256-qOxfyQ2r3yD6i/rgm22oNuOWslBgWrVh9zw3/qLIDT0=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-OjFcBzVE/fpHTK9bHxcHocEa16q6i9mVRNfJ9lLa/cw=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
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
    "./target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-external-monitor-brightness"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/maciekk64/cosmic-ext-applet-external-monitor-brightness";
    description = "Change brightness of external monitors via DDC/CI protocol. You can also quickly toggle COSMIC system dark mode.";
    license = with licenses; [
      gpl3Only
    ];
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-ext-applet-external-monitor-brightness";
  };
}
