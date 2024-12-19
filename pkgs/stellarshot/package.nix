{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stellarshot";
  version = "0-unstable-2024-11-15";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "stellarshot";
    rev = "6e89acbc04c6f9dadc355e382f61999ce0fc3003";
    hash = "sha256-IveSLIxzZanzbkMk/JtARJ1nORhWW4rou19dSMdfErw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3iRCc4/2hcSMlvCp0T7gGgBCl2g3uDvQF5c8gP3OuL0=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/stellarshot"
  ];

  # TODO: upstream depends on inter-test side effects and therefore depends on test ordering and lack of concurrency, but tests also do not seem useful
  doCheck = false;

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/cosmic-utils/stellarshot";
    description = "Simple backup application using Rustic for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "stellarshot";
  };
}
