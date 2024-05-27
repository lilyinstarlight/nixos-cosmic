{ lib
, fetchFromGitHub
, wrapCosmicAppsHook
, rustPlatform
, libsecret
, openssl
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-tasks";
  version = "0-unstable-2024-05-23";

  src = fetchFromGitHub {
    owner = "edfloreshz";
    repo = "cosmic-tasks";
    rev = "9dceda88d05890c98a5eada327cd7dc382122175";
    hash = "sha256-qVG/FgpVjQX1DJkqV/7tsw4cA8H/GzvUAc4gNjBEDm8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-config-0.1.0" = "sha256-TRqVNxZzp5PplDoo51J3KiujyRwxVE0z1Sx7lFgUdnQ=";
      "cosmic-text-0.11.2" = "sha256-Jpgbg1DScteec7ItcGgbQYXu1bBNYJEw1SGsxpcxYfM=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [
    wrapCosmicAppsHook
  ];

  buildInputs = [
    libsecret
    openssl
    sqlite
  ];

  env.VERGEN_GIT_SHA = src.rev;

  meta = with lib; {
    homepage = "https://github.com/edfloreshz/cosmic-tasks";
    description = "Simple task management application for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-tasks";
  };
}
