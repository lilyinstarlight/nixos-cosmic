{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  just,
  pkg-config,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-randr";
  version = "1.0.0-alpha.4-unstable-2024-11-26";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "311b944d3f549af21a57fd348d0ede8219dd7f9c";
    hash = "sha256-H7b1y7tujXvaD7E/3nIRAfp2nErASiIxvA1qnYCikt8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+InIQ9DnmdZHg9OdZ9+njSd8F32LaNp6Tmey2u6+jVE=";

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [ wayland ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-randr"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-randr";
    description = "Library and utility for displaying and configuring Wayland outputs";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";
  };
}
