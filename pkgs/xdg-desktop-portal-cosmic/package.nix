{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  coreutils,
  libgbm ? null,
  mesa,
  pipewire,
  pkg-config,
  gst_all_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.5.1-unstable-2025-01-17";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "7afb043c669d2bc5bbc36b2bc61edaf64444827c";
    hash = "sha256-/fsEYZWNNPAlMdVKyNPDNGEtV2HkYwTrbokXEx4Cxz8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NQJZYN+eye7QIkaR5n2qpXDpllmRJfQ/DK/o0UtRt4A=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
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

  postInstall = ''
    mkdir -p $out/share/{dbus-1/services,icons,xdg-desktop-portal/portals}
    cp -r data/icons $out/share/icons/hicolor
    cp data/*.service $out/share/dbus-1/services/
    cp data/cosmic.portal $out/share/xdg-desktop-portal/portals/
    cp data/cosmic-portals.conf $out/share/xdg-desktop-portal/
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
