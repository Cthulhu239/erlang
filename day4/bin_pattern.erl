-module(bin_pattern).

-export([main/0]).

main() ->
    Bin = <<22,23,43,123,32,12>>, %6 bytes, 48 bits
    <<Protocol:8,Version:24,Payload:16>> = Bin,
    io:format("Protocol: ~p, Version: ~p, Payload: ~p~n", [Protocol, Version, Payload]).
