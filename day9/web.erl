-module(web).
-export([start/0]).
-export([receive_response/1]).

start() ->
    {ok, Socket} = gen_tcp:connect("google.com", 80, [binary, {active, false}]),
    HttpRequest = <<"GET / HTTP/1.1\r\nHost: google.com\r\n\r\n">>,
    gen_tcp:send(Socket, HttpRequest),
    receive_response(Socket).

receive_response(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("Received data: ~p~n", [Data]),
            receive_response(Socket); % Continue receiving until the connection is closed
        {error, closed} ->
            io:format("Connection closed by server.~n"),
            gen_tcp:close(Socket)
    end.