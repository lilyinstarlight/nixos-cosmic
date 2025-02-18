{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  gnused,
  gnutar,
  jq,
  just,
  libgbm ? null,
  mesa,
  stdenv,
  systemd,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "observatory";
  version = "0.2.2-unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "observatory";
    rev = "2301c69cdc662dae83e7369ac808c68782ffdc3d";
    hash = "sha256-l/HJM50aQOH2VhQs7DqV2it7+l2Auek2eJ6fFotu82g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bxOIXjie/XVur3aNLJif3yI3Yp5VyMSMzOciJHcUhHI=";

  nvtop = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = "19382d93086acf36f32a8d72173fb9968232e3c1";
    hash = "sha256-LHVyG6XdBIR4v636cUW/skmqSvq7sEEHLJ+NuJuLUo8=";
  };

  nativeBuildInputs = [
    libcosmicAppHook
    gnused
    gnutar
    jq
    just
  ];

  buildInputs = [
    (if libgbm != null then libgbm else mesa)
    systemd
    udev
  ];

  postPatch = ''
    nvtop_json="observatory-daemon/3rdparty/nvtop/nvtop.json"
    nvtop_archive="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/build/native/$(jq -r '(."source-url" | split("/"))[-1]' "$nvtop_json")"
    mkdir -p "$(dirname "$nvtop_archive")"
    tar -czf "$nvtop_archive" --absolute-names --transform="s,$nvtop,$(jq -r '.directory' "$nvtop_json")," --mode=+w "$nvtop"
    sed -i -e 's/\("source-hash":\s*"\)[^"]*\("\)/\1'"$(sha256sum -b "$nvtop_archive" | cut -d' ' -f1)"'\2/' "$nvtop_json"
  '';

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  doCheck = false;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/observatory"
    "--set"
    "dae-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/observatory-daemon"
  ];

  postInstall = ''
    patchelf --add-needed libsystemd.so.0 $out/bin/observatory-daemon

    libcosmicAppWrapperArgs+=(--prefix PATH : $out/bin)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/observatory";
    description = "System monitor application for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "observatory";
  };
}
