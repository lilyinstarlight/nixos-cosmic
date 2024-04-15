{ lib
, fetchFromGitHub
, wrapCosmicAppsHook
, fontconfig
, freetype
, just
, libinput
, pkg-config
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-term";
  version = "0-unstable-2024-04-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "38d6ca4ac81baac8e3ee7c1b2e17992806620f39";
    hash = "sha256-VY+QS1kIEjsiJ5PWQexevvLfB51fNkfYH88bDeWK5dQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-PEH+aCpjDCEIj8s39nIeWxb7qu3u9IfriGqf0pYObMk=";
      "cosmic-config-0.1.0" = "sha256-x/xWMR5w2oEbghTSa8iCi24DA2s99+tcnga8K6jS6HQ=";
      "cosmic-files-0.1.0" = "sha256-KzWlmeZP3F5Kavi9FFXo3o8nB/h79TtOhqWUyI1ZRB0=";
      "cosmic-text-0.11.2" = "sha256-K9cZeClr1zz4LanJS0WPEpxAplQrXfCjFKrSn5n4rDA=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libc-0.2.151" = "sha256-VcNTcLOnVXMlX86yeY0VDfIfKOZyyx/DO1Hbe30BsaI=";
      "smithay-clipboard-0.8.0" = "sha256-OZOGbdzkgRIeDFrAENXE7g62eQTs60Je6lYVr0WudlE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [
    wrapCosmicAppsHook
    just
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    libinput
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-term"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-term";
  };
}
