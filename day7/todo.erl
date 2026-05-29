-module(todo).
-behaviour(gen_server).
-record(todo, {name,completed = false}).
-export([start_link/0, init/1, handle_call/3, handle_cast/2, main/0]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    {ok,[]}.

handle_call({add,Name},_From, State) ->
    {reply,ok,[#todo{name=Name} | State]};

handle_call({complete,Name},_From,State) ->
    UpdatedState = lists:map(fun(Todo) ->
        case Todo#todo.name of
            Name -> Todo#todo{completed=true};
            _ -> Todo
        end
    end, State),
    {reply,ok,UpdatedState};

handle_call({get, Completed}, _From, State) ->
    Filtered = lists:filter(fun(Todo) -> Todo#todo.completed =:= Completed end, State),
    {reply, Filtered, State};

handle_call({all,_},_From,State) ->
    {reply, State, State};

handle_call({remove,Name},_From,State) ->
    UpdatedState = lists:filter(fun(Todo) -> Todo#todo.name =/= Name end,State),
    {reply,ok,UpdatedState}.

handle_cast(_Msg, State) ->
    {noreply, State}.



main() ->
    start_link(),
    gen_server:call(?MODULE, {add, "Buy groceries"}),
    gen_server:call(?MODULE, {add, "Clean the house"}), %sends a synchronous message to the server and waits for a reply
    gen_server:call(?MODULE, {add, "Pay bills"}),
    gen_server:call(?MODULE, {complete, "Clean the house"}),
    gen_server:call(?MODULE, {remove, "Buy groceries"}),
    io:format("Completed tasks: ~p~n", [gen_server:call(?MODULE, {get, true})]),
    io:format("Pending tasks: ~p~n", [gen_server:call(?MODULE, {get, false})]),
    io:format("All tasks: ~p~n", [gen_server:call(?MODULE, {all,idk})]).