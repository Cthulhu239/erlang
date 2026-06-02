-module(prac).
-behaviour(gen_server).

%% 1. ALL required behaviour callbacks must be explicitly exported
-export([start_link/0, init/1, handle_call/3, handle_cast/2, terminate/2]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    %% Start with an empty list state []
    {ok, []}.

%% 2. The missing handle_call body must exist to prevent runtime undef crashes!
handle_call(test_message, _From, State) ->
    {reply, wrapped_ok, State};

%% Catch-all for any other synchronous calls
handle_call(_Request, _From, State) ->
    {reply, unhandled, State}.

%% 3. Added missing contract placeholders to silence compiler warnings
handle_cast(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.