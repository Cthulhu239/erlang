-module(fun_demo).
-export([main/0]).



main() ->
    %% Anonymous functions are just like lambdas in other languages.
    %% They can be assigned to variables and passed around as first class citizens.
        Is_even = fun(X) when X rem 2 == 0 -> true;
                     (_) -> false
                  end,

    Result = lists:any(Is_even,[1,2,3,4,5]),
    Result2 = lists:dropwhile(fun(X) -> X > 3 end, [1,2,3,4,5]),
    Result3 = lists:partition(fun(X) -> X rem 2 == 0 end, [1,2,3,4,5]),
    io:format("Is there an even number in the list? ~p~n", [Result]),
    io:format("Dropping elements until we hit a non-positive number: ~p~n", [Result2]),
    io:format("Partitioning the list into even and odd numbers: ~p~n", [Result3]),
    io:format("Is 4 even? ~p~n", [Is_even(4)]),
    io:format("Is 5 even? ~p~n", [Is_even(5)]).