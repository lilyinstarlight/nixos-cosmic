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
  pname = "cosmic-applets";
  version = "1.10.0-unstable-2026-10-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "406d1b7d627138fdf4078f654268d3d8774e50f1";
    hash = "sha256-7x4B5Sdzm4JpqqBWGkLlxsYBxP4hfCyN6048/e9d7o4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qmYCI8wfSspQgueY6nO1lOJgEYJPsEyc+WqOMRYTYUI=";

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
    "--set"
    "target"
    "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

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
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
  };
}
