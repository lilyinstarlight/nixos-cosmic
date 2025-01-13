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

rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-examine";
  version = "1.0.0-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "examine";
    rev = "722d7219819b153b59e574a1f49e485f2f9b98bb";
    hash = "sha256-oBiBbZAeSTn4tzjSrczUPQ/kMSSABKwaGPI7XXqGfnw=";
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

  env.VERGEN_GIT_SHA = src.rev;

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
