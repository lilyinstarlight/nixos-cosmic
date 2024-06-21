{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, just
, nasm
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-bg";
  version = "0-unstable-2024-06-21";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-bg";
    rev = "3e52868f0f30857fed59b46a54fe480a7ea0d40d";
    hash = "sha256-Ah6JpthWE+/Mz+zKOdmEW4Z29xeI0norjXAbQwE5N24=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-5J9tjpEcZJrUtW7barwXTOTNXNr33TLwYjApKkwDSvc=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just nasm ];

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
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-bg";
  };
}
