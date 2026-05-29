%remote procedure call -> a way to call a function on another node
%rpc:call(TargetNode, Module, Function, ArgsList)
-module(rc).
-export([main/0, remote_call/2]).

remote_call(Message, Node) ->
    {, Node} ! {self(), Message},

    receive
        {ok, Res} ->
            Res
    end.

main() ->
    

