{ lib
, fetchFromGitHub
, fetchpatch
, rustPlatform
, wrapCosmicAppsHook
, cmake
, coreutils
, just
, linux-pam
, pkg-config
, rust
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-greeter";
  version = "0-unstable-2024-03-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "1b13865ea07d5f87406c2d7303b975131bafa262";
    sha256 = "sha256-+xtMZroRWv711W0tpGJkQAgBMiGy1AmvyrrR1PhQcVU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-fdRFndhwISmbTqmXfekFqh+Wrtdjg3vSZut4IAQUBbA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-NRqpgQjLf6ZijhcnyWdVsCam4W/gtVf/b2+m+7IzW4o=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.10.0" = "sha256-WxT0LPXu17jb0XpuCu2PjlGTV1a0K1HMhl6WpciKMkM=";
      "glyphon-0.4.1" = "sha256-mwJXi63LTBIVFrFcywr/NeOJKfMjQaQkNl3CSdEgrZc=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  patches = [
    # TODO: see upstream PR pop-os/cosmic-greeter#16
    (fetchpatch {
      name = "cosmic-greeter-update-libcosmic.patch";
      url = "https://github.com/pop-os/cosmic-greeter/commit/0c0d376d60b618763fd28a51e3f5ea0998e51be1.diff";
      hash = "sha256-/Yf5XVRYjp3XtexOy5Xfv/5edEX5CaRUnQWVhvq/258=";
    })
  ];

  nativeBuildInputs = [ wrapCosmicAppsHook rustPlatform.bindgenHook cmake just pkg-config ];
  buildInputs = [ linux-pam ];

  cargoBuildFlags = [ "--all" ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${rust.lib.toRustTargetSpecShort stdenv.hostPlatform}/release/cosmic-greeter"
    "--set"
    "daemon-src"
    "target/${rust.lib.toRustTargetSpecShort stdenv.hostPlatform}/release/cosmic-greeter-daemon"
  ];

  postPatch = ''
    substituteInPlace src/greeter.rs --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
