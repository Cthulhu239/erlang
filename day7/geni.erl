-module(geni).
-behaviour(gen_server).
-export([start_link/0, init/1, handle_call/3, handle_cast/2, main/0]).


start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE,[], []).

init([]) ->
    {ok,[]}.

handle_call({add, X}, _From, State) ->
    {reply, ok, [X|State]};

handle_call({get, N}, _From, State) ->
    {reply, lists:sublist(State, N), State}.

handle_cast(_Msg, State) ->
    {noreply, State}.
main() ->
    start_link(),
    gen_server:call(?MODULE, {add, 1}),
    gen_server:call(?MODULE, {add, 2}),
    gen_server:call(?MODULE, {add, 3}),
    io:format("~p~n", [gen_server:call(?MODULE, {get, 2})]).