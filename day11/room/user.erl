-module(user).
-behaviour(gen_server).

-export([start_link/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, send/2, recv_loop/1, join/2]).

%% 1. Changed to Capital 'Username' variable
start_link([Port, User, Username]) ->
    gen_server:start_link(
        {local, Username}, %% Registers process dynamically as 'Kushan'
        ?MODULE,
        [Port, User],
        []
    ).

init([Port, User]) ->
    {ok, Socket} = gen_tcp:connect(
        "localhost",
        Port,
        [binary, {active, false}]
    ),
    io:format("Connected to server on port ~p!~n", [Port]),
    
    spawn(fun() -> recv_loop(Socket) end),
    
    UserBinary = list_to_binary(User),
    JoinMsg = <<"User: ", UserBinary/binary, " has joined the chat!~n">>,
    gen_tcp:send(Socket, JoinMsg),
    
    {ok, Socket}.

handle_call(_Request, _From, Socket) ->
    {reply, ok, Socket}.

handle_cast(_Msg, Socket) ->
    {noreply, Socket}.

handle_info({send, Data}, Socket) ->
    gen_tcp:send(Socket, Data),
    {noreply, Socket};
handle_info(_Info, Socket) ->
    {noreply, Socket}.

terminate(_Reason, Socket) ->
    gen_tcp:close(Socket),
    ok.

%% 2. Updated send/2 so you can specify WHO is talking (e.g., user:send("Kushan", "Hi"))
send(UsernameStr, Data) ->
    BinaryData = list_to_binary(Data),
    UsernameAtom = if 
        is_atom(UsernameStr) -> UsernameStr;
        is_list(UsernameStr) -> list_to_atom(UsernameStr)
    end,
    UsernameAtom ! {send, BinaryData}.

recv_loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("~s", [Data]),
            recv_loop(Socket);
        {error, closed} ->
            io:format("Connection closed by server.~n");
        {error, closed} ->
            io:format("Socket error: ~p~n", [Reason])
    end.

%% 3. Fixed: Capitalized 'Username' variable assigns perfectly now!
join(Port, User) ->
    Username = list_to_atom(User),
    start_link([Port, User, Username]).
