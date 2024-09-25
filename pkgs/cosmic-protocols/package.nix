{
  lib,
  fetchFromGitHub,
  stdenv,
  wayland-scanner,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "91aeb55052a8e6e15a7ddd53e039a9350f16fa69";
    hash = "sha256-6XM6kcM2CEGAziCkal4uO0EL1nEWOKb3rFs7hFh6r7Y=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  passthru.updateScript = nix-update-script {
    # add if upstream ever makes a tag
    #extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Addtional wayland-protocols used by the COSMIC Desktop Environment";
    license = [
      licenses.mit
      licenses.gpl3Only
    ];
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
  };
}
