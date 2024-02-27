{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, appstream-glib
, desktop-file-utils
, intltool
, just
, pkg-config
, stdenv
, which
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-notifications";
  version = "0-unstable-2024-02-12";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-notifications";
    rev = "19f147f9ed8c46196bf6f5b5debc99a7228555fc";
    hash = "sha256-hC76AYUC9Igjx5jFr1157UHVbBT5L9x2YhUslsFaBrc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-HhtzZZmLkQpZUonL+KETNiQ+pDf3bEI3jHegUIiVzBI=";
      "cosmic-panel-config-0.1.0" = "sha256-gPQ5BsLvhnopnnGeKbUizmgk0yhEEgSD0etX9YEWc5E=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-EG0jERREWR4MBWKgFmE/t6SpTTQRXK76PPa7+/TAKOA=";
      "cosmic-time-0.4.0" = "sha256-SrhZGPE2I/FUBfwpHa0Hd5Wm/ynwwVEn+Hf1UCacEWI=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-PfuybCDLeRcVCkVxFK2T9BnL2uJz7C4EEPDZ9cWlPqk=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook just which pkg-config ];
  buildInputs = [ appstream-glib desktop-file-utils intltool ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-notifications"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-notifications";
    description = "Notifications for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
