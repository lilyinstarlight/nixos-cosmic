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
  pname = "cosmic-ext-applet-emoji-selector";
  version = "0.1.5-unstable-2025-01-27";

  src = fetchFromGitHub {
    owner = "leb-kuchen";
    repo = "cosmic-ext-applet-emoji-selector";
    rev = "1b2eb23ba4d337482ed10b0595be3b603020cad2";
    hash = "sha256-G5Al0YRf0a4WuvYB7kDWCPPl+f/GBrN6M2SMVgO+U94=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0V0zKGsNzUXlAjzf4dm4khnzhqNsXvxaLLlIB+JvF9s=";

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
  ];

  installTargets = [
    "install"
    "install-schema"
  ];

  postPatch = ''
    substituteInPlace justfile \
      --replace-fail './target/release' './target/${stdenv.hostPlatform.rust.cargoShortTarget}/release' \
      --replace-fail '~/.config/cosmic' "$out/share/cosmic"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/leb-kuchen/cosmic-ext-applet-emoji-selector";
    description = "Emoji selector applet for the COSMIC Desktop Environment";
    license = with lib.licenses; [
      mpl20
      mit
    ];
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-emoji-selector";
  };
}
