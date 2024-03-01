{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, just
, nasm
, pkg-config
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-bg";
  version = "0-unstable-2024-02-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-bg";
    rev = "218b1a558a1f70b3590ce7d26776e3b8c76d9891";
    hash = "sha256-U+BF+lLd/DmZq8ISc9zHAegzv0K97g9Qq+D9qZDbyY4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-yDNg1JE/MKboG6F/WP04XdXkWH5VNtnzbPze4J79erc=";
      "smithay-client-toolkit-0.18.0" = "sha256-7s5XPmIflUw2qrKRAZUz30cybYKvzD5Hu4ViDpzGC3s=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook just nasm pkg-config ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-bg"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-bg";
    description = "Applies Background for the COSMIC Desktop Environment";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-bg";
  };
}
