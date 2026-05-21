-module(functions).
-export([area/1,factorial/1]).
% no. of parameters -> arity
% arguemenrs matched with -> pattern matching
% func name is atom
%atoms are constants whose value is their own name

area(Parameter) ->
    case Parameter of
        {square, Side} -> Side * Side;
        {rectangle, Length, Breadth} -> Length * Breadth;
        {circle, Radius} -> 3.14 * Radius * Radius;
        _ -> "Invalid shape"
    end.


fibonacci() ->0;
fibonacci(1) ->1;





factorial(0)->1;
factorial(N)->
    N * factorial(N - 1).

%pattern matching happens in order of function definition
% i.e. top to bottom and left to right