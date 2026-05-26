-module(comprehension).

-export([main/0, qsort/1]).

qsort([]) -> [];
qsort([X|Xs]) ->
    qsort([Y || Y<-Xs, Y =< X]) ++ [X] ++ qsort([Y || Y<-Xs, Y > X]).
    %smaller numbers of left, then pivot, then larger on right

main() ->
    L1 = [1,2,3,4,5],
    %NewList = [ Expression || Generator, Guard1, Guard2, ... ]
    L2 = [X*2 || X <- L1, X rem 2 == 0],
    L3 = [Y || Y <- L1, Y =< 3],

    io:format("Doubled even numbers: ~p~n", [L2]),
    io:format("Numbers less than or equal to 3: ~p~n", [L3]).