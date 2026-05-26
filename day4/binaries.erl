-module(binaries).
-export([main/0]).

main() ->
    Bin = <<1,2,3>>,
    <<A:8, B:8, C:8>> = Bin, %pattern matching 
    io:format("A: ~p, B: ~p, C: ~p~n", [A,B,C]).
  %% Binaries are a compact way to represent data, 
  %% especially when dealing with IO or network communication.
  %<<_>> entities are alloted 8 bits by default, but we can specify the size and type of each segment.