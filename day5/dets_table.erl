-module(dets_table).

-export([main/0]).

main() ->
    {ok, Table} = dets:open_file(my_dets_table, []),
    dets:insert(Table, {1, "Alice"}),
    dets:insert(Table, {2, "Bob"}),
    Val = dets:lookup(Table, 1),
    io:format("Lookup result for key 1: ~p~n", [Val]),
    dets:lookup(Table, 2),
    dets:close(Table).