{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "gui-scale-applet";
  version = "2.0.0-unstable-2025-03-24";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = "957bb3c2d2fb483e5bce4b855b86a71c0a3621f3";
    hash = "sha256-Hc6oplWdyRc5PkDY1Gq2Ja7tihNVutci7jg+ZZYp6ws=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2yfeZKsakAeAtNcK8v7hqwMBm7o7HhiNU5mgPevhNvo=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/gui-scale-applet"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/gui-scale-applet";
    description = "Tailscale applet for the COSMIC Desktop Environment";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "gui-scale-applet";
  };
}
