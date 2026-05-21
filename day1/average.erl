-module(average).
-export([average/1,summ/1]).
-import(reversing_list, [len/1]).

average(List) ->
    summ({List,0})/len(List).

summ({List, Sum}) ->
    case {List,Sum} of
        {[],Sum} -> Sum;
        {[Head | Tail],Sum}->
            summ({Tail,Sum + Head}) %tail recursion
    end.    
    
