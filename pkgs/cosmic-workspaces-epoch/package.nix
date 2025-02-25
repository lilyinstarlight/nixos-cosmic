{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  libgbm ? null,
  libinput,
  mesa,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-workspaces-epoch";
  version = "1.0.0-alpha.6-unstable-2025-02-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "7f877f72a373514d298259ad7c6a6b3a5e10432c";
    hash = "sha256-3jivE0EaSddPxMYn9DDaYUMafPf60XeCwVeQegbt++c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-l5y9bOG/h24EfiAFfVKjtzYCzjxU2TI8wh6HBUwoVcE=";

  nativeBuildInputs = [ libcosmicAppHook ];

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
