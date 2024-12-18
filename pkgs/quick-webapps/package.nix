{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "quick-webapps";
  version = "0.5.4-unstable-2024-12-17";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "web-apps";
    rev = "c50a16019ae70583f174b59254b5a8a94be6fee9";
    hash = "sha256-BRXw2cyen31nuue4GlMqYsroLxtPpXiAD6CS5y5jh08=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-client-toolkit-0.1.0" = "sha256-/DJ/PfqnZHB6VeRi7HXWp0Vruk+jWBe+VCLPpiJeEv4=";
      "cosmic-config-0.1.0" = "sha256-ryp8ydtTticD7/RMQCtUan1Rfc01Ds4CNS+21LppfvY=";
      "cosmic-freedesktop-icons-0.2.6" = "sha256-+WmCBP9BQx7AeGdFW2KM029vuweYKM/OzuCap5aTImw=";
      "cosmic-text-0.12.1" = "sha256-nCw3RNIHINXH4+m9wKB+0CeoXSVKKxP+ylaZhfp8u+o=";
      "dpi-0.1.1" = "sha256-whi05/2vc3s5eAJTZ9TzVfGQ/EnfPr0S4PZZmbiYio0=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/quick-webapps"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/cosmic-utils/web-apps";
    description = "Web app manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "quick-webapps";
  };
}
