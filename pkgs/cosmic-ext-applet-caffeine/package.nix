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
  version = "0-unstable-2025-05-02";

  src = fetchFromGitHub {
    owner = "tropicbliss";
    repo = "cosmic-ext-applet-caffeine";
    rev = "fbed3de2e9716e333d6037b4009fa2a1760de243";
    hash = "sha256-yCv/lque8RrSmQTDpLM+M2CBsNJKz6zEyERD1b1ZSw4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xTJwVus28p7rNbfYRANo1UYkXDvwOc4ozuu+kPM3GDI=";

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
