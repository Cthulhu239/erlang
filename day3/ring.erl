-module(ring).
-export([start/1, ring/3]).

start(N) ->
    Pid = spawn(ring, ring, [0,N,self()]),
    receive
        ok ->
            io:format("Ring completed!~n")
    end.

ring(0,N,Pid)->
    io:format("Ring!~n");
    ring(1,N);
    Pid = spawn(ring, ring, [1,N],Pid),
    Pid ! ok;
ring(M,N)->
    receive
        ok ->
            io:format("~p~n",[M]),
            Pid = spawn(ring, ring, [M + 1,N,Pid]),
            Pid ! ok,
    end;
ring(N,N,Pid)->
    spawn(ring, ring, [0,N,Pid]),
    Pid ! ok.