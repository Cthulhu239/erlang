-module(linking).
-export([linked/0, do_something/0, terminate/1, main/0]).

terminate(Pid) ->
    io:format("Parent (~p) sending untrappable kill to Child (~p)~n", [self(), Pid]),
    exit(Pid, kill).

do_something() ->
    receive
        {Pid, Msg} ->
            io:format("Child (~p) received ~p from ~p~n", [self(), Msg, Pid]),
            %% Keep the child alive by looping so the kill signal strikes an active process
            do_something() 
    end.

linked() ->
    Pid2 = spawn_link(linking, do_something, []),
    Pid2 ! {self(), "Hello"},
    
    %% Give the child time to print its text buffer
    timer:sleep(50),
    
    terminate(Pid2).
    
    %% Keep the parent alive long enough to receive the backfire signal
    %timer:sleep(500).

main() ->
    %% CRITICAL CHANGE: 
    %% Instead of registering a background pid, we pull the execution of 'linked' 
    %% directly into the current shell process context.
    process_flag(trap_exit, true), %trap exit prevents the shell from crashing when the linked process dies
    linked().
