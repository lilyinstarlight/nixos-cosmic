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

rustPlatform.buildRustPackage {
  pname = "cosmic-greeter";
  version = "1.0.0-alpha.4-unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "b09f267929e26ef6410c4c57cfec9520776b3886";
    hash = "sha256-KuJ+YJUXVURXQ4nVRsuNnAAIs0X8Mtq0V6eATDxgf3w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nmkM/Jm2P5ftZFfzX+O1Fe6eobRbgBkajZsbyI67Zfw=";

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

  postPatch = ''
    substituteInPlace src/greeter.rs --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  postInstall = ''
    libcosmicAppWrapperArgs+=(--set X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-greeter";
  };
}
