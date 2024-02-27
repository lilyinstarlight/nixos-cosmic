{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, makeBinaryWrapper
, cmake
, cosmic-icons
, cosmic-randr
, expat
, fontconfig
, freetype
, just
, libinput
, libxkbcommon
, pkg-config
, udev
, util-linux
, wayland
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "0-unstable-2024-02-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "ef3fee75f0ef8fe53881780b51f831cb0a62dc5d";
    hash = "sha256-nXkK0QfpnHxwjqk3ELZ+6xRX/Uykm1eT20NWpK8lzHU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-2P2NcgDmytvBCMbG8isfZrX+JirMwAz8qjW3BhfhebI=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-comp-config-0.1.0" = "sha256-Lj24AkdLHOICHnBtrVCTKaBiySViTCxEWl4Ry8nfiXg=";
      "cosmic-config-0.1.0" = "sha256-gMn9+cmf3wT93jtnFkge9/Z0pE7MQL8PNj+RuMiBicA=";
      "cosmic-panel-config-0.1.0" = "sha256-JrBmCMa2w74+TQhmXIcrdLn9KQu2V7ifSilmKhSL9a0=";
      "cosmic-randr-shell-0.1.0" = "sha256-t1PM/uIM+lbBwgFsKnRiqPZnlb4dxZnN72MfnW0HU/0=";
      "cosmic-text-0.11.2" = "sha256-Y9i5stMYpx+iqn4y5DJm1O1+3UIGp0/fSsnNq3Zloug=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-cQ0JMfxpDdPtBF6IxgF6cCey/vxqGfXC4dPgs4u73tQ=";
    };
  };

  nativeBuildInputs = [ makeBinaryWrapper cmake just pkg-config util-linux ];
  buildInputs = [ expat fontconfig freetype libxkbcommon libinput udev wayland ];

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
    wrapProgram "$out/bin/cosmic-settings" \
      --prefix PATH : '${lib.makeBinPath [ cosmic-randr ]}' \
      --suffix XDG_DATA_DIRS : '${placeholder "out"}/share:${cosmic-icons}/share'
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
