-module(record).
-define(TIMEOUT,5000).
-export([main/0,loop/1]).
-include("header.hrl").


%record are just readable named wrappers around tuples.
%or just a tuple with named fields
%macros is just like #define in C

loop(Record) ->
    receive
        {Msg,#person{} = Record} ->
            io:format("Received ~p~n from ~p", [Msg, Record]),
            loop(Record)
        after ?TIMEOUT ->
            io:format("No message received in ~p ms~n", [?TIMEOUT])
    end.    


main() ->
    P1 = #person{
        name = "Alice",
        age = 30,
        info = #info{
            city = "New York",
            occupation = "Engineer"
        }
    },
    io:format("name: ~p, age: ~p~n", [P1#person.name, P1#person.age]),
    io:format("~p~n",[?FILE]), %?MODULE, ?LINE, ?FUNCTION, ?CALLER, ?STACKTRACE are other useful macros
    register(proc1, spawn(record, loop, [P1])),
    timer:sleep(100),
    proc1 ! {"Hello",P1}.

%rr(record). -> read record definition from the file and print it in the shell
%record_info(fields, record). -> print the field names of the record