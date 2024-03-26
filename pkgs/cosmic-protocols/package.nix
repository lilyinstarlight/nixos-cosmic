{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-03-25";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "1cc4a1393d0f8be4d444666e260fdb811b400f49";
    hash = "sha256-mz3lzznFU+KNH3YyIc0K6shsNZx8pnK6PkU/gKXbASs=";
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
