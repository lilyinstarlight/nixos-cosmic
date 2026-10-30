{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-ctl";
  version = "1.6.0-unstable-2026-10-14";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    rev = "6d1e5b0d2e9474e036c85f451253e5384f3dd0cd";
    hash = "sha256-v3lNcXvSbTtCCosPD0z5ubksrBF9b0ATWfmLfF6MzvI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lRBkcn4Vy7XGRpymT3KCeHWwR3hXK5LxTDZB+Kiuk7E=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for COSMIC Desktop Environment configuration management";
    homepage = "https://github.com/cosmic-utils/cosmic-ctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ctl";
  };
}
