{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
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
  version = "0-unstable-2024-07-02";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applets";
    rev = "a0145bf106fb5b2dc2170ebf98aad68dc02ec0a5";
    hash = "sha256-viDJaf/dxJJvQjU9C5csFf4KolM0WqW6L3+swPDtMv0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-G6r7cUmdom8LhIUzm3JTVry+WQzHyxUFWbQ0gry11Eo=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-uUpRd8bR2TyD7Y1lpKmJTaTNv9yNsZVnr0oWDQgHD/0=";
      "cosmic-config-0.1.0" = "sha256-MJZhd/Y6BZ7FtRdD00F2hCUsmFbO8liB+c00oq6nojw=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-LU06/xPKfOxlLgOJIOz5iQuoMspH3ddD1wHNylO+380=";
      "cosmic-notifications-config-0.1.0" = "sha256-+vPfNW82+WNmymOCi5upOcvlrx1xpCm7HtIZM7GkT2k=";
      "cosmic-panel-config-0.1.0" = "sha256-ApHMmaanq6pv+rrIlJ6z0gY0kMul7D99FB3H59C8AUk=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-A2ZVaTeQ5rwNI3r48cVtC5s7fhnK84rD+p+gaB42MaQ=";
      "cosmic-text-0.11.2" = "sha256-6gj1Br8dFmuWpGo6aBNCy4rKI7xSCYdRWqiBbI5GgyY=";
      "cosmic-time-0.4.0" = "sha256-qOxfyQ2r3yD6i/rgm22oNuOWslBgWrVh9zw3/qLIDT0=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-OjFcBzVE/fpHTK9bHxcHocEa16q6i9mVRNfJ9lLa/cw=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just pkg-config util-linux ];
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
