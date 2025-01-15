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
  version = "1.0.0-alpha.5.1-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-icons";
    rev = "52ad55cba5272630f345e14bee69c9fbe7aa98c4";
    hash = "sha256-j5H2+BOWxq2jShN15QCvj9rY6OK+vlUbyR9R07Ka2rA=";
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
    license = with lib.licenses; [ cc-by-sa-40 ];
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.all;
  };
}
