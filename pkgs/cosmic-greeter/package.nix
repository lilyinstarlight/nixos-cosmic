{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  cmake,
  coreutils,
  just,
  libinput,
  linux-pam,
  stdenv,
  udev,
  xkeyboard_config,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-greeter";
  version = "1.0.0-alpha.7-unstable-2025-05-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "b38bcd296a3dfc3cc154e8154ad2824313a67280";
    hash = "sha256-8Lu6TJ7RxuRJsfKqjjyk61GaRV9N/JgPq99sACV9u9Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-alzCbzrFKhG9oIP7Isc+LlVADPCid1NoKPV+wH3DzZg=";

  nativeBuildInputs = [
    libcosmicAppHook
    rustPlatform.bindgenHook
    cmake
    just
  ];
  buildInputs = [
    libinput
    linux-pam
    udev
  ];

  cargoBuildFlags = [ "--all" ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-greeter"
    "--set"
    "daemon-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-greeter-daemon"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  postPatch = ''
    substituteInPlace src/greeter.rs --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  postInstall = ''
    libcosmicAppWrapperArgs+=(--set-default X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set-default X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-greeter";
  };
}
