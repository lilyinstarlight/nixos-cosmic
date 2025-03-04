{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  dbus,
  glib,
  just,
  libinput,
  pkg-config,
  pulseaudio,
  stdenv,
  udev,
  util-linux,
  xkeyboard_config,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "gui-scale-applet";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = "9251253d6332820d267bf9d825e6af522ae63eb7";
    hash = "sha256-1zCANfgWgDkSTvpvgxzve/ErGel2WF1RxIhv/EdIxxo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2yfeZKsakAeAtNcK8v7hqwMBm7o7HhiNU5mgPevhNvo=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
    util-linux
  ];
  buildInputs = [
    dbus
    glib
    libinput
    pulseaudio
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    # "--set"
    # "target"
    # "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
    "--set"
    "bin-src"
    "${stdenv.hostPlatform.rust.cargoShortTarget}/release/gui-scale-applet"
  ];

  preInstall = ''
    mkdir -p "$TMPDIR/cargo-target/release/gui-scale-applet"
  '';

  postInstall = ''
    libcosmicAppWrapperArgs+=(--set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set-default X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/cosmic-utils/gui-scale-applet";
    description = "Tailscale for cosmic";
    # license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
  };
}
