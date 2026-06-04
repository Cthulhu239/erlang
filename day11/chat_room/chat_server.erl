-module(chat_server).
-behaviour(gen_server).
% -record(socket,{
%     username,
%     user_socket
%     })

-export([start_link/1,init/1,handle_info/2,handle_cast/2,handle_call/3,terminate/2,receiveLoop/1,acceptLoop/1]).

start_link(Port) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Port, []).

init(Port) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary,{active,false}]),
    spawn(fun() -> acceptLoop(ListenSocket) end),
    {ok, ListenSocket}.

handle_info(_Info, State) -> {noreply, State}.

handle_cast(_Msg,State) -> {noreply,State}.

handle_call(_From,_Where,State) ->{noreply,State}.

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

acceptLoop(Socket) ->
    case gen_tcp:accept(Socket) of
        {ok, AcceptedSocket} ->
            spawn(fun() -> receiveLoop(AcceptedSocket) end),
            acceptLoop(Socket);
        {error,_Reason} ->
            ok
    end.    