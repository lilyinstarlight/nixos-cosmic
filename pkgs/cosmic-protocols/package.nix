{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "1316f9e1148ec65351471d8a046ffc82171b066e";
    hash = "sha256-W7egL3eR6H6FIHWpM67JgjWhD/ql+gZxaogC1O31rRI=";
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
