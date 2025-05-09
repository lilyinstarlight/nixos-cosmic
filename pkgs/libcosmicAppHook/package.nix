{
  stdenv,
  lib,
  makeSetupHook,
  makeBinaryWrapper,
  libGL,
  libxkbcommon,
  pkg-config,
  vulkan-loader,
  wayland,
  xorg,
  targetPackages,
  includeSettings ? true,
}:

makeSetupHook {
  name = "libcosmic-app-hook";

  propagatedBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  # ensure deps for linking below are available
  depsTargetTargetPropagated =
    assert (lib.assertMsg (!targetPackages ? raw) "libcosmicAppHook must be in nativeBuildInputs");
    [
      libGL
      libxkbcommon
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libxcb
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      wayland
      vulkan-loader
    ];

  substitutions = {
    fallbackXdgDirs = "${lib.optionalString includeSettings "${targetPackages.cosmic-settings}/share:"}${targetPackages.cosmic-icons}/share";

    cargoLinkerVar = stdenv.hostPlatform.rust.cargoEnvVarTarget;
    # force linking for all libraries that may be dlopen'd by libcosmic/iced apps
    cargoLinkLibs = lib.escapeShellArgs (
      [
        # for wgpu-hal
        "EGL"
        # for xkbcommon-dl
        "xkbcommon"
        # for x11-dl, tiny-xlib, wgpu-hal
        "X11"
        # for x11-dl, tiny-xlib
        "X11-xcb"
        # for x11-dl
        "Xcursor"
        "Xi"
        # for x11rb
        "xcb"
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        # for wgpu-hal, wayland-sys
        "wayland-client"
        # for wgpu-hal
        "wayland-egl"
        "vulkan"
      ]
    );
  };

  meta = {
    description = "Setup hook for configuring and wrapping applications based on libcosmic";
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
  };
} ./libcosmic-app-hook.sh
