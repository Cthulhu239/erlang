-module(socket_con).
-export([main/0]).

main() ->
    {ok, ListenSocket} = gen_tcp:listen(1234, [binary, {active, false}]),
    io:format("Server is listening on port 1234...~n"),
    {ok, AcceptedSocket} = gen_tcp:accept(ListenSocket),
    io:format("Client connected!~n"),
    {ok, Data} = gen_tcp:recv(AcceptedSocket, 0),
    io:format("Received data: ~p~n", [Data]),
    gen_tcp:close(AcceptedSocket),
    gen_tcp:close(ListenSocket).