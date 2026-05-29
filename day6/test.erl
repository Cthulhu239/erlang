-module(test).
-export([main/0, proc1/0, proc2/0]).

proc1() ->
    receive
        {FromNode, Msg} ->
            io:format(" Process 1 received: '~s' from ~p~n", [Msg, FromNode]),
            
            %%  {RecipientName, RecipientNode} ! {SendingNode, Message}
            {process_2, FromNode} ! {node(), "Hello from process 1!"},
            proc1()
    end.

proc2() ->
    receive
        {FromNode, Msg} ->
            io:format(" Process 2 received: '~s' from ~p~n", [Msg, FromNode]),
            
            %%  {RecipientName, RecipientNode} ! {SendingNode, Message}
            {process_1, FromNode} ! {node(), "Hello from process 2!"},
            proc2()
    end.


main() -> ok.