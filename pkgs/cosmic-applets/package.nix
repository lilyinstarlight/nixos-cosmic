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
  version = "0-unstable-2024-03-09";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "13dedfc3c7abefb810641c221ceb288a869bea9f";
    hash = "sha256-dk/gN7Xmto+IiOHyMDN2MJAGe8+rE8tDxPDRvtB/mYc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-comp-config-0.1.0" = "sha256-uUpRd8bR2TyD7Y1lpKmJTaTNv9yNsZVnr0oWDQgHD/0=";
      "cosmic-config-0.1.0" = "sha256-fp0c8ek7GA8E6Ony2uTNjRJvmMJLGx8g1DT+WbmFjj8=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-a/cvbB0M9cUd8RP5XxgHRbJ/i/UKAEK4DTwwUU69IuY=";
      "cosmic-notifications-config-0.1.0" = "sha256-tdha/4LGJjOShXVChNf5plbboIAJWP2mwkjqHLnj5Cw=";
      "cosmic-panel-config-0.1.0" = "sha256-A6rmL3vEpJ02wVRz1WdUecMGJ0r2rxfwDcPJ2G3oQZw=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-6mvGyMCFC/tSIiDgDX+zuDUi15S9dXI6Dc6pj36hIJM=";
      "cosmic-time-0.4.0" = "sha256-mMTctwZdW4vlX7m7Aq682bZViObnPH8V5KsVCKDV47M=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-9NwNrEC+csTVtmXrNQFvOgohTGUO2VCvqOME7SnDCOg=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-cQ0JMfxpDdPtBF6IxgF6cCey/vxqGfXC4dPgs4u73tQ=";
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
    maintainers = with maintainers; [ qyliss nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
