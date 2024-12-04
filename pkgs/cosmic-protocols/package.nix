{
  lib,
  fetchFromGitHub,
  stdenv,
  wayland-scanner,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-11-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "d218c76b58c7a3b20dd5e7943f93fc306a1b81b8";
    hash = "sha256-/DJ/PfqnZHB6VeRi7HXWp0Vruk+jWBe+VCLPpiJeEv4=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ wayland-scanner ];

  passthru.updateScript = nix-update-script {
    # add if upstream ever makes a tag
    #extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-protocols";
    description = "Addtional wayland-protocols used by the COSMIC Desktop Environment";
    license = [
      licenses.mit
      licenses.gpl3Only
    ];
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
  };
}
