-module(reversing_list).
-export([reverse/1,len/1]).
%no loops, only recursion
% foo() ->
%     List1 = [1,2,3,4,5],
%     reverse(List1).

reverse(List) ->
    case List of
        [] -> [];
        [Head | Tail] ->
            reverse(Tail) ++ [Head]
    end.    


% _ does not store the value,
% it is a placeholder for any value 
% and it cannot be used later in the function.
% It is often used when we want to ignore a value
% or when we want to indicate that a value is not important.
len([]) ->
    0;
len([_ | Tail])->
    1 + len(Tail).







