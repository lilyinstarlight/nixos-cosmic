{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "chronos";
  version = "0.1.4-unstable-2024-11-11";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "chronos";
    rev = "b0c7cf581644cacfb50483164f5f66f8f8e21aa4";
    hash = "sha256-lmtILgKlGSwHBVLRJ35DOCZVfGb+7uXNGYlNJxEqCBs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+9ItvsJVHezh4db9AJSSwtkT+gdBuy49BE8KIe0cfkI=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/chronos"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/cosmic-utils/chronos";
    description = "Simple Pomodoro timer built using libcosmic";
    license = licenses.mit;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "chronos";
  };
}
