{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, just
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applibrary";
  version = "0-unstable-2024-05-02";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    rev = "08edc89ef035f1638358e64bd8b5170e65673b51";
    hash = "sha256-QoS+sFElSV2202tn/+q3qgJcXIw82zctJw3HMWD/+pU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-KVcKQ4DtoZCgFBnejIaQfQxJJJxd/mFzHBI+4PbGBio=";
      "cosmic-client-toolkit-0.1.0" = "sha256-XUiyL4M3hLBoBlpuG0K71QuhM4SSUBeYGtUhD+FL6Wg=";
      "cosmic-config-0.1.0" = "sha256-VEE/1XQZaojz9gxTV/Zz++eVplsCfiDPgf/cAr2Rih8=";
      "cosmic-settings-daemon-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-gUIQFHPaFTmtUfgpVvsGTnw2UKIBx9gl0K67KPuynWs=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-LDd56TJ175qsj2/EV/dbBRV9HMU7RzgrG5JP7H2PmhE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "switcheroo-control-0.1.0" = "sha256-t/dwQGNGvvMRhdjIDHbEh5sUjkBnjdxQm2PDudUutL0=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook just ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-app-library";
  };
}
