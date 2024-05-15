{
  lib,
  config,
  ...
}:
# possible actions:
# -----------------
# Terminate,
# Debug,
# Close,
# Escape,
# Workspace(u8),
# NextWorkspace,
# PreviousWorkspace,
# LastWorkspace,
# MoveToWorkspace(u8),
# MoveToNextWorkspace,
# MoveToPreviousWorkspace,
# MoveToLastWorkspace,
# SendToWorkspace(u8),
# SendToNextWorkspace,
# SendToPreviousWorkspace,
# SendToLastWorkspace,
# NextOutput,
# PreviousOutput,
# MoveToNextOutput,
# MoveToPreviousOutput,
# SendToNextOutput,
# SendToPreviousOutput,
# SwitchOutput(Direction),
# MoveToOutput(Direction),
# SendToOutput(Direction),
# MigrateWorkspaceToNextOutput,
# MigrateWorkspaceToPreviousOutput,
# MigrateWorkspaceToOutput(Direction),
# Focus(FocusDirection),
# Move(Direction),
# ToggleOrientation,
# Orientation(crate::shell::layout::Orientation),
# ToggleStacking,
# ToggleTiling,
# ToggleWindowFloating,
# ToggleSticky,
# SwapWindow,
# Resizing(ResizeDirection),
# Minimize,
# Maximize,
# Spawn(String),
let
  inherit (lib) filterAttrs concatStrings concatStringsSep mapAttrsToList concatLists foldlAttrs concatMapAttrs mapAttrs' nameValuePair boolToString;
  inherit (builtins) typeOf toString stringLength;

  # build up serialisation machinery from here for various types

  # list -> array
  array = a: "[${concatStringsSep "," a}]";
  # attrset -> hashmap
  _assoc = a: mapAttrsToList (name: val: "${name}: ${val}") a;
  assoc = a: ''    {
        ${concatStringsSep ",\n" (concatLists (map _assoc a))}
        }'';
  # attrset -> struct
  _struct_kv = k: v:
    if v == null
    then ""
    else (concatStringsSep ":" [k (serialise.${typeOf v} v)]);
  _struct_concat = s:
    foldlAttrs (
      acc: k: v:
        if stringLength acc > 0
        then concatStringsSep ", " [acc (_struct_kv k v)]
        else _struct_kv k v
    ) ""
    s;
  _struct_filt = s:
    _struct_concat (filterAttrs (k: v: v != null) s);
  struct = s: "(${_struct_filt s})";
  toQuotedString = s: ''"${toString s}"'';

  # make an attrset for struct serialisation
  serialise = {
    int = toString;
    float = toString;
    bool = boolToString;
    string = toString;
    path = toString;
    null = toString;
    set = struct;
    list = array;
  };

  # define the key for a keybind
  defineBinding = binding:
    struct {
      inherit (binding) modifiers;
      key =
        if isNull binding.key
        then null
        else toQuotedString binding.key;
    };

  # map keybinding from list of attrset to hashmap of (mod,key): action
  _mapBindings = bindings:
    map (
      inner: {"${defineBinding inner}" = maybeToString (checkAction inner.action);}
    )
    bindings;
  mapBindings = bindings:
    assoc (_mapBindings bindings);

  # check a keybinding's action
  # escape with quotes if it's a Spawn action
  checkAction = a:
    if typeOf a == "set" && a.type == "Spawn"
    then {
      inherit (a) type;
      data = toQuotedString a.data;
    }
    else a;

  maybeToString = s:
    if typeOf s == "set"
    then concatStrings [s.type "(" (toString s.data) ")"]
    else s;

  # set up boilerplate for keybinding config file
  cosmic-bindings = a:
    struct {
      key_bindings = mapBindings a;
      data_control_enabled = false;
    };
in {
  options.services.desktopManager.cosmic.keybindings = with lib;
    mkOption {
      default = [];
      type = with types;
        listOf (submodule {
          options = {
            modifiers = mkOption {
              type = listOf str;
              default = [];
            };
            key = mkOption {
              type = nullOr str;
              default = null;
            };
            action = mkOption {
              type = either str (submodule {
                options = {
                  type = mkOption {
                    type = str;
                  };
                  data = mkOption {
                    type = oneOf [str int];
                    default = "";
                  };
                };
              });
            };
          };
        });
    };

  options.services.desktopManager.cosmic.otherSettings = with lib;
    mkOption {
      default = {};
      type = with types;
        attrsOf (submodule {
          options = {
            version = mkOption {
              type = str;
              default = "1";
            };
            option = mkOption {
              type = attrsOf anything;
            };
          };
        });
    };

  config.environment.etc =
    {
      "cosmic-comp/config.ron".text = cosmic-bindings config.services.desktopManager.cosmic.keybindings;
    }
    // concatMapAttrs (
      application: options:
        mapAttrs' (k: v:
          nameValuePair "xdg/cosmic/${application}/v${options.version}/${k}" {
            enable = true;
            text = serialise.${typeOf v} v;
          })
        options.option
    )
    config.services.desktopManager.cosmic.otherSettings;
}
