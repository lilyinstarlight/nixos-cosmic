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
  version = "0-unstable-2024-03-02";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "6c6dee8394bea37993ff3c8d956184ecc7b17e4c";
    hash = "sha256-B3/4larHAMO60TZ9FFeJquLkVhOOjKRESfMNNuYV820=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-Zyi95zcBAohM1WBropLzJczSIfNNNBK2odB4AmW4h5I=";
      "cosmic-files-0.1.0" = "sha256-64An0MPgnFgyVlWmtBGBs+IV2z+4vmEY2uRPetZM4/M=";
      "cosmic-text-0.11.2" = "sha256-Y9i5stMYpx+iqn4y5DJm1O1+3UIGp0/fSsnNq3Zloug=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libc-0.2.151" = "sha256-VcNTcLOnVXMlX86yeY0VDfIfKOZyyx/DO1Hbe30BsaI=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "systemicons-0.7.0" = "sha256-zzAI+6mnpQOh+3mX7/sJ+w4a7uX27RduQ99PNxLNF78=";
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
    maintainers = with maintainers; [ ahoneybun nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-term";
  };
}
