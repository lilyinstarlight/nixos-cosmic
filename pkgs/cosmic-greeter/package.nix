{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, cmake
, coreutils
, just
, linux-pam
, rust
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-greeter";
  version = "0-unstable-2024-06-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "4653bb1de9e76dccfd69387ff985d1373e86c069";
    sha256 = "sha256-bBbWJVdryoFHENiJ50dgGPwRdsbc2Pp3EUWQJWlph3I=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-bg-config-0.1.0" = "sha256-OYJ6RfWuo9kcrdE3z2gKyVyhmxJeWqigQ37AgS8W0Mc=";
      "cosmic-client-toolkit-0.1.0" = "sha256-XUiyL4M3hLBoBlpuG0K71QuhM4SSUBeYGtUhD+FL6Wg=";
      "cosmic-config-0.1.0" = "sha256-80einOpwpoBsJScgfd0O8yY5AdbjKazh6oQhs/w9L+w=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-Bz/bzXCm60AF0inpZJDF4iNZIX3FssImORrE5nZpkyQ=";
      "cosmic-text-0.11.2" = "sha256-O8l3Auo+7/aqPYvWQXpOdrVHHdjc1fjoU1nFxqdiZ5I=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook rustPlatform.bindgenHook cmake just ];
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
