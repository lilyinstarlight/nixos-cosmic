{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, libinput
, mesa
, pixman
, pkg-config
, seatd
, stdenv
, udev
, xwayland
, useXWayland ? true
, systemd
, useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-comp";
  version = "0-unstable-2024-05-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "dfb3bea595425201cc00643e60f2827ffd33ac61";
    hash = "sha256-zYIPnqoDGZGqqWEG3VL3tph17bxYExjMbZ6yIfs5xxo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-PEH+aCpjDCEIj8s39nIeWxb7qu3u9IfriGqf0pYObMk=";
      "cosmic-config-0.1.0" = "sha256-LZX7H+znH0GEV1OjHgTUluNgnuMk5zq8JkzCbSjRzM4=";
      "cosmic-protocols-0.1.0" = "sha256-W7egL3eR6H6FIHWpM67JgjWhD/ql+gZxaogC1O31rRI=";
      "cosmic-text-0.11.2" = "sha256-gUIQFHPaFTmtUfgpVvsGTnw2UKIBx9gl0K67KPuynWs=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "id_tree-1.8.0" = "sha256-uKdKHRfPGt3vagOjhnri3aYY5ar7O3rp2/ivTfM2jT0=";
      "smithay-0.3.0" = "sha256-nwiN6o1kw68rfK6mKxm5fuWxznn4nI/VNOF4ifbUD90=";
      "smithay-clipboard-0.8.0" = "sha256-OZOGbdzkgRIeDFrAENXE7g62eQTs60Je6lYVr0WudlE=";
      "smithay-egui-0.1.0" = "sha256-FcSoKCwYk3okwQURiQlDUcfk9m/Ne6pSblGAzHDaVHg=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ wrapCosmicAppsHook pkg-config ];
  buildInputs = [
    libinput
    mesa
    pixman
    seatd
    udev
  ] ++ lib.optional useSystemd systemd;

  # only default feature is systemd
  buildNoDefaultFeatures = !useSystemd;

  postInstall = ''
    mkdir -p $out/etc/cosmic-comp
    cp config.ron $out/etc/cosmic-comp/config.ron
  '' + lib.optionalString useXWayland ''
    cosmicAppsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ xwayland ]})
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qyliss nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
