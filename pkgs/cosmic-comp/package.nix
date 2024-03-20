{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, libinput
, mesa
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
  version = "0-unstable-2024-03-19";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "658a88da8c767527f27a006ba9422640ed6fda44";
    hash = "sha256-472RlJoaqIHvML+fQocwNEsDGy6kQyI/99gD0vxACCY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-uo4So9I/jD3LPfigyKwESUdZiK1wqm7rg9wYwyv4uKc=";
      "cosmic-protocols-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-text-0.10.0" = "sha256-S0GkKUiUsSkL1CZHXhtpQy7Mf5+6fqNuu33RRtxG3mE=";
      "glyphon-0.4.1" = "sha256-mwJXi63LTBIVFrFcywr/NeOJKfMjQaQkNl3CSdEgrZc=";
      "id_tree-1.8.0" = "sha256-uKdKHRfPGt3vagOjhnri3aYY5ar7O3rp2/ivTfM2jT0=";
      "smithay-0.3.0" = "sha256-6nhOQMsiogHt6Bw4zSSSbJXDlKTJdz+TT3yN5aKxcgU=";
      "smithay-egui-0.1.0" = "sha256-FcSoKCwYk3okwQURiQlDUcfk9m/Ne6pSblGAzHDaVHg=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ wrapCosmicAppsHook pkg-config ];
  buildInputs = [
    libinput
    mesa
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
