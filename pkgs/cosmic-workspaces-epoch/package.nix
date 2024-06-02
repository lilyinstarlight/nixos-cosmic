{ lib
, rustPlatform
, fetchFromGitHub
, wrapCosmicAppsHook
, pkg-config
, libinput
, mesa
, udev
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-workspaces-epoch";
  version = "0-unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "4a1d66dfd64bd7db8ae1a1b1bf62fe896b62af79";
    hash = "sha256-Kpesqxt5G5sHOesg8Cmhnhcc6DXYPlVLTxh1552dPFQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-bg-config-0.1.0" = "sha256-OYJ6RfWuo9kcrdE3z2gKyVyhmxJeWqigQ37AgS8W0Mc=";
      "cosmic-client-toolkit-0.1.0" = "sha256-XUiyL4M3hLBoBlpuG0K71QuhM4SSUBeYGtUhD+FL6Wg=";
      "cosmic-comp-config-0.1.0" = "sha256-/Af7dQOfQ+VywvBFcOclYluDetrqJpMjvEXqvjYEb7Q=";
      "cosmic-config-0.1.0" = "sha256-80einOpwpoBsJScgfd0O8yY5AdbjKazh6oQhs/w9L+w=";
      "cosmic-text-0.11.2" = "sha256-O8l3Auo+7/aqPYvWQXpOdrVHHdjc1fjoU1nFxqdiZ5I=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook pkg-config ];
  buildInputs = [ libinput mesa udev ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
