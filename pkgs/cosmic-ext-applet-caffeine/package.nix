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
  version = "0-unstable-2026-04-18";

  src = fetchFromGitHub {
    owner = "tropicbliss";
    repo = "cosmic-ext-applet-caffeine";
    rev = "96f7be5de71a460b9c26ec024bb8089208ad991f";
    hash = "sha256-wdsm6snDY61+sJfzKkLDGVbAm5mC0lWDCTlDdImTwO8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9EUrO8JNU0FPrqT6WDE+jfVgQSgODK8rbNZLgUb26EQ=";

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
