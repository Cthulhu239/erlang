% processes in erl are lightweight
% it does not use OS threads, but the BEAM VM schedules them internally
% BEAM multiplexes MANY Erlang processes over a smaller number of OS threads.
% it has it's own scheduler inside the VM(BEAM)
% each process is isolated (separate memory)
% each process has it's own heap so GC is independent
% communications bw processes happen via message passing
% i(). shows the currenly running processes

% each process has a mail box where incoming messages are stored
% message passing is asynchronous
% Pid ! Message -> to send message to a process
% receive -> to receive messages from the mail box

% reductions are a measure of how much work a process has done
% the erlang VM(BEAM) uses reductions for process scheduling
% typically a process gets around 2000 reductions before it is preempted
%  and another process gets a chance to run
-module(proc).
-export([start/0, hello/0,add/2,proc_add/2]).

hello() ->
    io:format("Hello from process~n").

start() ->
    spawn(process_demo, hello, []).

add(A, B) ->
    io:format("Result = ~p~n", [A + B]).

proc_add(A, B) ->
    spawn(proc,add,[A,B]).