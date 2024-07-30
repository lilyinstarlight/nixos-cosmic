{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-07-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "bd65e0f2d55429954839c9e6c7bc5b0d198b85f0";
    hash = "sha256-zWuvZrg39REZpviQPfLNyfmWBzMS7A7IBUTi8ZRhxXs=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Addtional wayland-protocols used by the COSMIC desktop environment";
    license = [ licenses.mit licenses.gpl3Only ];
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
  };
}
