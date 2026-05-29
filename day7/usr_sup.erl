-module(usr_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    UsrChild = {usr, {usr, start_link, []},
               permanent, 2000, worker, [usr]},
    {ok, {{one_for_all, 1, 1}, [UsrChild]}}.
