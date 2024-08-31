{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bash,
  dbus,
  just,
  rust,
  stdenv,
  xdg-desktop-portal-cosmic,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-session";
  version = "1.0.0-alpha.1-unstable-2024-08-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    rev = "65d4ee1fe20fd5f77d296f2ff7217cff0b85fe72";
    sha256 = "sha256-hH5hBGaX4QJhHHZa8miOYxW3n7kn/z2O4BPGU5Rx4Gw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-notifications-util-0.1.0" = "sha256-GmTT7SFBqReBMe4GcNSym1YhsKtFQ/0hrDcwUqXkaBw=";
      "launch-pad-0.1.0" = "sha256-c+uawTQlg5SW8x7DOBG2Idv/AfIaCFNtLQLUz8ifT2I=";
    };
  };

  postPatch = ''
    substituteInPlace Justfile \
      --replace-fail '{{cargo-target-dir}}/release/cosmic-session' 'target/${rust.lib.toRustTargetSpecShort stdenv.hostPlatform}/release/cosmic-session'
    substituteInPlace data/start-cosmic \
      --replace-fail '/usr/bin/cosmic-session' '${placeholder "out"}/bin/cosmic-session' \
      --replace-fail '/usr/bin/dbus-run-session' '${lib.getExe' dbus "dbus-run-session"}'
    substituteInPlace data/cosmic.desktop \
      --replace-fail '/usr/bin/start-cosmic' '${placeholder "out"}/bin/start-cosmic'
  '';

  nativeBuildInputs = [ just ];
  buildInputs = [ bash ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  env.XDP_COSMIC = lib.getExe xdg-desktop-portal-cosmic;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "epoch-(.*)" ];
    };
    providedSessions = [ "cosmic" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC desktop environment";
    license = licenses.gpl3Only;
    mainProgram = "cosmic-session";
    maintainers = with maintainers; [
      a-kenji
      nyanbinary
      /*lilyinstarlight*/
    ];
    platforms = platforms.linux;
  };
}
