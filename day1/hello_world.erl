-module(hello_world).
-export([add/2, area/2, test/0]).

add(A, B) ->
    A + B.

area(square, Side) ->
    Side * Side.

test() ->
    Tup1 = {testing,everything,1,2,3},
    Lis1 = [testing,everything,1,2,3],
    io:format("~p~n", [Tup1]),
    io:format("~p~n", [Lis1]).
