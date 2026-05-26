{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  just,
  pop-icon-theme,
  hicolor-icon-theme,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-icons";
  version = "1.0.14-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-icons";
    rev = "2c697e8e97cfd619107a872b28c31317281184ff";
    hash = "sha256-3owl4M4vRyzjR4v74clyAxpNDu77rieSpYAVYfADHzY=";
  };

  nativeBuildInputs = [ just ];

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  propagatedBuildInputs = [
    pop-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    description = "System76 COSMIC icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = lib.licenses.cc-by-sa-40;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.all;
  };
}
