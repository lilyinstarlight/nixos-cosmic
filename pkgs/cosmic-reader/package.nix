{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-reader";
  version = "0-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "9f62f5455d7faea844b55f3495e12b1e47bb8111";
    hash = "sha256-qgD/waojjVLRTe1aasUlwGH042tRnesplj4hSGlb+Qs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-config-0.1.0" = "sha256-5yCV99XoMg7T86k1tPdvMlxLmhI20et8q8NSaBkxU+k=";
      "cosmic-text-0.12.1" = "sha256-u2Tw+XhpIKeFg8Wgru/sjGw6GUZ2m50ZDmRBJ1IM66w=";
      "dpi-0.1.1" = "sha256-F29FkvbIgizqk+eYdXPCjSOVXmnMHZGqZh4eHVf94Cs=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  passthru.updateScript = nix-update-script {
    # TODO: uncomment when there are actual tagged releases
    #extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-reader";
    description = "PDF reader for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-reader";
  };
}
