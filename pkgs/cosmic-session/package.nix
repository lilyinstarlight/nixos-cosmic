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
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-session";
  version = "0-unstable-2024-04-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    rev = "9d65eca9c90f77e6f38e70e4a1f7fce8f7fcabe5";
    sha256 = "sha256-d607/VJDD+5pAEvTab64F1fwYgog5cNJgfI9xiN9bo0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-notifications-util-0.1.0" = "sha256-GmTT7SFBqReBMe4GcNSym1YhsKtFQ/0hrDcwUqXkaBw=";
      "launch-pad-0.1.0" = "sha256-tnbSJ/GP9GTnLnikJmvb9XrJSgnUnWjadABHF43L1zc=";
    };
  };

  postPatch = ''
    substituteInPlace Justfile \
      --replace-fail 'target/release/cosmic-session' "target/${rust.lib.toRustTargetSpecShort stdenv.hostPlatform}/release/cosmic-session"
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

  passthru.providedSessions = [ "cosmic" ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC desktop environment";
    license = licenses.gpl3Only;
    mainProgram = "cosmic-session";
    maintainers = with maintainers; [
      a-kenji
      nyanbinary
      lilyinstarlight
    ];
    platforms = platforms.linux;
  };
}
