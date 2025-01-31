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
  pname = "cosmic-ext-applet-system-monitor";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "D-Brox";
    repo = "cosmic-ext-applet-system-monitor";
    rev = "8d133a4d5ee431b878b482f18b98e86b224992e8";
    hash = "sha256-AwpZ2nb3YPfOAFpkoKZrDm4264UmVH96SmKLc0l81R4=";
  };


  useFetchCargoVendor = true;
  cargoHash = "";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-system-monitor"
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR="$TMP"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/D-Brox/cosmic-ext-applet-system-monitor";
    description = "System monitor for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-system-monitor";
  };
}
