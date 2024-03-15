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
  version = "0-unstable-2024-03-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "79f0806958787c2c053f5718179fc5e4d3083f14";
    hash = "sha256-EX0vjOG4vrXGjRR/6SzHWkRDduTjpDO5lai6Ezx6ayM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-fp0c8ek7GA8E6Ony2uTNjRJvmMJLGx8g1DT+WbmFjj8=";
      "cosmic-files-0.1.0" = "sha256-aebf/gr4y2aORuL7ZAa00kgNI/wBvqlWeC88it5yWrw=";
      "cosmic-text-0.11.2" = "sha256-PYA3IOXxO7cuX4KwHdW2o3Shf8ceSjbTYoHJi2GmKUY=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libc-0.2.151" = "sha256-VcNTcLOnVXMlX86yeY0VDfIfKOZyyx/DO1Hbe30BsaI=";
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
