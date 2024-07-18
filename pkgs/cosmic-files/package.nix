{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, stdenv
, glib
, just
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-files";
  version = "0-unstable-2024-06-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    rev = "3fef386fd3447191fcffe8da6e1d2125fe2b0a27";
    hash = "sha256-QDkHhU0zE0szFwGuVuSYrXd7AUdTU1rYxlAsaHr2YvQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-G6r7cUmdom8LhIUzm3JTVry+WQzHyxUFWbQ0gry11Eo=";
      "cosmic-config-0.1.0" = "sha256-ysHGRqPRODCLzUfblkf3lFhsEVa/mqrBXuKt+CtGZ9c=";
      "cosmic-text-0.11.2" = "sha256-6gj1Br8dFmuWpGo6aBNCy4rKI7xSCYdRWqiBbI5GgyY=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just ];
  buildInputs = [ glib ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  # TODO: remove when <https://github.com/pop-os/cosmic-files/pull/103#issuecomment-2051661109> is fixed
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
  };
}
