{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  pciutils,
  stdenv,
  usbutils,
  util-linux,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "examine";
  version = "2.0.0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "examine";
    rev = "bf864499d9b05768ad6e50969e9498bb1772dc56";
    hash = "sha256-Ptbm9b5259Wogh6AS3BJbaMMqZbIHN/OXd7ZWtkd8J4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-V+ClzaG7LnkOl84j5mVGJPTLVfaVqxaSH7ufmjXdwyM=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/examine"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        pciutils
        usbutils
        util-linux
      ]
    })
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/examine";
    description = "System information viewer for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "examine";
  };
}
