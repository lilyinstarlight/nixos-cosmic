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
  version = "0-unstable-2025-01-11";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "stellarshot";
    rev = "6f8339a5cf9ffb209ef57981fd1c31285cf3ad59";
    hash = "sha256-NSRg3qjzRbiQqPlDfRzzG9Id8srpul6Ad3xq/u2z+pI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xHrHDYZTw8dyxHYLZ8fxO5qHnd2M5NEbc0euaSYbH1o=";

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

  # TODO: remove after <https://github.com/cosmic-utils/stellarshot/pull/38/files#r1912618098> is addressed
  postPatch = ''
    mv res/com.github.{cosmic-utils,ahoneybun}.Stellarshot.desktop
    mv res/com.github.{cosmic-utils,ahoneybun}.Stellarshot.metainfo.xml
  '';

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
