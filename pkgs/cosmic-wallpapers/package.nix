{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-wallpapers";
  version = "0-unstable-2024-06-26";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-wallpapers";
    rev = "0f2f16dc39ff1281a56680e37719e98a1bc8cb99";
    sha256 = "sha256-t98ZDmazsPxXNXI4cNDkIo61/eKQaJg9lZa4CsfX00g=";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Wallpapers for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-wallpapers";
    license = with licenses; [
      cc-by-sa-40
      cc-by-40
      publicDomain
    ];
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.all;
  };
}
