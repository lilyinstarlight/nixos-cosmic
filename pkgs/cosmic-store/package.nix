{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, flatpak
, glib
, just
, openssl
, pkg-config
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-store";
  version = "0-unstable-2024-04-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-store";
    rev = "ba0d84f71abbd660bd5f0a56e99e83f64294a3fe";
    hash = "sha256-3VJ6qIFdU2C+epVRL8gaGT+w379jkM/PEjByXwPmv0M=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "appstream-0.2.2" = "sha256-OWeNXxvqU8s0ksdY9v5bZeNfDYgMBVd1DhEAjjZxEmo=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-KVcKQ4DtoZCgFBnejIaQfQxJJJxd/mFzHBI+4PbGBio=";
      "cosmic-config-0.1.0" = "sha256-KRQDUl+z0R7CT+JloKo9V8Kps+/5ygVaCL+CCwUkQIA=";
      "cosmic-text-0.11.2" = "sha256-gUIQFHPaFTmtUfgpVvsGTnw2UKIBx9gl0K67KPuynWs=";
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
    flatpak
    openssl
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-store"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-store";
    description = "App Store for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
