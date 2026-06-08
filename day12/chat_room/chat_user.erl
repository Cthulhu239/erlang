-module(chat_user).
-behaviour(gen_server).
-export([start_link/1,init/1,handle_info/2,handle_call/3,handle_cast/2,terminate/2,receiveLoop/1,send/2,broadcast/2,to_user/3]).

start_link([Port,Username]) ->
    Server = list_to_atom(Username),
    gen_server:start_link({local, Server}, ?MODULE, [Port,Username], []).
    

init([Port,Username]) ->
    {ok, Socket} = gen_tcp:connect('localhost',Port,[binary,{active,false}]),
    UserBinary = list_to_binary(Username),
    JoinPayload = <<"JOIN:", UserBinary/binary>>,
    gen_tcp:send(Socket,JoinPayload),
    spawn(fun() -> receiveLoop(Socket) end),
    {ok,{Socket,Username}}.
handle_info({broadcast,Data},State) ->
    {Socket,Username} = State,
    BinUser = list_to_binary(Username),
    BinData = list_to_binary(Data),
    NewData = <<"broadcast:",BinUser/binary, ":", BinData/binary,"~n">>,
    gen_tcp:send(Socket, NewData),
    {noreply, State};
handle_info({send,Data},State) ->
    {Socket,Username} = State,
    BinUser = list_to_binary(Username),
    BinData = list_to_binary(Data),
    NewData = <<BinUser/binary, ":", BinData/binary,"~n">>,
    gen_tcp:send(Socket, NewData),
    {noreply, State};
handle_info({send_to,Data},State) ->
    {Socket,_Username} = State,
    gen_tcp:send(Socket,Data),
    {noreply,State};
handle_info(_Idk,State) ->
    {noreply,State}.
handle_call(_From,_Where,State)->
    {noreply,State}.

handle_cast(_Info,State)->
    {noreply,State}.
terminate(_Reason, State) ->
    {Socket,_} = State,
    gen_tcp:close(Socket),
    ok.  
receiveLoop(Socket) ->
    case gen_tcp:recv(Socket,0) of
        {ok, Data} ->
            io:format("~p~n",[Data]),
            receiveLoop(Socket);
        {error,closed} ->
            gen_tcp:close(Socket),
            io:format("disconnected due to error")
    end.   

send(Username,Data) ->
    UserProcess = list_to_atom(Username),
    UserProcess ! {send,Data}.

broadcast(Username,Data) ->
    UserProcess = list_to_atom(Username),
    UserProcess ! {broadcast,Data}.

to_user(From_user, To_user, Data) ->
    BinFrom_user = list_to_binary(From_user),
    UserProcess = list_to_atom(From_user),
    BinTo_user = list_to_binary(To_user),
    NewD = list_to_binary(Data),
    NewData = <<"send_to:",BinTo_user/binary,"by:",BinFrom_user/binary,":",NewD/binary>>,
    UserProcess ! {send_to,NewData}.






