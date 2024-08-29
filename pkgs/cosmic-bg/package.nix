{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, just
, nasm
, stdenv
, nix-update-script
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-bg";
  version = "1.0.0-alpha.1-unstable-2024-08-27";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-bg";
    rev = "e5e91d93fb7cd7e917922eceaddd4d412df46f93";
    hash = "sha256-3hhS4/+5wj5pjVKdS+BPy8Q7UUFaMKiGANfDIRBm+Dc=";
    # TODO: remove when <https://github.com/pop-os/cosmic-bg/commit/ed9ea6cc15638b08c848fda042ec2df3ff69865f#r145966372> is addressed
    postFetch = ''
      substituteInPlace $out/Cargo.toml --replace-fail 'libcosmic?branch=master' '/libcosmic'
      substituteInPlace $out/Cargo.lock --replace-fail 'libcosmic?branch=master?rev=' '/libcosmic?rev='
    '';
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-mdRRfXLyDBYQIPmbuXgXGoOKUlyw6CiSmOUBz1b3vJY=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just nasm ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-bg"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "epoch-(.*)" ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-bg";
    description = "Applies Background for the COSMIC Desktop Environment";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanbinary /*lilyinstarlight*/ ];
    platforms = platforms.linux;
    mainProgram = "cosmic-bg";
  };
}
