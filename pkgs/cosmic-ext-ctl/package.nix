{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-ctl";
  version = "1.0.0-unstable-2024-12-16";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    rev = "75eda93e14a836f15cc2b7322a83d9dce2e4551e";
    hash = "sha256-j9GgvmVhU8rBCQNHx64VcPOTKQo+6Q5B71VrsDcIPUo=";
  };

  cargoHash = "sha256-iexoOLdBS8kTKWqn272RzdkD/Q38rp/7JD7isaYrK9E=";

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
