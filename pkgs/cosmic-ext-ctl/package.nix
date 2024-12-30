{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-ctl";
  version = "1.1.0-unstable-2024-12-29";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    rev = "4f088445f468134bd94155195cc251c0462b7622";
    hash = "sha256-avPr6OV1T8Pyr02ycnpWpyScmb/6q9LmrRuV+KeHf4g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EReo2hkBaIO1YOBx4D9rQSXlx+3NK5VQtj59jfZZI/0=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "CLI for COSMIC Desktop Environment configuration management";
    homepage = "https://github.com/cosmic-utils/cosmic-ctl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-ctl";
  };
}
