pkgs:

{
  cosmic-ext-examine = pkgs.lib.warn "`cosmic-ext-examine` has been renamed to `examine`." pkgs.examine;
  cosmic-ext-forecast = pkgs.lib.warn "`cosmic-ext-forecast` has been renamed to `forecast`." pkgs.forecast;
  cosmic-ext-observatory = pkgs.lib.warn "`cosmic-ext-observatory` has been renamed to `observatory`." pkgs.observatory;
  cosmic-ext-tasks = pkgs.lib.warn "`cosmic-ext-tasks` has been renamed to `tasks`." pkgs.tasks;
}
