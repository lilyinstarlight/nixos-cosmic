{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
, nix-update-script
}:

stdenv.mkDerivation {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-09-05";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "e7e15cb87c3a6babf20e0399703a7d41edce7b0d";
    hash = "sha256-MS1ekS+Bk1dQ84HzNYZxqL0uuj21mZtvXghJ8D01uqw=";
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
    license = [ licenses.mit licenses.gpl3Only ];
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
  };
}
