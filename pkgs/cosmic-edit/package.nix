{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  fontconfig,
  freetype,
  glib,
  gtk3,
  just,
  libinput,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-edit";
  version = "1.0.0-alpha.6-unstable-2025-02-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-edit";
    rev = "efad7d9b9a818a66492845ab51fe330efe19ca54";
    hash = "sha256-b8cMEID7u1Qw/atlGBs+68cxdb6MOnd8kJC5GpCUI+M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+b8pSSBUMs1EJDlldgR1UqLLH0sLU/djMOtE3JsDpkQ=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];
  buildInputs = [
    glib
    gtk3
    libinput
    fontconfig
    freetype
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-edit"
  ];

  env.VERGEN_GIT_SHA = finalAttrs.src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-edit";
    description = "Text Editor for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-edit";
  };
})
