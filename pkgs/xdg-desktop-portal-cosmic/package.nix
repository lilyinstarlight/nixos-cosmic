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
  version = "1.0.0-alpha.6-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "e52725d8d2f5862841bad3ce41ef3458268f6401";
    hash = "sha256-iDXg+lZvPdckEI/XtlDx4T6ENqD+DlSEDrQEjsPx+ZQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kcB5BMgbRkuAy4F62w4oRbDKT+BINxO714pE/NaJ1Jw=";

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
