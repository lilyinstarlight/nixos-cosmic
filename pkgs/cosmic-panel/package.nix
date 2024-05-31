{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, just
, stdenv
, util-linux
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "0-unstable-2024-05-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "568f3392d3b50e4e8fb5f87064a3baa91e96e231";
    sha256 = "sha256-k+gD2vYm7DA/JMpD24P8rDROvSB6gNcntx9FUL8tVrQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-seGqRDy37n0SNiJplXNbU1f6jlP4JuskeKvdUS2Z7WQ=";
      "cosmic-notifications-util-0.1.0" = "sha256-58VLKqEum223i8Sfwjaz+R2SAc9NjT65Mx2ihDhkQM8=";
      "launch-pad-0.1.0" = "sha256-tnbSJ/GP9GTnLnikJmvb9XrJSgnUnWjadABHF43L1zc=";
      "smithay-0.3.0" = "sha256-tScCvnZ+rpfloO0HsLHWL50MfRrGo8/YQt/u1OYZdws=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "xdg-shell-wrapper-0.1.0" = "sha256-OjFcBzVE/fpHTK9bHxcHocEa16q6i9mVRNfJ9lLa/cw=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just util-linux ];

  dontUseJustBuild = true;

  justFlags = [
    "--set" "prefix" (placeholder "out")
    "--set" "bin-src" "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-panel"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
