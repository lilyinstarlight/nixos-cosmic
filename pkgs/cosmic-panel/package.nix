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
  version = "0-unstable-2024-07-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    rev = "3d0802185bacf5e0dbb8eeb0c16b872b5f9cbb8e";
    sha256 = "sha256-yOf9xCaeHLiyi3AgOQ0tlQ+bgKgdmKK2HVyRutKM1So=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-LRP3NU2V1Qzrs+SQh1iYUFAg5BbTPwb9HvWnsO5d51Y=";
      "cosmic-notifications-util-0.1.0" = "sha256-VdJ6W8+g2492wAr1kDLo2zWZGc01gHp2dvLVtj/xArE=";
      "cosmic-text-0.12.0" = "sha256-VUUCcW5XnkmCB8cQ5t2xT70wVD5WKXEOPNgNd2xod2A=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "launch-pad-0.1.0" = "sha256-c+uawTQlg5SW8x7DOBG2Idv/AfIaCFNtLQLUz8ifT2I=";
      "smithay-0.3.0" = "sha256-Ir12itaCX1zDb6QzuBh9ve09KGLxxiiiW/sP4bxlx8w=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
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
    maintainers = with maintainers; [ qyliss nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
  };
}
