-module(atm_app).
-behaviour(application). %% Tells Erlang this is an Application controller

-export([start/2, stop/1]).

%% This runs automatically when you run application:start(atm_app)
start(_StartType, _StartArgs) ->
    %% It boots your top-level supervisor, which automatically boots the ATM worker!
    atm_sup:start_link().

%% This runs automatically when you run application:stop(atm_app)
stop(_State) ->
    ok.