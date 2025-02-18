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
  version = "1.0.0-unstable-2025-01-26";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "examine";
    rev = "be88b571a7730ebac1605e786c148f9bd27f445e";
    hash = "sha256-GzmV6g6apCHnpTaQQuQ9v+6VHJYgRZX5Xi1yEBZ6WLQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zTtUHjwXhrw4AZYEI8BhbzOj0uV1s9WB7ITw1ZyH5/M=";

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
