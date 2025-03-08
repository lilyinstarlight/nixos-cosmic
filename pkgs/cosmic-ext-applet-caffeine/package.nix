{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-caffeine";
  version = "0-unstable-2025-02-05";

  src = fetchFromGitHub {
    owner = "tropicbliss";
    repo = "cosmic-ext-applet-caffeine";
    rev = "9fc49bb62377f06cde53b10d46cc33efad9f3a10";
    hash = "sha256-hWa1pvBNE2K4p/BqneXrC9wxSvRmrDlCp8gDgjn4Kng=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xTJwVus28p7rNbfYRANo1UYkXDvwOc4ozuu+kPM3GDI=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  postPatch = ''
    substituteInPlace justfile \
      --replace-fail 'sudo cp res/net.tropicbliss.CosmicExtAppletCaffeine.svg /usr/share/icons/hicolor/scalable/apps' \
                     'install -Dm0644 res/net.tropicbliss.CosmicExtAppletCaffeine.svg ${placeholder "out"}/share/icons/hicolor/scalable/apps/net.tropicbliss.CosmicExtAppletCaffeine.svg'
  '';

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
