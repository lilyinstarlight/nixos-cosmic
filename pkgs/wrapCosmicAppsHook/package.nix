{ stdenv
, lib
, makeSetupHook
, makeBinaryWrapper
, cosmic-icons
, cosmic-settings
, libGL
, libxkbcommon
, xorg
, wayland
, vulkan-loader
, targetPackages
}:

makeSetupHook {
  name = "wrap-cosmic-apps-hook";

  propagatedBuildInputs = [ makeBinaryWrapper ];

  # TODO: Xorg libs can be removed once tiny-xlib is bumped above 0.2.2 in libcosmic/iced
  depsTargetTargetPropagated = assert (lib.assertMsg (!targetPackages ? raw) "wrapGAppsHook must be in nativeBuildInputs"); [
    libGL
    libxkbcommon
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ] ++ lib.optionals (!stdenv.isDarwin) [
    wayland
    vulkan-loader
  ];

  substitutions = {
    inherit cosmic-icons cosmic-settings;

    cargoLinkerVar = stdenv.hostPlatform.rust.cargoEnvVarTarget;
    cargoLinkLibs = lib.escapeShellArgs ([
      # propagated from libGL
      "EGL"
      # propagated from libxkbcommon
      "xkbcommon"
      # propagated from xorg.libX11
      "X11"
      # propagated from xorg.libXcursor
      "Xcursor"
      # propagated from xorg.libXi
      "Xi"
      # propagated from xorg.libXrandr
      "Xrandr"
    ] ++ lib.optionals (!stdenv.isDarwin) [
      # propagated from wayland
      "wayland-client"
      # propagated from vulkan-loader
      "vulkan"
    ]);
  };
} ./wrap-cosmic-apps-hook.sh
