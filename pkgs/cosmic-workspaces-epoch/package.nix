{ lib
, rustPlatform
, fetchFromGitHub
, wrapCosmicAppsHook
, pkg-config
, libinput
, mesa
, udev
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-workspaces-epoch";
  version = "0-unstable-2024-03-01";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "ab4cfd5bc5571b20c1787ce05455ce7a9c894b48";
    hash = "sha256-5eCXWTTzcfo5wKVFdW+WuBhTrB17WODS3GctRwwgLyE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-comp-config-0.1.0" = "sha256-nlPhCPO3AC1+X+Nmw/W5qlE29Ld5E/4Hyh8ysZJ464E=";
      "cosmic-config-0.1.0" = "sha256-C4t/DT3EWlb84c+E5hKq/WdqG0kYraBX+BPAWQOhTjI=";
      "cosmic-text-0.11.2" = "sha256-S53HQoK2ZzsP4953BYg7YlyNaM4Uvc2K0asEgfgYfb4=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook pkg-config ];
  buildInputs = [ libinput mesa udev ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
