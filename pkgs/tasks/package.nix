{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  libsecret,
  openssl,
  sqlite,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tasks";
  version = "0.1.1-unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "tasks";
    rev = "10f098faac2ebb25051286097d72de49665537f2";
    hash = "sha256-NOjZSyXe6zfSZ1Chiu1zW7N7SUYcGJRM2vdY2je9q9k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zW10eDBTGdir5Tj3pvfpjy6CYyK0G1fXSi6ucrU0D6k=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    libsecret
    openssl
    sqlite
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/tasks"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/tasks";
    description = "Simple task management application for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "tasks";
  };
}
