-module(comm_2way).
-export([main/0,proc1/0,proc2/0,send/2]).

%implementing 2 way comm between processes

send(Pid1,Pid2) ->
    Pid2 ! {"Hello",Pid1}.
    


proc1() ->
    receive
        {Message,From} ->
            io:format("~p received in proc1 from: ~p~n", [Message, From]),
            timer:sleep(1000),
            % send(self(),From),
            proc1()
    end.

proc2() ->
    receive
        {Message,From} ->
            io:format("~p received in proc2 from: ~p~n", [Message, From]),
            timer:sleep(1000),
            % send(self(),From),
            proc2()
    end.

main() ->
    register(proc1,spawn(comm_2way,proc1,[])), %alias the pid with an atom
    register(proc2,spawn(comm_2way,proc2,[])).
    % send(proc1,proc2).

