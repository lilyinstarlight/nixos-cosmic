{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, just
, pkg-config
, stdenv
, util-linux
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-panel";
  version = "0-unstable-2024-03-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "3aad7907ee6b5506cf800c2a838176bacfcfa8ad";
    sha256 = "sha256-s/ORB1/GpnU1r+9miQRhBMSuLo4w69Uw3P6qFHNycOg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-HFiDKyo93Sz9DLxCd9Yt4+iW1U36Nu0HhIcnv3q3Ers=";
      "cosmic-notifications-util-0.1.0" = "sha256-tdha/4LGJjOShXVChNf5plbboIAJWP2mwkjqHLnj5Cw=";
      "launch-pad-0.1.0" = "sha256-tnbSJ/GP9GTnLnikJmvb9XrJSgnUnWjadABHF43L1zc=";
      "smithay-0.3.0" = "sha256-OI+wtDeJ/2bJyiTxL+F53j1CWnZ0aH7XjUmM6oN45Ow=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "xdg-shell-wrapper-0.1.0" = "sha256-cQ0JMfxpDdPtBF6IxgF6cCey/vxqGfXC4dPgs4u73tQ=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook just pkg-config util-linux ];

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
