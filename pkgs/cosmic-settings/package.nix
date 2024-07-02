{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, cmake
, cosmic-randr
, expat
, fontconfig
, freetype
, just
, libinput
, pkg-config
, udev
, util-linux
}:

let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override { includeSettings = false; };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "0-unstable-2024-07-01";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "1f49b9f61ad9916f9b448c64d1f152f3354ba7a4";
    hash = "sha256-EX1b8sgmdeZg6GH6/cOWOAN7SlcXZOkRcXJ7gvhzLtI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-bg-config-0.1.0" = "sha256-APGtCqImDQnLy8aEIPXPiAWTOxlzmtdAdsVhLLN23Zs=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-comp-config-0.1.0" = "sha256-BSsxplD5y3kCJ+lOUqzYHDPALzvNr8gx2GnpplHGPok=";
      "cosmic-config-0.1.0" = "sha256-GIkgePHgD5kfDdGSpj40C1fI0KhXohXts+24xWb3RHc=";
      "cosmic-panel-config-0.1.0" = "sha256-ALnSJtTp9vtkoM0t7zopOa+twRCCFUqgW9kVqShYhIE=";
      "cosmic-protocols-0.1.0" = "sha256-W7egL3eR6H6FIHWpM67JgjWhD/ql+gZxaogC1O31rRI=";
      "cosmic-randr-0.1.0" = "sha256-cQLTL17/k4uyxhnuJiAChp7ad4RGKwW8fgj77EyCbIA=";
      "cosmic-settings-config-0.1.0" = "sha256-uvZv98/lBY9YaCMr0pr8yypO670+akfUPOka21w7GO8=";
      "cosmic-settings-daemon-0.1.0" = "sha256-LU06/xPKfOxlLgOJIOz5iQuoMspH3ddD1wHNylO+380=";
      "cosmic-text-0.12.0" = "sha256-x7UMzlzYkWySFgSQTO1rRn+pyPG9tXKpJ7gzx/wpm8U=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
      "xdg-shell-wrapper-config-0.1.0" = "sha256-OjFcBzVE/fpHTK9bHxcHocEa16q6i9mVRNfJ9lLa/cw=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook' cmake just pkg-config util-linux ];
  buildInputs = [ expat fontconfig freetype libinput udev ];

  dontUseJustBuild = true;

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
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
