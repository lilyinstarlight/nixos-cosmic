{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applibrary";
  version = "1.0.0-alpha.5-unstable-2025-01-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    rev = "fa5d843881610ac95da3195e2ab8fe31c927abb0";
    hash = "sha256-z5ZHTOCRv24Z65aTHnjZ8CqR49w2z5HZxTI0Opg1vXs=";
  };

  patches = [
    ./fix-cargo-lock-hell.patch
  ];

  # TODO: use fetchCargoVendor once cargo lock does not need patching
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-app-list-config-0.1.0" = "sha256-SRc92FCbfKUoYy67s9QSvoylTzo1wkyB4xKornmGZPk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-/DJ/PfqnZHB6VeRi7HXWp0Vruk+jWBe+VCLPpiJeEv4=";
      "cosmic-config-0.1.0" = "sha256-7CKtRpQKYyUwANz5OMkfqDkfbGP4y0pSjvWBngby+yI=";
      "cosmic-freedesktop-icons-0.2.6" = "sha256-+WmCBP9BQx7AeGdFW2KM029vuweYKM/OzuCap5aTImw=";
      "cosmic-panel-config-0.1.0" = "sha256-G9kpEaA0B4RjMPmca5EuL9ZdyUaWtw4IqHRKHwjJPB8=";
      "cosmic-settings-daemon-0.1.0" = "sha256-9Pq5WFBeIRvP2VZaa3BzoqiQmzN6taa20u7k+2aF3v0=";
      "cosmic-text-0.12.1" = "sha256-+litEIoCWfwt/+wqRCtWuGr5DHAuDFV/naHnADNLbQI=";
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
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
