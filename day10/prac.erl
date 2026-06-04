-module(prac).
-behaviour(gen_server).
-export([start_link/0,handle_call/3, handle_cast/2, handle_info/2, terminate/2,init/0]).'

init() ->
    {ok, Socket} = gen_tcp:listen(1234, [binary, {active, false}]),
    {ok, Socket}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

handle_call(accept, _From, State) ->
    {ok, AcceptedSocket} = gen_tcp:accept(State),
    io:format("Client connected!~n"),
    spawn(fun() -> recv_loop(AcceptedSocket) end),

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

recv_loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok,Data} ->
            io:format("Received data: ~p~n", [Data]),
            gen_tcp:send(Socket, <<"[Server Echo]: ", Data/binary>>),
            recv_loop(Socket);
