{ lib
, stdenvNoCC
, fetchFromGitHub
, just
, pop-icon-theme
, hicolor-icon-theme
, nix-update-script
}:
stdenvNoCC.mkDerivation {
  pname = "cosmic-icons";
  version = "1.0.0-alpha.1-unstable-2024-09-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-icons";
    rev = "fe691ea937813242041e5e4c7383a7c9c8b5e83c";
    sha256 = "sha256-hXtsygbi6s1K3CUXmoSL72ik8CSOxivASYRyTqXgccs=";
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
    description = "System76 COSMIC icon theme for Linux";
    homepage = "https://github.com/pop-os/cosmic-icons";
    license = with licenses; [
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ a-kenji /*lilyinstarlight*/ ];
  };
}
