{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-wallpapers";
  version = "1.0.0-alpha.4-unstable-2024-10-31";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-wallpapers";
    rev = "cb8e6d653b5062e046e83b4670c3d9944fa39c39";
    hash = "sha256-Exrps3DicL/G/g0kbSsCvoFhiJn1k3v8I09GhW7EwNM=";
    forceFetchGit = true;
    fetchLFS = true;
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    description = "Wallpapers for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-wallpapers";
    license = with licenses; [
      cc-by-40
      publicDomain
    ];
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.all;
  };
}
