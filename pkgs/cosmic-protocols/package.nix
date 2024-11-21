{
  lib,
  fetchFromGitHub,
  stdenv,
  wayland-scanner,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "cosmic-protocols";
  version = "0-unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-protocols";
    rev = "27d70b6eb9c785a2a48341016f32a7b1ac4980ac";
    hash = "sha256-U1Lcxb6AovekR3vJfoj5B4qZEASba7RfdMcUckt5Hb0=";
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
