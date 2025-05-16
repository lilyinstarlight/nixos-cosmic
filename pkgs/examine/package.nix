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
  version = "1.0.0-unstable-2025-04-30";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "examine";
    rev = "030d5aa3e0d85589c95b102362983aa4c7bd2aed";
    hash = "sha256-AbS8ZDv3r/tQScD7g8zVHWLbvu8xETIADS5IotLgCn0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fBsBeSkywPDAzv7YUfhGQz/4BNNFqfPjfS/IKc57DAY=";

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
