{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  mesa,
  pipewire,
  gst_all_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.4-unstable-2024-12-04";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "e7c92a7316ad5c6e0ccfa08adaae118ee8f2738f";
    hash = "sha256-4FdgavjxRKbU5/WBw9lcpWYLxCH6IJr7LaGkEXYUGbw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-FgfUkU9sv5mq4+pou2myQn6+DkLzPacjUhQ4pL8hntM=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [
    mesa
    pipewire
  ];
  checkInputs = [ gst_all_1.gstreamer ];

  env.VERGEN_GIT_SHA = src.rev;

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

  meta = with lib; {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = platforms.linux;
  };
}
