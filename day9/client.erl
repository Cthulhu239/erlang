-module(client).
-export([deliver/0]).

deliver() ->
    {ok, Socket} = gen_tcp:connect("localhost",1234, [binary, {active, false}]),
    io:format("Connected to server!~n"),
    gen_tcp:send(Socket, <<"Hello, Server!">>),
    gen_tcp:close(Socket).