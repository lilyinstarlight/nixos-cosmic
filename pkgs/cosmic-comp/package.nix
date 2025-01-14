{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  libdisplay-info,
  libgbm ? null,
  libinput,
  mesa,
  pixman,
  pkg-config,
  seatd,
  stdenv,
  udev,
  xwayland,
  useXWayland ? true,
  systemd,
  useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-comp";
  version = "1.0.0-alpha.5-unstable-2025-01-12";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "7425ffbad9808f024777540657af94c780b64714";
    hash = "sha256-pk3o8bRVA+n9JSLsFW7fS3cal3DP2gd++7g9CwWVuh4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-P4/Y70vnyIR5JBpHCOhqLlyfan29eNsExkt3ux7joRw=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];
  buildInputs = [
    libdisplay-info
    (if libgbm != null then libgbm else mesa)
    libinput
    pixman
    seatd
    udev
  ] ++ lib.optional useSystemd systemd;

  # only default feature is systemd
  buildNoDefaultFeatures = !useSystemd;

  # TODO: remove when <https://github.com/NixOS/nixpkgs/pull/371795> reaches nixos-unstable and nixos-24.11
  postConfigure = ''
    substituteInPlace ../.cargo/config.toml --replace-fail 'branch = "feature%2Fcopy_clone"' 'branch = "feature/copy_clone"'
  '';

  dontCargoInstall = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  preFixup = lib.optionalString useXWayland ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ xwayland ]})
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-comp";
  };
}
