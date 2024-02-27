{ lib
, fetchFromGitHub
, rustPlatform
, wrapCosmicAppsHook
, cmake
, expat
, fontconfig
, freetype
, just
, pkg-config
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-design-demo";
  version = "0-unstable-2024-01-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-design-demo";
    rev = "d58cfad46f2982982494fce27fb00ad834dc8992";
    hash = "sha256-nWkiaegSjxgyGlpjXE9vzGjiDORaRCSoZJMDv0jtvaA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.11.0" = "sha256-xVhe6adUb8VmwIKKjHxwCwOo5Y1p3Or3ylcJJdLDrrE=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-AEgvF7i/OWPdEMi8WUaAg99igBwE/AexhAXHxyeJMdc=";
      "cosmic-config-0.1.0" = "sha256-fOaAG5p4RVULMZZA1EPXUw2t8R0Xw9B66ZIFow3376Q=";
      "cosmic-text-0.10.0" = "sha256-lurasfMuFEi1o4aNJfqRe3YpsXpxdaZiUMVquC1DyX0=";
      "cosmic-time-0.4.0" = "sha256-kPahIznCtjIa38ty8IzGTbZ25tEZ26hLOL1ybPaTeAk=";
      "glyphon-0.3.0" = "sha256-JGkNIfj1HjOF8kGxqJPNq/JO+NhZD6XrZ4KmkXEP6Xc=";
      "smithay-client-toolkit-0.16.1" = "sha256-z7EZThbh7YmKzAACv181zaEZmWxTrMkFRzP0nfsHK6c=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.3.3" = "sha256-eKYFVr6C1+X6ulidHIu9SP591rJxStxwL9uMiqnXx4k=";
      "sctk-adwaita-0.5.4" = "sha256-yK0F2w/0nxyKrSiHZbx7+aPNY2vlFs7s8nu/COp2KqQ=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.28.6" = "sha256-FhW6d2XnXCGJUMoT9EMQew9/OPXiehy/JraeCiVd76M=";
    };
  };

  nativeBuildInputs = [ wrapCosmicAppsHook cmake just pkg-config ];
  buildInputs = [ expat fontconfig freetype ];

  dontUseJustBuild = true;

  justFlags = [
    "--unstable"
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-design-demo"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-design-demo";
    description = "Design Demo for the COSMIC Desktop Environment";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-design-demo";
  };
}
