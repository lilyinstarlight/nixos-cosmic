{ lib
, fetchFromGitHub
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
  version = "0-unstable-2024-05-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "e8faaebeb0661cd171723d32b14c6a3a2c629f48";
    sha256 = "sha256-HuZvDECcJnDW+OfuG2LGOu3BmV3kFUQH+2A9qZ9BdOk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-KVcKQ4DtoZCgFBnejIaQfQxJJJxd/mFzHBI+4PbGBio=";
      "cosmic-bg-config-0.1.0" = "sha256-yFyrMakBlFgSwqTmVzPoCL0QmhIlfXhv7r4MtBnD2No=";
      "cosmic-client-toolkit-0.1.0" = "sha256-XUiyL4M3hLBoBlpuG0K71QuhM4SSUBeYGtUhD+FL6Wg=";
      "cosmic-config-0.1.0" = "sha256-VEE/1XQZaojz9gxTV/Zz++eVplsCfiDPgf/cAr2Rih8=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-gUIQFHPaFTmtUfgpVvsGTnw2UKIBx9gl0K67KPuynWs=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-LDd56TJ175qsj2/EV/dbBRV9HMU7RzgrG5JP7H2PmhE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

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
