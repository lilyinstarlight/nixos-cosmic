{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-07-02";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "22e9009c48b00e5052bc88979f60b48728a1d143";
    hash = "sha256-axY3vLSMNRiXaWeF12kl8kBm7M5ncxNqA8yoDKqyT0c=";
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
