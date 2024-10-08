{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  libinput,
  mesa,
  pixman,
  pkg-config,
  seatd,
  stdenv,
  udev,
  xwayland,
  useXWayland ? true,
  systemd,
  useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-comp";
  version = "1.0.0-alpha.2-unstable-2024-10-07";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "07bd8bedef325b266920070ef8fee1f6dd4898ed";
    hash = "sha256-FrYyD03k5+7kpYJbJwzOASqxAkvSFROmjnphVBdMGR4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-MZLjSIhPz+cpaSHA1R1S+9FD60ys+tHaJ+2Cz+2B/uE=";
      "cosmic-protocols-0.1.0" = "sha256-6XM6kcM2CEGAziCkal4uO0EL1nEWOKb3rFs7hFh6r7Y=";
      "cosmic-settings-config-0.1.0" = "sha256-j4tAclYoenNM+iBwk8iHOj4baIXc4wkclPl5RZsADGI=";
      "cosmic-text-0.12.1" = "sha256-3opGta6Co8l+hIQRVGkfSy6IqJXq/N8ZzqF+YGQADmI=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "iced-0.12.0" = "sha256-1RSl5Zd6pkSdAD0zkjL8mzgBbCuc0AE564uI8zrNCyc=";
      "id_tree-1.8.0" = "sha256-uKdKHRfPGt3vagOjhnri3aYY5ar7O3rp2/ivTfM2jT0=";
      "smithay-0.3.0" = "sha256-I6XXB5Kort09440dbXQ0+2F4U3ulq1c9x3od+gQ6Chs=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "smithay-egui-0.1.0" = "sha256-wcBd0ZbGsxKtro2VqurEJwLBX5/QldrQoCzGlSbPcbs=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];
  buildInputs = [
    libinput
    mesa
    pixman
    seatd
    udev
  ] ++ lib.optional useSystemd systemd;

  # only default feature is systemd
  buildNoDefaultFeatures = !useSystemd;

  postInstall =
    ''
      mkdir -p $out/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1
      cp data/keybindings.ron $out/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/defaults
    ''
    + lib.optionalString useXWayland ''
      libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ xwayland ]})
    '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-comp";
  };
}
