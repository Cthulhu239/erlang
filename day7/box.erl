-module(box).
-behaviour(gen_server).
-record(user,{name,age = 0,place}).

-export([start_link/0,handle_call/3]).

start_link() ->
    gen_server:start_link({local,?MODULE},?MODULE,[],[]).

init([]) ->
    user_db = ets:new(user_db, [set, public]),
    {ok, #{user_db => user_db}}.



handle_call({insert, User},_From,State) ->
   ets:insert(State#{user_db := User#user.name}, User),
   {reply,ok,State};


handle_call({get, Name}, _From, State) ->
    case ets:lookup(State#{user_db := UserDB}, Name) of
        [{_, User}] -> {reply, {ok, User}, State};
        [] -> {reply, not_found, State}
    end.