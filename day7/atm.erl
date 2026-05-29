-module(atm).
-behaviour(gen_server).
-export([start_link/0, init/1, handle_call/3, handle_cast/2, terminate/2]).
-export([open_account/0, withdraw/1, deposit/1, balance/0]).


open_account() ->
    start_link().

withdraw(Amount) ->
    gen_server:call(?MODULE,{withdraw,Amount}).

deposit(Amount) ->
    gen_server:call(?MODULE,{deposit,Amount}).

balance() ->
    gen_server:call(?MODULE,{balance}).

start_link() ->
    gen_server:start_link({local,?MODULE},?MODULE,[],[]).

init([]) ->
    {ok,0}.

handle_call({deposit,Amount}, _From,Balance) ->
    {reply,ok,Balance + Amount};

handle_call({withdraw,Amount}, _From,Balance) ->
    if Amount > Balance ->
        {reply, {error,insufficient_funds},Balance};
    true ->
        {reply,ok,Balance - Amount}
    end;

handle_call({balance}, _From, Balance) ->
    {reply,Balance,Balance}.

handle_cast(_Msg, Balance) ->
    {noreply, Balance}.

terminate(_Reason, _Balance) ->
    ok.
