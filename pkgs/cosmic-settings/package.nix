{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  cmake,
  cosmic-randr,
  expat,
  fontconfig,
  freetype,
  just,
  libinput,
  pipewire,
  pkg-config,
  pulseaudio,
  udev,
  util-linux,
  xkeyboard_config,
  nix-update-script,
}:

let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override {
    includeSettings = false;
  };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "1.0.0-alpha.2-unstable-2024-10-24";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "3d01bda87e2cecd5648329e54df979843dff1224";
    hash = "sha256-Nb2X7meA8qZMiQICUxFZyoLXQu1T1I4xY9905pdiRXo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "bluez-zbus-0.1.0" = "sha256-mklNPKVMO6iFrxki2DwiL5K78KiWpGxksisYldaASIE=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-bg-config-0.1.0" = "sha256-bmcMZIURozlptsR4si62NTmexqaCX1Yj5bYj49GDehQ=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-EJUqH0CaMLj3ZApsIbPrBi60t5o/Fcd0FWNlnNvQ61A=";
      "cosmic-config-0.1.0" = "sha256-9nMRtCbYG+ftN3o86t38cS1UkzZPk5Fqb1s23WgJ/2s=";
      "cosmic-panel-config-0.1.0" = "sha256-sIJSD/clSqF7H/jEl7XzXn7qpzpI5ez9xM3ApiXFNqw=";
      "cosmic-protocols-0.1.0" = "sha256-zWuvZrg39REZpviQPfLNyfmWBzMS7A7IBUTi8ZRhxXs=";
      "cosmic-randr-0.1.0" = "sha256-qLobKI6+rclkGSBLz4XlHYQY+P/AZZDEsJY1Tns5Y3s=";
      "cosmic-settings-config-0.1.0" = "sha256-QnRicNbKKAjq12hPE6QbtyH0rV33H3RPHdISYjHX7yw=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-fCWGXR+Ky5W/D46OvZX7VyrmOjlxliZCHgsvPS6MgXY=";
      "cosmic-text-0.12.1" = "sha256-u2Tw+XhpIKeFg8Wgru/sjGw6GUZ2m50ZDmRBJ1IM66w=";
      "dpi-0.1.1" = "sha256-F29FkvbIgizqk+eYdXPCjSOVXmnMHZGqZh4eHVf94Cs=";
      "fast_image_resize-5.0.0" = "sha256-EQBjJlPfoPEFqEYf840jAUfHsGABbsGlGgJ+qwv68Ds=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook'
    rustPlatform.bindgenHook
    cmake
    just
    pkg-config
    util-linux
  ];
  buildInputs = [
    expat
    fontconfig
    freetype
    libinput
    pipewire
    pulseaudio
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-settings"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ cosmic-randr ]})
    libcosmicAppWrapperArgs+=(--set X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
