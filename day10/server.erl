-module(server).
-behaviour(gen_server).
-export([start_link/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,loop/1]).

start_link(Port)->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Port, []).

init(Port)->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}]),
    io:format("Server is listening on port ~p...~n", [Port]),
    self() ! accept_next,
    
    {ok, {ListenSocket, Port}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(accept_next, State) ->
    {ListenSocket, Port} = State,
    case gen_tcp:accept(ListenSocket) of
        {ok, Socket} ->
            io:format("Client connected on port ~p!~n", [Port]),
            spawn(fun() -> loop(Socket) end), % Handle client in a separate process
            self() ! accept_next, % Continue accepting new clients
            {noreply, State};
        {error, Reason} ->
            io:format("Error accepting connection: ~p~n", [Reason]),
            {noreply, State}
    end;

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, {ListenSocket, _Port}) ->
    gen_tcp:close(ListenSocket),
    ok.


loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("Received data: ~p~n", [Data]),

            gen_tcp:send(
                Socket,
                <<"[Server Echo]: ", Data/binary>>
            ),

            loop(Socket);

        {error, closed} ->
            io:format("Connection closed by client.~n"),
            gen_tcp:close(Socket);

        {error, Reason} ->
            io:format("Socket error: ~p~n", [Reason]),
            gen_tcp:close(Socket)
    end.