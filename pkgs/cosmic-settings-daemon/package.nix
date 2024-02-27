{ lib
, fetchFromGitHub
, rustPlatform
, geoclue2-with-demo-agent
, pkg-config
, udev
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-settings-daemon";
  version = "0-unstable-2024-02-22";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings-daemon";
    rev = "bbc896586658846a4e1ec6fc005b66923fa5ff5e";
    hash = "sha256-W7u7WZL6wPH5fnR/sUC/n1mMxMaQDVpf/FBQmZPhBRs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-P7GCTYfRvqIN8CeheyTELx6fMKCTsaZCp9oEbda2jCo=";
      "geoclue2-0.1.0" = "sha256-a/cvbB0M9cUd8RP5XxgHRbJ/i/UKAEK4DTwwUU69IuY=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  env.GEOCLUE_AGENT = "${lib.getLib geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings-daemon";
    description = "Settings Daemon for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
