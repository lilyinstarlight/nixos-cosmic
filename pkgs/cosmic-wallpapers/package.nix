{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-wallpapers";
  version = "epoch-1.0.0-alpha.2-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-wallpapers";
    rev = "8d1d23ab64c52ad57f09c1e5e79585cc97dd4eea";
    sha256 = "sha256-sk85k2Lra06CIerGNC/rHzJsgzNfjB4JaJ+WNoqzP48=";
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
