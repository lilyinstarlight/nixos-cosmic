# shellcheck shell=bash
cosmicAppsWrapperArgs=()

cosmicAppsLinkerArgsHook() {
  # Force linking to libEGL, which is always dlopen()ed.
  local flags="CARGO_TARGET_@cargoLinkerVar@_RUSTFLAGS"

  export "$flags"="${!flags-} -C link-arg=-Wl,--push-state,--no-as-needed"
  # shellcheck disable=SC2043
  for lib in @cargoLinkLibs@; do
      export "$flags"="${!flags} -C link-arg=-l${lib}"
  done
  export "$flags"="${!flags} -C link-arg=-Wl,--pop-state"
}

preConfigurePhases+=" cosmicAppsLinkerArgsHook"

cosmicAppsWrapperArgsHook() {
    # add fallback schemas, icons, and settings paths
    cosmicAppsWrapperArgs+=(--suffix XDG_DATA_DIRS : "@cosmic-settings@/share:@cosmic-icons@/share")

    if [ -d "${prefix:?}/share" ]; then
        cosmicAppsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$prefix/share")
    fi
}

preFixupPhases+=" cosmicAppsWrapperArgsHook"

wrapCosmicApp() {
    local program="$1"
    shift 1
    wrapProgram "$program" "${cosmicAppsWrapperArgs[@]}" "$@"
}

# Note: $cosmicAppsWrapperArgs still gets defined even if ${dontWrapCosmicApps-} is set.
wrapCosmicAppsHook() {
    # guard against running multiple times (e.g. due to propagation)
    [ -z "$wrapCosmicAppsHookHasRun" ] || return 0
    wrapCosmicAppsHookHasRun=1

    if [[ -z "${dontWrapCosmicApps:-}" ]]; then
        targetDirsThatExist=()
        targetDirsRealPath=()

        # wrap binaries
        targetDirs=("${prefix}/bin" "${prefix}/libexec")
        for targetDir in "${targetDirs[@]}"; do
            if [[ -d "${targetDir}" ]]; then
                targetDirsThatExist+=("${targetDir}")
                targetDirsRealPath+=("$(realpath "${targetDir}")/")
                find "${targetDir}" -type f -executable -print0 |
                    while IFS= read -r -d '' file; do
                        echo "Wrapping program '${file}'"
                        wrapCosmicApp "${file}"
                    done
            fi
        done

        # wrap links to binaries that point outside targetDirs
        # Note: links to binaries within targetDirs do not need
        #       to be wrapped as the binaries have already been wrapped
        if [[ ${#targetDirsThatExist[@]} -ne 0 ]]; then
            find "${targetDirsThatExist[@]}" -type l -xtype f -executable -print0 |
                while IFS= read -r -d '' linkPath; do
                    linkPathReal=$(realpath "${linkPath}")
                    for targetPath in "${targetDirsRealPath[@]}"; do
                        if [[ "$linkPathReal" == "$targetPath"* ]]; then
                            echo "Not wrapping link: '$linkPath' (already wrapped)"
                            continue 2
                        fi
                    done
                    echo "Wrapping link: '$linkPath'"
                    wrapCosmicApp "${linkPath}"
                done
        fi
    fi
}

fixupOutputHooks+=(wrapCosmicAppsHook)
