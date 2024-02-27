{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, dbus
, glib
, just
, libinput
, pkg-config
, pulseaudio
, stdenv
, udev
, util-linux
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applets";
  version = "0-unstable-2024-02-26";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "968663c6be33656a98adb871c0fdadbe200b11ff";
    hash = "sha256-G3pQCd1/UuOdtBfjMpdNKDbkEX4OJuZfrf8K6aNZS5E=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-comp-config-0.1.0" = "sha256-uUpRd8bR2TyD7Y1lpKmJTaTNv9yNsZVnr0oWDQgHD/0=";
      "cosmic-config-0.1.0" = "sha256-P7GCTYfRvqIN8CeheyTELx6fMKCTsaZCp9oEbda2jCo=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-ztZ5HD1hEOvsUSn94ZbbJ6SY9Jbsm8iGHR70GuAnEaQ=";
      "cosmic-notifications-config-0.1.0" = "sha256-hC76AYUC9Igjx5jFr1157UHVbBT5L9x2YhUslsFaBrc=";
      "cosmic-panel-config-0.1.0" = "sha256-gPQ5BsLvhnopnnGeKbUizmgk0yhEEgSD0etX9YEWc5E=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-EG0jERREWR4MBWKgFmE/t6SpTTQRXK76PPa7+/TAKOA=";
      "cosmic-time-0.4.0" = "sha256-mMTctwZdW4vlX7m7Aq682bZViObnPH8V5KsVCKDV47M=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-9NwNrEC+csTVtmXrNQFvOgohTGUO2VCvqOME7SnDCOg=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-PfuybCDLeRcVCkVxFK2T9BnL2uJz7C4EEPDZ9cWlPqk=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook just pkg-config util-linux ];
  buildInputs = [ dbus glib libinput pulseaudio udev ];

  dontUseJustBuild = true;

  justFlags = [
    "--set" "prefix" (placeholder "out")
    "--set" "target" "${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applets";
    description = "Applets for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss nyanbinary ];
    platforms = platforms.linux;
  };
}
