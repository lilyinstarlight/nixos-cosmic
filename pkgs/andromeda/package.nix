{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "andromeda";
  version = "0-unstable-2025-01-11";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "andromeda";
    rev = "4528864f223afcf28228eee245ea9f0f9abc4fa2";
    hash = "sha256-v2pmOQt5xr6iHGnJ8lz8f1hJnofmEsAWvh/I2BykI+k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JBCpSOZp+ItyUB+yAxH+37EAo851JXMafjUb+SrIMyw=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/andromeda"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/cosmic-utils/andromeda";
    description = "Disk management utility for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "andromeda";
  };
}
