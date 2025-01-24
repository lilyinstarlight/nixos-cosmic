{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  nix-update-script,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-external-monitor-brightness";
  version = "0-unstable-2024-07-04";

  src = fetchFromGitHub {
    owner = "maciekk64";
    repo = "cosmic-ext-applet-external-monitor-brightness";
    rev = "13b212dff8bc3f4796150d52486f8aacec83b465";
    hash = "sha256-IncYmqAZjocSSxw+5wemKjEYWfp/0YfXvHTv2rYLdSs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kOK4Ndk2vLRucZ318doiYsYEzh5ugUaj23OQ48WRwh0=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")

    "--set"
    "bin-src"
    "./target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-external-monitor-brightness"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/maciekk64/cosmic-ext-applet-external-monitor-brightness";
    description = "Change brightness of external monitors via DDC/CI protocol and also quickly toggle COSMIC system dark mode";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-external-monitor-brightness";
  };
}
