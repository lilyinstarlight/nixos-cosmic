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
  version = "0.1.5-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "leb-kuchen";
    repo = "cosmic-ext-applet-emoji-selector";
    rev = "ab4a4b98f0e6c09f54b8648330ad048b235cd017";
    hash = "sha256-IbRfGX/G0WcAFfvWEMkjST8wBocH0zMd0zoX6v8UYec=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uEcxVaLCXVxSCkKPUgTom86ropE3iXiPyy6ITufWa5k=";

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
