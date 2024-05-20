{ lib
, fetchFromGitHub
, fetchpatch
, rustPlatform
, wrapCosmicAppsHook
, cmake
, coreutils
, just
, linux-pam
, rust
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-greeter";
  version = "0-unstable-2024-05-20";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "4613fbb1849af68e8967ad95ce1d58158a7fb4c6";
    sha256 = "sha256-o2KaFhgmO3wVzxOPoai41DH/RaniGKOkn7+NCNiekLQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-bg-config-0.1.0" = "sha256-OYJ6RfWuo9kcrdE3z2gKyVyhmxJeWqigQ37AgS8W0Mc=";
      "cosmic-client-toolkit-0.1.0" = "sha256-XUiyL4M3hLBoBlpuG0K71QuhM4SSUBeYGtUhD+FL6Wg=";
      "cosmic-config-0.1.0" = "sha256-seGqRDy37n0SNiJplXNbU1f6jlP4JuskeKvdUS2Z7WQ=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-Bz/bzXCm60AF0inpZJDF4iNZIX3FssImORrE5nZpkyQ=";
      "cosmic-text-0.11.2" = "sha256-Jpgbg1DScteec7ItcGgbQYXu1bBNYJEw1SGsxpcxYfM=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  patches = [
    (fetchpatch {
      # TODO: remove when pop-os/cosmic-greeter#48 is merged
      name = "cosmic-greeter-fix-dbus-error-with-zbus-4.patch";
      url = "https://github.com/pop-os/cosmic-greeter/commit/21b00afdde0fe7ace06caa5e9fe19b76e3890ce9.diff";
      hash = "sha256-x1yKDm7RBUZ4YcLq66JH3sapM4ulunEi9MEs8WCrVfs=";
    })
  ];

  nativeBuildInputs = [ wrapCosmicAppsHook rustPlatform.bindgenHook cmake just ];
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
