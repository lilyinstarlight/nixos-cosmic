{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  fontconfig,
  freetype,
  glib,
  gtk3,
  just,
  libinput,
  pkg-config,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-edit";
  version = "0-unstable-2024-06-13";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-edit";
    rev = "454a68f05bfb1783b8b196a8e566c406c076fd9a";
    hash = "sha256-mZZEzTm1DHf409IO6cuh7YSjmnSh6A2Abx1CND5k0zc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-G6r7cUmdom8LhIUzm3JTVry+WQzHyxUFWbQ0gry11Eo=";
      "cosmic-config-0.1.0" = "sha256-eyZ13Rh3pAexdpg4fHPlgHCeixLKRZy+m18zkOXvRoQ=";
      "cosmic-files-0.1.0" = "sha256-C4zrBwEnCxymHE1ImhDmp7PorXXgqLUutp2oHf3BrA0=";
      "cosmic-syntax-theme-0.1.0" = "sha256-BNb9wrryD5FJImboD3TTdPRIfiBqPpItqwGdT1ZiNng=";
      "cosmic-text-0.11.2" = "sha256-6gj1Br8dFmuWpGo6aBNCy4rKI7xSCYdRWqiBbI5GgyY=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-zETzANGobEnyuxagwyGQE9FfkPWBybUCZnD1R+ZWcuo=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just pkg-config ];
  buildInputs = [
    glib
    gtk3
    libinput
    fontconfig
    freetype
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-edit"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-edit";
    description = "Text Editor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
