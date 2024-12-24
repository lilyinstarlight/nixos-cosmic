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
  version = "1.0.0-alpha.4-unstable-2024-12-24";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "61c76a9d060827402eeb9fe92cae73ce159d66e5";
    hash = "sha256-BCOVyJ1IIik/R4qC/16csJH8yII4WxdxO116hdvUl3I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-w/2BivWmKj5jh50OS4eR7Rf5kR3OT33jwIyEcsC1M8I=";

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

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings daemon for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings-daemon";
  };
}
