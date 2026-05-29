-module(store).
-export([search_by_key/2, store/3, delete/2,loop/1,create_process/0]).
-record(address, {key, value}).

search_by_key(Key, List) ->
    case List of
        [] ->
            io:format("Key not found~n"),
            not_found;
        [#address{key = Key, value = Value} | _ ] ->
            io:format("Found value: ~p~n", [Value]),
            Value;
        [_ | Tail] ->
            search_by_key(Key, Tail)
    end.


store(Key,Value,List) ->
    [#address{key = Key, value = Value} | List].

delete(Key,List) ->
    lists:keydelete(Key, #address.key, List).


loop(List) ->
    receive
        {store, Key, Value} ->
            io:format("Storing key: ~p with value: ~p~n", [Key, Value]),
            NewList = store(Key,Value,List),
            loop(NewList);
        {search, Key} ->
            io:format("Searching for key: ~p~n", [Key]),
            NewList = search_by_key(Key,List),
            loop(NewList);
        {delete, Key} ->
            io:format("Deleting key: ~p~n", [Key]),
            NewList = delete(Key,List),
            loop(NewList)
    end.

create_process() ->
    spawn(store, loop, [[]]).


