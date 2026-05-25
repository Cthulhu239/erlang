-module(freq).
-export([register/2, get/3]).


register({Type, Id, Description}, List) ->
    [ {Type, Id, Description} | List ].


get(Id,Count,List)->
    case List of
        [] -> Count;
        [{_,Id,_} | Tail] -> get(Id, Count + 1, Tail);
        [_ | Tail] -> get(Id, Count, Tail)
    end.





