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
  version = "0.1.5-unstable-2024-08-19";

  src = fetchFromGitHub {
    owner = "leb-kuchen";
    repo = "cosmic-ext-applet-emoji-selector";
    rev = "13c0a7e1a10202775870d4320e4b1c5e00eecd42";
    hash = "sha256-6I9LPy7dpF0L9tb5EZzlXTRmF2RgRhEIiszlEL+DvTg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SK9VuF01/9qJ3FVV74Mp7qdRQSYQ8rbS4QDwG/ZHkzM=";

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

  meta = with lib; {
    homepage = "https://github.com/leb-kuchen/cosmic-ext-applet-emoji-selector";
    description = "Emoji selector applet for the COSMIC Desktop Environment";
    license = with licenses; [
      mpl20
      mit
    ];
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-ext-applet-emoji-selector";
  };
}
