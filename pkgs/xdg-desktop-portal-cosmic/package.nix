{ lib
, rustPlatform
, fetchFromGitHub
, libcosmicAppHook
, pkg-config
, mesa
, pipewire
, gst_all_1
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.1-unstable-2024-09-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "05c37cd94294cf5cda812d5bc27ab83e4a46b72d";
    hash = "sha256-/Yh8GcBG1B3goOwrg4F0IlOTjIvh/gdqSy2qbyRym/c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-bg-config-0.1.0" = "sha256-lAFAZBo5FnXgJV3MrZhaYmBxqtH1E7+Huj53ho/hPik=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-3b9G5r0/F4ESoOLRADeuWmJZDCVaaVdESnOa3X3+UOo=";
      "cosmic-files-0.1.0" = "sha256-nGBBIzYFiXMfpiDsdN7mhEFB+DfHyFv3pppRioBDnew=";
      "cosmic-settings-daemon-0.1.0" = "sha256-mcunAOrjOgt6Y8me4fjpF3fZcK4jQDIpLYlPKuarQLQ=";
      "cosmic-text-0.12.1" = "sha256-3opGta6Co8l+hIQRVGkfSy6IqJXq/N8ZzqF+YGQADmI=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "fs_extra-1.3.0" = "sha256-ftg5oanoqhipPnbUsqnA4aZcyHqn9XsINJdrStIPLoE=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "libspa-0.8.0" = "sha256-R68TkFbzDFA/8Btcar+0omUErLyBMm4fsmQlCvfqR9o=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "trash-5.0.0" = "sha256-6cMo2GtMJjU+fbehlsGNmj3LbzSP+vOjA4en3OgmZ54=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ libcosmicAppHook rustPlatform.bindgenHook pkg-config ];
  buildInputs = [ mesa pipewire ];
  checkInputs = [ gst_all_1.gstreamer ];

  env.VERGEN_GIT_SHA = src.rev;

  postInstall = ''
    mkdir -p $out/share/{dbus-1/services,icons,xdg-desktop-portal/portals}
    cp -r data/icons $out/share/icons/hicolor
    cp data/*.service $out/share/dbus-1/services/
    cp data/cosmic.portal $out/share/xdg-desktop-portal/portals/
    cp data/cosmic-portals.conf $out/share/xdg-desktop-portal/
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = platforms.linux;
  };
}
