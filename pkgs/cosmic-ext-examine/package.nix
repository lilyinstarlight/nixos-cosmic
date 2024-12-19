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
  version = "1.0.0-unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "examine";
    rev = "01fb9391a1db773c7c23b4104340b87ea5f1045e";
    hash = "sha256-FAAAl18Gh1Cw0s6+szWa0HfXWNqvHfLp8VUPBIuKyN4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0H6BHscAqDDf0ZiU52yRVQf7ECVHNeeYYbogLX/N9aY=";

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

  meta = with lib; {
    homepage = "https://github.com/cosmic-utils/examine";
    description = "System information viewer for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "examine";
  };
}
