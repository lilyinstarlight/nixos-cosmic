{ lib
, fetchFromGitHub
, stdenv
, wayland-scanner
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-09-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "d11ddc1ca3bc114de69fff77295c735c2dec1f65";
    hash = "sha256-xa0YHAIOZDivHhdOdiLqCuXA04T9ywRGZkK9KGW2A4s=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  passthru.updateScript = nix-update-script {
    # add if upstream ever makes a tag
    #extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Addtional wayland-protocols used by the COSMIC desktop environment";
    license = [ licenses.mit licenses.gpl3Only ];
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
  };
}
