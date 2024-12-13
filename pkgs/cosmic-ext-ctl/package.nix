{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-ctl";
  version = "0-unstable-2024-12-10";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    rev = "7e061bd587f15aeed568282a842c690f70ecc0c0";
    hash = "sha256-hM+XMXT+3TVsuIIvhM/NcEXnqF5aB33B1m14m1tsnY4=";
  };

  cargoHash = "sha256-jdx3Ep9FJ4tb6gdwgEhcRiFiZPDPHzpfPA1+379dfTc=";

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
