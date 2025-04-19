{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-ctl";
  version = "1.4.0-unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    rev = "9cf20a15e3784eecca4b37927f164e476fdf26cf";
    hash = "sha256-4UbmzBKxJwpyzucPRguQV1078961goiQlhtDjOGz1kA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-53lpHzHQ6SoZzd+h6O0NvSJHsPgbW0/kqnDrM5D6SWQ=";

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
