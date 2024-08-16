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
  version = "1.0.0-alpha.1-unstable-2024-08-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "33c43d7bc5b5866cccd5537bf1c93f28a9606c01";
    sha256 = "sha256-uDfbuevd2syDkXv54vvdh6B9Ca60yifQzNt6kxf/fNc=";
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
