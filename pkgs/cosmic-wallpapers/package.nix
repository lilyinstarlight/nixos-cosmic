{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-wallpapers";
  version = "1.0.14-unstable-2026-02-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-wallpapers";
    rev = "3c59953e7ee5792efecdb232cb4c7211e7785f52";
    hash = "sha256-m2cYppfitpBDKK8CC9i/lUrC9rfSYTuqUSZSyIKKGyg=";
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

  meta = {
    description = "Wallpapers for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-wallpapers";
    license = with lib.licenses; [
      cc-by-40
      publicDomain
    ];
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.all;
  };
}
