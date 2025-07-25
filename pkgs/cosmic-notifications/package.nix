{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  stdenv,
  which,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-notifications";
  version = "1.0.0-alpha.7-unstable-2025-07-25";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-notifications";
    rev = "744439a6e79f7bcb74ba861d525318f9b774c7f5";
    hash = "sha256-Yymjsj+3aeaP8pv4jO2VKVOrADE2sBVar92ElVVUJgw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3rBbjAVdpNKYBHOrI/Zsb4Q5J9Xx4ddeCpzsUK51mns=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    which
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-notifications"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-notifications";
    description = "Notifications for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-notifications";
  };
}
