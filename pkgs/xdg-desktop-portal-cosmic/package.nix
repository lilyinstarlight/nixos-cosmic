{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  coreutils,
  util-linux,
  libgbm ? null,
  mesa,
  pipewire,
  pkg-config,
  gst_all_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.12.0-unstable-2026-11-24";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "e046d1f29669e24d76fa7042e88e91dca8cdb782";
    hash = "sha256-GP9IQ5U1qdLt8UJTO4F4cCwcYGS7qDCfVlfN55agzq4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WaPa5at4IYjXa2ti4ni4kmbK8SCF59KOPsXz6RFLEJ4=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
    util-linux
  ];
  buildInputs = [
    (if libgbm != null then libgbm else mesa)
    pipewire
  ];
  checkInputs = [ gst_all_1.gstreamer ];

  env.VERGEN_GIT_SHA = src.rev;

  # TODO: remove when dbus activation for xdg-desktop-portal-cosmic is fixed to properly start it
  postPatch = ''
    substituteInPlace data/org.freedesktop.impl.portal.desktop.cosmic.service \
      --replace-fail 'Exec=/bin/false' 'Exec=${lib.getExe' coreutils "true"}'
  '';

  dontCargoInstall = true;

  makeFlags = [
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
    "prefix=${placeholder "out"}"
  ];

  postInstall = ''
    mv $out/libexec $out/bin
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = lib.platforms.linux;
  };
}
