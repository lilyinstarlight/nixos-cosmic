pkgs:

{
  cosmic-ext-examine = pkgs.lib.warn "`cosmic-ext-examine` has been renamed to `examine`." pkgs.examine;
  cosmic-ext-tasks = pkgs.lib.warn "`cosmic-ext-tasks` has been renamed to `tasks`." pkgs.tasks;
}
