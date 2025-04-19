{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  util-linux,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "1.0.0-alpha.6-unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "72581ce21346d85007e44ce43ae48c6ea92b5f61";
    hash = "sha256-JFrkWEmKGFM51qf9G8RrV5paCfbSSGjHrJcRV6sKflg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pClxymaW2gtASUcbQs6GBnvK9BB0ZN+0jV8f2OO1J+g=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    util-linux
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-panel"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-panel";
  };
}
