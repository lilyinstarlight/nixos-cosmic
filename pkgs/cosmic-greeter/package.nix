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
  version = "0-unstable-2024-02-25";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "df9f2092e80f04afeabe68cde92732e450c17683";
    sha256 = "sha256-pMtpnTJzml5s/8uf7cW4njhilNJXs24QGWi/ILsBGNA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-bg-config-0.1.0" = "sha256-fdRFndhwISmbTqmXfekFqh+Wrtdjg3vSZut4IAQUBbA=";
      "cosmic-client-toolkit-0.1.0" = "sha256-vj7Wm1uJ5ULvGNEwKznNhujCZQiuntsWMyKQbIVaO/Q=";
      "cosmic-config-0.1.0" = "sha256-/2HNSxWMPbquHzYCOCPDM5clxBicQnHv7J6hRcHarVI=";
      "cosmic-dbus-networkmanager-0.1.0" = "sha256-z/dvRyc3Zc1fAQh2HKk6NI6QSDpNqarqslwszjU+0nc=";
      "cosmic-text-0.11.2" = "sha256-Y9i5stMYpx+iqn4y5DJm1O1+3UIGp0/fSsnNq3Zloug=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-2WbDKlSGiyVmi7blNBr2Aih9FfF2dq/bny57hoA4BrE=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
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
    substituteInPlace src/greeter.rs --replace '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = platforms.linux;
  };
}
