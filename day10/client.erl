-module(client).

-behaviour(gen_server).

-export([
    start_link/1,
    send/1
]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2
]).

start_link(Port) ->
    gen_server:start_link(
        {local, ?MODULE},
        ?MODULE,
        Port,
        []
    ).

init(Port) ->
    {ok, Socket} =
        gen_tcp:connect(
            "localhost",
            Port,
            [binary, {active, false}]
        ),

    io:format("Connected to server on port ~p!~n", [Port]),

    %% Start receive loop once
    spawn(fun() -> recv_loop(Socket) end),
    gen_tcp:send(Socket, <<"Hello, Server!">>),

    {ok, Socket}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({send, Data}, Socket) ->
    gen_tcp:send(Socket, Data),
    {noreply, Socket};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, Socket) ->
    gen_tcp:close(Socket),
    ok.

send(Data) ->
    BinaryData =
        if
            is_binary(Data) ->
                Data;
            is_list(Data) ->
                list_to_binary(Data)
        end,

    client ! {send, BinaryData}.

recv_loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("Received: ~p~n", [Data]),
            recv_loop(Socket);

        {error, closed} ->
            io:format("Server closed connection.~n"),
            ok;

        {error, Reason} ->
            io:format("Receive error: ~p~n", [Reason]),
            ok
    end.