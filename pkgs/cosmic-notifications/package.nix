{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, just
, stdenv
, which
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-notifications";
  version = "0-unstable-2024-05-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-notifications";
    rev = "bcac69002446650ab5d26d074fbfb071487f1ad7";
    hash = "sha256-lznrLvKKvjvmUipzRge/jofHrOhQzcsA8eL+11ArP8U=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-client-toolkit-0.1.0" = "sha256-XUiyL4M3hLBoBlpuG0K71QuhM4SSUBeYGtUhD+FL6Wg=";
      "cosmic-config-0.1.0" = "sha256-b0g3NFMFu/QJ2lPUKwwwMmN+MuF8NB3F+lirlZ5tUmA=";
      "cosmic-panel-config-0.1.0" = "sha256-pxpcYRVZu/1Ykq5Y+O7k12oba5om19t49IWDd3l/eQo=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-Jpgbg1DScteec7ItcGgbQYXu1bBNYJEw1SGsxpcxYfM=";
      "cosmic-time-0.4.0" = "sha256-qOxfyQ2r3yD6i/rgm22oNuOWslBgWrVh9zw3/qLIDT0=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-OjFcBzVE/fpHTK9bHxcHocEa16q6i9mVRNfJ9lLa/cw=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook just which ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-notifications"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-notifications";
    description = "Notifications for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
