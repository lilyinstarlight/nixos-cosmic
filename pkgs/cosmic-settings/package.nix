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
  version = "0-unstable-2024-03-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "958d9ba16449570b86d9eee15ae15683ca5a07d6";
    hash = "sha256-hZ4SDrqM86Ixey/S8q5uE/H7LyIqki3d+oqzdmkaLHw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-U+BF+lLd/DmZq8ISc9zHAegzv0K97g9Qq+D9qZDbyY4=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-comp-config-0.1.0" = "sha256-krMzz7CY47cER5kMqH/gZ+4fvkBQypvqrcRV0S4brbI=";
      "cosmic-config-0.1.0" = "sha256-6gBJDma3QJTH3K9cZLxHv/+Qt2iBSCIIO92WK6crrVw=";
      "cosmic-panel-config-0.1.0" = "sha256-YwQftpAgCMtqHe9iXFWEZXF4rgG3iTmGNNu79hmtveo=";
      "cosmic-randr-shell-0.1.0" = "sha256-t1PM/uIM+lbBwgFsKnRiqPZnlb4dxZnN72MfnW0HU/0=";
      "cosmic-text-0.11.2" = "sha256-6mvGyMCFC/tSIiDgDX+zuDUi15S9dXI6Dc6pj36hIJM=";
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
