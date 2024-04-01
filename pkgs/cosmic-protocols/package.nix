{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-04-01";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "e4e6f8ca4d7c239c02a8cdfd48a74cb0969425eb";
    hash = "sha256-XUiyL4M3hLBoBlpuG0K71QuhM4SSUBeYGtUhD+FL6Wg=";
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
