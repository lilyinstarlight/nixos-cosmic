{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-wallpapers";
  version = "1.8.0-unstable-2026-08-21";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-wallpapers";
    rev = "d6c60281508ef6b20db712612dad256d0b44b4fb";
    hash = "sha256-lCgWRtvaso9jKo7A4VepDFK/zc8pQpR1up8yoWS/qfc=";
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
