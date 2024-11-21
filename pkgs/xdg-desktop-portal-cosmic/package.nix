{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  mesa,
  pipewire,
  gst_all_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "xdg-desktop-portal-cosmic";
  version = "1.0.0-alpha.3-unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "xdg-desktop-portal-cosmic";
    rev = "29f0c058b0151868193ef5d48657008aa8df30dc";
    hash = "sha256-xWfHAyHG9Rn3RKBRhOrZc2h1VbFWXgDFBQqMFvcQmH8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-bg-config-0.1.0" = "sha256-bmcMZIURozlptsR4si62NTmexqaCX1Yj5bYj49GDehQ=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-6tbFkwbqHgEnW0yFg1tVEY6SoITGPk2DbFnZCUGEgrM=";
      "cosmic-files-0.1.0" = "sha256-0sMUns9F/CcMLzzF9fRtulmYXQTYG0HzDABsRxLH6pM=";
      "cosmic-settings-daemon-0.1.0" = "sha256-TRXYsnodKjKacc2eVndviEPpma/NNOWstG+ipGcQ0s4=";
      "cosmic-text-0.12.1" = "sha256-nCw3RNIHINXH4+m9wKB+0CeoXSVKKxP+ylaZhfp8u+o=";
      "dpi-0.1.1" = "sha256-whi05/2vc3s5eAJTZ9TzVfGQ/EnfPr0S4PZZmbiYio0=";
      "fs_extra-1.3.0" = "sha256-ftg5oanoqhipPnbUsqnA4aZcyHqn9XsINJdrStIPLoE=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "libspa-0.8.0" = "sha256-kp5x5QhmgEqCrt7xDRfMFGoTK5IXOuvW2yOW02B8Ftk=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "trash-5.1.1" = "sha256-So8rQ8gLF5o79Az396/CQY/veNo4ticxYpYZPfMJyjQ=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    pkg-config
  ];
  buildInputs = [
    mesa
    pipewire
  ];
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
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/xdg-desktop-portal-cosmic";
    description = "XDG Desktop Portal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    mainProgram = "xdg-desktop-portal-cosmic";
    platforms = platforms.linux;
  };
}
