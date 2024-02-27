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
  version = "0-unstable-2024-02-16";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "7e81c9c4c6406ed5da2e3116adbbbdca9ae4958f";
    hash = "sha256-8AKf+QaRBWsyxvA+D+tJgDYyG6HZt7qSUjdqdmYQhDA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-comp-config-0.1.0" = "sha256-zXxeSc2wkdXKJjWhMPvTU9+IPg23y0vzBRmQ8jx6HXw=";
      "cosmic-config-0.1.0" = "sha256-ETNVJ4y7EraAlU9XEZGNNPdyWt1WIURr1dSH6hQ0Pos=";
      "cosmic-text-0.11.1" = "sha256-lyBl0VAzcKBqLeCPrA28VW6O0MWXazJg1b11YuBR65U=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-CACVCnyFgefkpDlll6IeaPWB8a3gbF6BW8MnlkytV8o=";
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
