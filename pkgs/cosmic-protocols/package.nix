{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "f16efccaffdbe60b81d1a500be6e81851dc1dad4";
    hash = "sha256-YLaC59g5VI0R1IohE+T2Drah8eCzGXReOMarY+3m6Ok=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Addtional wayland-protocols used by the COSMIC desktop environment";
    license = [ licenses.mit licenses.gpl3Only ];
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
