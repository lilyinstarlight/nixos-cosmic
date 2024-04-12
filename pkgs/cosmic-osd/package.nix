{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, pkg-config
, pulseaudio
, udev
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-osd";
  version = "0-unstable-2024-04-11";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osd";
    rev = "a216b22041b24355a517c5c6400ec50d66dfaf7e";
    hash = "sha256-+Ened13Ans2vMJHRcp1dlqLVbR89RPJVywhzj96z7qU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-X+QfL3XndZiFjacBdgOQyEBh3Qyok28c1+HUqg4D/u8=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-x/xWMR5w2oEbghTSa8iCi24DA2s99+tcnga8K6jS6HQ=";
      "cosmic-text-0.11.2" = "sha256-K9cZeClr1zz4LanJS0WPEpxAplQrXfCjFKrSn5n4rDA=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "smithay-clipboard-0.8.0" = "sha256-OZOGbdzkgRIeDFrAENXE7g62eQTs60Je6lYVr0WudlE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook pkg-config ];
  buildInputs = [ pulseaudio udev ];

  env.POLKIT_AGENT_HELPER_1 = "/run/wrappers/bin/polkit-agent-helper-1";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-osd";
    description = "OSD for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
