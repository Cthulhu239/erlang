-module(chat_server).
-behaviour(gen_server).
-record(socket,{
    username,
    user_socket
    }).

-export([start_link/1,init/1,handle_info/2,handle_cast/2,handle_call/3,terminate/2,receiveLoop/1,acceptLoop/1]).

start_link([Port,SocketList]) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Port,SocketList], []).

init([Port,SocketList]) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary,{active,false}]),
    spawn(fun() -> acceptLoop(ListenSocket) end),
    {ok, {ListenSocket,SocketList}}.

handle_info(_Info, State) -> {noreply, State}.

handle_cast({register_user,Username,NewSocket},State) ->
    {ListenSocket,SocketList} = State,
    NewSocketRecord = #socket{username = Username,user_socket = NewSocket},
    NewSocketList = [NewSocketRecord | SocketList],
    {noreply,{ListenSocket,NewSocketList}};

handle_cast({broadcast,Data},State) ->
    {_ListenSocket,SocketList} = State,
    BroadcastFun = fun(SocketRecord) ->
                       TargetSocket = SocketRecord#socket.user_socket,
                       gen_tcp:send(TargetSocket, Data)
                   end,
    lists:foreach(BroadcastFun,SocketList),
    {noreply,State};   
handle_cast({send_to,To_user,Data},State) ->
    {_ListenSocket,SocketList} = State,
    case lists:keyfind(To_user, #socket.username, SocketList) of
        #socket{user_socket = FoundSocket} ->
            gen_tcp:send(FoundSocket,Data);
        false ->
            io:format("User ~s not found online.~n", [To_user])
    end,
    {noreply,State};    

handle_cast(_Msg,State) -> {noreply,State}.

handle_call(_From,_Where,State) ->{noreply,State}.

terminate(_Reason, Socket) ->
    gen_tcp:close(Socket),
    ok.  

receiveLoop(Socket) ->
    case gen_tcp:recv(Socket,0) of
        {ok, <<"JOIN:", UsernameBinary/binary>>} ->
            %% Inform the main chat_server to link this username to this socket
            gen_server:cast(chat_server, {register_user, UsernameBinary, Socket}),
            gen_tcp:send(Socket,<<"You have joined the main chat successfully~n">>),
            io:format("~p has joined",[UsernameBinary]),
            receiveLoop(Socket);
        {ok, <<"broadcast:",Data/binary>>} ->
            gen_server:cast(?MODULE,{broadcast,Data}),
            receiveLoop(Socket);
        {ok, <<"send_to:", Rest/binary>>} ->
            [To_user, Remaining] = binary:split(Rest, <<"by:">>),
            [From_user, Data] = binary:split(Remaining, <<":">>),
            NewData = <<From_user/binary, ": ", Data/binary>>,
            gen_server:cast(?MODULE,{send_to, To_user, NewData}),
            receiveLoop(Socket);
        {ok, Data} ->
            io:format("~p~n",[Data]),
            receiveLoop(Socket);
        {error,closed} ->
            gen_tcp:close(Socket),
            io:format("disconnected due to error")
    end.    

acceptLoop(Socket) ->
    case gen_tcp:accept(Socket) of
        {ok, AcceptedSocket} ->
            spawn(fun() -> receiveLoop(AcceptedSocket) end),
            acceptLoop(Socket);
        {error,_Reason} ->
            ok
    end.    


   