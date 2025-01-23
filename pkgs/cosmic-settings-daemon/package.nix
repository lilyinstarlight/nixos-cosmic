{
  lib,
  fetchFromGitHub,
  rustPlatform,
  geoclue2-with-demo-agent,
  libinput,
  pkg-config,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-settings-daemon";
  version = "1.0.0-alpha.5.1-unstable-2025-01-23";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "58ff27f9723cd68b6e143b7acadcfe20324ea83c";
    hash = "sha256-DtwW6RxHnNh87Xu0NCULfUsHNzYU9tHtFKE9HO3rvME=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lGzQBL9IXbPsaKeVHp34xkm5FnTxWvfw4wg3El4LZdA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libinput
    udev
  ];

  env.GEOCLUE_AGENT = "${lib.getLib geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";

  postInstall = ''
    mkdir -p $out/share/{polkit-1/rules.d,cosmic/com.system76.CosmicSettings.Shortcuts/v1}
    cp data/polkit-1/rules.d/*.rules $out/share/polkit-1/rules.d/
    cp data/system_actions.ron $out/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/system_actions
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings daemon for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-settings-daemon";
  };
}
