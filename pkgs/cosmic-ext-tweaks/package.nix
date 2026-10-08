{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-tweaks";
  version = "0.2.5-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "tweaks";
    rev = "5548414a6dc3753cc54b3939b05f9e5ff35b1e93";
    hash = "sha256-LYz4wSsbhFxyBpVMDxF1cKy0xyx6B+M4Wr79LTmPJzk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8pGMau1XeAM4OAVSJH2r+N+X8fEuvuEqf0g+zeiTRM0=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-tweaks"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/tweaks";
    description = "Tweaking tool for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-tweaks";
  };
}
