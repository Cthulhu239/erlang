-module(proc2).
-export([proce/0,task/2]).

task(Var,Count) ->
    case Count of
        0 -> ok;
        _ ->io:format("~p~n",[Var]),
            task(Var,Count - 1)
    end.
    

proce() ->
   spawn(proc2,task,["Kushan",5]),
   spawn(proc2,task,["Gajbe",5]).