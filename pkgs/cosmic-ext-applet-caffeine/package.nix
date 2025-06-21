{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-caffeine";
  version = "0-unstable-2025-06-17";

  src = fetchFromGitHub {
    owner = "tropicbliss";
    repo = "cosmic-ext-applet-caffeine";
    rev = "229a9e4a41554b9a8e80e64df780f036abf53b58";
    hash = "sha256-w6bMWznltXXaOU99Vhe6g59ruk7lfj0p9csXD/bU2cw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pjHvtyo4eK7sygBTi8OHBrUvQV95K2b+lsHZK3h+oLY=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-caffeine"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tropicbliss/cosmic-ext-applet-caffeine";
    description = "Caffeine Applet for the COSMIC desktop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-caffeine";
  };
}
