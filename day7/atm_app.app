{application, atm_app,
 [{description, "ATM Bank Application"},
  {vsn, "1.0"},
  {modules, [atm, atm_sup, atm_app]},
  {registered, [atm, atm_sup]},
  {applications, [kernel, stdlib]},
  {mod, {atm_app, []}}]}.