{
  lib,
  fetchFromGitHub,
  rustPlatform,
  wrapCosmicAppsHook,
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
  version = "0-unstable-2024-04-30";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-edit";
    rev = "695b82a53d91ad11ff8897a882999decd841484c";
    hash = "sha256-SiTXW/GsVj8OE2aU8jrD+daoWMhSJigpe8hnP+jF5BY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-KVcKQ4DtoZCgFBnejIaQfQxJJJxd/mFzHBI+4PbGBio=";
      "cosmic-config-0.1.0" = "sha256-WXjXxd/P++eDC3OkzEH9Pcs3Jn8gA4OQsuYHSoyuQ5M=";
      "cosmic-files-0.1.0" = "sha256-kv3tq6CI+c3GYAF0G2+fcjAgdW4fVy1F6SXxNy48aWk=";
      "cosmic-syntax-theme-0.1.0" = "sha256-BNb9wrryD5FJImboD3TTdPRIfiBqPpItqwGdT1ZiNng=";
      "cosmic-text-0.11.2" = "sha256-3F3xFhLit8i3/spWh/jEQ5LTa+E534dc3WGp5ytBCag=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-LDd56TJ175qsj2/EV/dbBRV9HMU7RzgrG5JP7H2PmhE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook just pkg-config ];
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
