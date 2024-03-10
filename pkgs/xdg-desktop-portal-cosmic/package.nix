{ lib
, rustPlatform
, fetchFromGitHub
, wrapCosmicAppsHook
, pkg-config
, mesa
, pipewire
, gst_all_1
}:

rustPlatform.buildRustPackage {
  pname = "xdg-desktop-portal-cosmic";
  version = "0-unstable-2024-03-06";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "4ed6b15418dfa16d7867eee4ebcddc88b6aa0068";
    hash = "sha256-BlONsVYyYCSPp0ire2R763259dZuAanJYGmppn/v2Jk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-U+BF+lLd/DmZq8ISc9zHAegzv0K97g9Qq+D9qZDbyY4=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-6gBJDma3QJTH3K9cZLxHv/+Qt2iBSCIIO92WK6crrVw=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-6mvGyMCFC/tSIiDgDX+zuDUi15S9dXI6Dc6pj36hIJM=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libspa-0.8.0" = "sha256-KnNeFQPu0E4XxZVladf1fbChh0Xjhw3tN9Dqp7uy+/I=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ wrapCosmicAppsHook rustPlatform.bindgenHook pkg-config ];
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
