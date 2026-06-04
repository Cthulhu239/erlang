-module(chat_user).
-behaviour(gen_server).
-export([start_link/1,init/1,handle_info/2,handle_call/3,handle_cast/2,terminate/2,receiveLoop/1,send/2]).

start_link([Port,Username]) ->
    Server = list_to_atom(Username),
    gen_server:start_link({local, Server}, ?MODULE, Port, []).
    

init(Port) ->
    {ok, Socket} = gen_tcp:connect('localhost',Port,[binary,{active,false}]),
    spawn(fun() -> receiveLoop(Socket) end),
    {ok,Socket}.

handle_info({send,Data},Socket) ->
     gen_tcp:send(Socket, Data),
    {noreply, Socket};
handle_info(_Idk,Socket) ->
    {noreply,Socket}.
handle_call(_From,_Where,State)->
    {noreply,State}.
handle_cast(_Info,Socket)->
    {noreply,Socket}.
terminate(_Reason, Socket) ->
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

send(Data,Username) ->
    NewUser = list_to_atom(Username),
    NewUser ! {send,Data}.






