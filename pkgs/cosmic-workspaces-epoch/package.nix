{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  libgbm ? null,
  libinput,
  mesa,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-workspaces-epoch";
  version = "1.0.0-alpha.6-unstable-2025-03-21";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "f2a290497877cb210b15defa706bb07080f3ef53";
    hash = "sha256-WRU3LmpuOm0e2ZONVwADf+9Dtbg3AiNmu/h5phWjYbc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PSPdabmIiU4Qm948kHi/GHa/6y6ZE6apQwOqAmUxR7g=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];
  buildInputs = [
    (if libgbm != null then libgbm else mesa)
    libinput
    udev
  ];

  postInstall = ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp data/*.desktop $out/share/applications/
    cp data/*.svg $out/share/icons/hicolor/scalable/apps/
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-workspaces";
  };
}
