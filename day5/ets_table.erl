-module(ets_table).
-export([main/0, traverse/2]).

main() ->
    Table = ets:new(my_table, [set, public]),
    ets:insert(Table, {1, "Alice"}),
    ets:lookup(Table, 1),
    
    Tab2 = ets:new(my_table2, [duplicate_bag, public]),
    ets:insert(Tab2, {1, "Bob"}),
    ets:insert(Tab2, {1, "Bob"}),
    ets:insert(Tab2, {1, "Alice"}),
    ets:insert(Tab2, {2, "idk"}),
    FirstKey = ets:first(Tab2),
    traverse(Tab2, FirstKey),
    Result = ets:match(Tab2,{'$0', "Bob"}),
    io:format("Match result: ~p~n", [Result]),
    ets:lookup(Tab2, 1).

traverse(_TableId, '$end_of_table') -> 
    ok;
traverse(TableId, CurrentKey) ->
    Rows = ets:lookup(TableId, CurrentKey),
    
    io:format("Key: ~p -> Rows: ~p~n", [CurrentKey, Rows]),
    NextKey = ets:next(TableId, CurrentKey),
    traverse(TableId, NextKey).