{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  alsa-lib,
  ffmpeg,
  glib,
  gst_all_1,
  just,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-player";
  version = "0-unstable-2024-12-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-player";
    rev = "011a2c7cc77b6f8ecb295974292357570b3f897d";
    hash = "sha256-ubU5nnMsKqUPdLc6QI5axT5IEM9XV95LuazIZCK2RSs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qm2ysSTKoIeJrRzNi1bEL9WoxEoAgqFu359gNNOVWBE=";

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    just
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-player"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru.updateScript = nix-update-script {
    # TODO: uncomment when there are actual tagged releases
    #extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-player";
    description = "Media player for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-player";
  };
}
