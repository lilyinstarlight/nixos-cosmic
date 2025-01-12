{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-ctl";
  version = "1.1.0-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    rev = "35145e808f3d7e895057befde75c87c3f70516cd";
    hash = "sha256-0fGt9S9U6eOZflc6kzixQFiTC96vZtauQ9tQJhdYoFc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EReo2hkBaIO1YOBx4D9rQSXlx+3NK5VQtj59jfZZI/0=";

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
