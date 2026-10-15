{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "cosmic-wallpapers";
  version = "1.10.0-unstable-2026-09-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-wallpapers";
    rev = "da595bba495cb8fc57f26505621fc25000218349";
    hash = "sha256-m43hicmlMzIdMV5KjvYRi1Q0Am0V8HnbPk2zpPS4STc=";
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
