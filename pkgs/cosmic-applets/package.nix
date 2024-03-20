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
  version = "0-unstable-2024-03-19";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "730fa3bae8aeb4188461d09d8ab0035b0decb83b";
    hash = "sha256-IYVvghdt5rA+lIHQIfG50qQKTq9sn0rYQrWJyZcTVIs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-PEH+aCpjDCEIj8s39nIeWxb7qu3u9IfriGqf0pYObMk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-comp-config-0.1.0" = "sha256-uUpRd8bR2TyD7Y1lpKmJTaTNv9yNsZVnr0oWDQgHD/0=";
      "cosmic-config-0.1.0" = "sha256-x/xWMR5w2oEbghTSa8iCi24DA2s99+tcnga8K6jS6HQ=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-a/cvbB0M9cUd8RP5XxgHRbJ/i/UKAEK4DTwwUU69IuY=";
      "cosmic-notifications-config-0.1.0" = "sha256-tdha/4LGJjOShXVChNf5plbboIAJWP2mwkjqHLnj5Cw=";
      "cosmic-panel-config-0.1.0" = "sha256-s/ORB1/GpnU1r+9miQRhBMSuLo4w69Uw3P6qFHNycOg=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-K9cZeClr1zz4LanJS0WPEpxAplQrXfCjFKrSn5n4rDA=";
      "cosmic-time-0.4.0" = "sha256-wsvdoQ5FVCR/UF63YiSVFCQU/LXJjD0/9B8frtv2xFM=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-9NwNrEC+csTVtmXrNQFvOgohTGUO2VCvqOME7SnDCOg=";
      "smithay-clipboard-0.8.0" = "sha256-OZOGbdzkgRIeDFrAENXE7g62eQTs60Je6lYVr0WudlE=";
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
