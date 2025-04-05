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
  version = "1.0.0-alpha.6-unstable-2025-04-04";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "ce4bfdd643f0d1e3b33f4de00fd915d58a3421a1";
    hash = "sha256-Qc7BcZAWKxxDXwoQycSWlIkoN9fC2THsz9QwMn5qjQk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-anTuCncVlNZp2zWBxKWwlZFI50MQmB9biFfORhcLrzc=";

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
