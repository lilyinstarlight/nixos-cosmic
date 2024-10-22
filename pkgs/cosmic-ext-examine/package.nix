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
  version = "1.0.0-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "examine";
    rev = "04af93cdcb5d1231723cff57992178636c9bf20e";
    hash = "sha256-+anofhvWsVGF7EoUhsoQiVdgoXQNLO4RLefIxUVrcDI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-wIpwUWyUBIm39jeZ5YXB1X49+SByqwWYcP6H0PYC8Kg=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-ojvLP1G8huTR9fiqMLosKeYYVnhKINzyJzOPEM2gUUQ=";
      "cosmic-config-0.1.0" = "sha256-ssxb6JJ/8yzjLr9qtCTVay+ckkBKCiu64jX7eGVFQ/0=";
      "cosmic-settings-daemon-0.1.0" = "sha256-mklNPKVMO6iFrxki2DwiL5K78KiWpGxksisYldaASIE=";
      "cosmic-text-0.12.1" = "sha256-u2Tw+XhpIKeFg8Wgru/sjGw6GUZ2m50ZDmRBJ1IM66w=";
      "dpi-0.1.1" = "sha256-yGkLPQzH3Cf0QJO9f45Jn2ZcoONT4zhqVrJcR/RQAqU=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

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
