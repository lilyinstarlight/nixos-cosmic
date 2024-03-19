{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, cmake
, cosmic-randr
, expat
, fontconfig
, freetype
, just
, libinput
, pkg-config
, udev
, util-linux
}:

let
  wrapCosmicAppsHook' = (wrapCosmicAppsHook.__spliced.buildHost or wrapCosmicAppsHook).override { includeSettings = false; };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "0-unstable-2024-03-19";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "0839361e1203f3f7dee8d66ff5849d6219e7fdd6";
    hash = "sha256-2UlVxhqjZnzmHef/NzRU+1PjWjQtsODwdbWPnd7PfjQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-PEH+aCpjDCEIj8s39nIeWxb7qu3u9IfriGqf0pYObMk=";
      "cosmic-bg-config-0.1.0" = "sha256-yFyrMakBlFgSwqTmVzPoCL0QmhIlfXhv7r4MtBnD2No=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-comp-config-0.1.0" = "sha256-472RlJoaqIHvML+fQocwNEsDGy6kQyI/99gD0vxACCY=";
      "cosmic-config-0.1.0" = "sha256-SBjW6gkoxLa+r6+65doPxIG5jwNQSJQIvdok2/WO9Vk=";
      "cosmic-panel-config-0.1.0" = "sha256-s/ORB1/GpnU1r+9miQRhBMSuLo4w69Uw3P6qFHNycOg=";
      "cosmic-randr-shell-0.1.0" = "sha256-t1PM/uIM+lbBwgFsKnRiqPZnlb4dxZnN72MfnW0HU/0=";
      "cosmic-text-0.11.2" = "sha256-K9cZeClr1zz4LanJS0WPEpxAplQrXfCjFKrSn5n4rDA=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "smithay-clipboard-0.8.0" = "sha256-OZOGbdzkgRIeDFrAENXE7g62eQTs60Je6lYVr0WudlE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-cQ0JMfxpDdPtBF6IxgF6cCey/vxqGfXC4dPgs4u73tQ=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook' cmake just pkg-config util-linux ];
  buildInputs = [ expat fontconfig freetype libinput udev ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-settings"
  ];

  postInstall = ''
    cosmicAppsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ cosmic-randr ]})
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
