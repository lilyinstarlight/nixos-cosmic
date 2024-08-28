{ lib
, stdenvNoCC
, fetchFromGitHub
, just
, pop-icon-theme
, hicolor-icon-theme
, nix-update-script
}:
stdenvNoCC.mkDerivation rec {
  pname = "cosmic-icons";
  version = "1.0.0-alpha.1-unstable-2024-08-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "ea9e3b8cf12bfa7112b8be8390c0185888358504";
    sha256 = "sha256-31jXaRWqzt0TSxyp6ZZ463TdX3JmNxqv0qbY38/vqww=";
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
    extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    description = "System76 Cosmic icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = with licenses; [
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ a-kenji /*lilyinstarlight*/ ];
  };
}
