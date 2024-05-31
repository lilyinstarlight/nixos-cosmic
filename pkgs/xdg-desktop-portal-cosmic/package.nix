{ lib
, rustPlatform
, fetchFromGitHub
, libcosmicAppHook
, pkg-config
, mesa
, pipewire
, gst_all_1
}:

rustPlatform.buildRustPackage {
  pname = "xdg-desktop-portal-cosmic";
  version = "0-unstable-2024-05-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "5f38044f15656fb946c146b03f479d0931a093e0";
    hash = "sha256-y9QGdEcXk8PNssjKTUzu30znLwkbKDR/1OlbiSXMUC0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-bg-config-0.1.0" = "sha256-OYJ6RfWuo9kcrdE3z2gKyVyhmxJeWqigQ37AgS8W0Mc=";
      "cosmic-client-toolkit-0.1.0" = "sha256-XUiyL4M3hLBoBlpuG0K71QuhM4SSUBeYGtUhD+FL6Wg=";
      "cosmic-config-0.1.0" = "sha256-xo/ZZrkdks8c4V9En92OvNCBsJEzv0Iy3ZTZsEahrPE=";
      "cosmic-settings-daemon-0.1.0" = "sha256-Bz/bzXCm60AF0inpZJDF4iNZIX3FssImORrE5nZpkyQ=";
      "cosmic-text-0.11.2" = "sha256-Jpgbg1DScteec7ItcGgbQYXu1bBNYJEw1SGsxpcxYfM=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libspa-0.8.0" = "sha256-OGV96Mhg1R9XEE5Fag8hY0HbGuLFjuN2YZcktcjOfdc=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ libcosmicAppHook rustPlatform.bindgenHook pkg-config ];
  buildInputs = [ mesa pipewire ];
  checkInputs = [ gst_all_1.gstreamer ];

  postInstall = ''
    mkdir -p $out/share/{dbus-1/services,xdg-desktop-portal/portals}
    cp data/*.service $out/share/dbus-1/services/
    cp data/cosmic.portal $out/share/xdg-desktop-portal/portals/
    cp data/cosmic-portals.conf $out/share/xdg-desktop-portal/
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = platforms.linux;
  };
}
