{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  gnused,
  gnutar,
  jq,
  just,
  mesa,
  stdenv,
  systemd,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-observatory";
  version = "0.2.2-unstable-2024-12-13";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "observatory";
    rev = "27415c2146769f2aa661a03b2afa250da0934729";
    hash = "sha256-r3YBdDEh2EfPp4XKhSCwQj4VUHg89q9vWpm53O46Fes=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4BnulyS0qQBTh1tl5uS/TAgu3Onlg3Au5RvfI32n9dM=";

  nvtop = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = "6e91c745cd051d902fc57e9195068df03eb192bb";
    hash = "sha256-1wKNBRlWAsXcWAXrNhYg2TBTxkE0QnMig0hunHkQLFA=";
  };

  nativeBuildInputs = [
    libcosmicAppHook
    gnused
    gnutar
    jq
    just
  ];

  buildInputs = [
    mesa
    systemd
    udev
  ];

  postPatch = ''
    nvtop_json="observatory-daemon/3rdparty/nvtop/nvtop.json"
    nvtop_archive="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/build/native/$(jq -r '(."source-url" | split("/"))[-1]' "$nvtop_json")"
    mkdir -p "$(dirname "$nvtop_archive")"
    tar -czf "$nvtop_archive" --absolute-names --transform="s,$nvtop,$(jq -r '.directory' "$nvtop_json")," --mode=+w "$nvtop"
    sed -i -e 's/\("source-hash":\s*"\)[^"]*\("\)/\1'"$(sha256sum -b "$nvtop_archive" | cut -d' ' -f1)"'\2/' "$nvtop_json"

    substituteInPlace observatory-daemon/build/build.rs \
      --replace-fail "$(printf '    #[cfg(not(debug_assertions))]\n    build_def.flag("-flto");\n')" ""
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

  meta = with lib; {
    homepage = "https://github.com/cosmic-utils/observatory";
    description = "System monitor application for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "observatory";
  };
}
