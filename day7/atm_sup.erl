-module(atm_sup).
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    %% Rule 1: {Strategy, MaxCrashes, MaxSeconds}
    SupFlags = {one_for_one, 3, 10},

    %% Rule 2: {Id, {Module, Function, Args}, Restart, Shutdown, Type, Modules}
    AtmChildSpec = {
        atm_worker,                 %% Id tag
        {atm, start_link, []},      %% How to start it
        permanent,                  %% Restart rule
        5000,                       %% Shutdown timeout
        worker,                     %% Process type
        [atm]                       %% Module file name
    },

    %% Wrap them in a list just like before
    {ok, {SupFlags, [AtmChildSpec]}}.