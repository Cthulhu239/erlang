-module(benchmark).
-export([start/1, start_proc/2]).

start(Num) ->
  start_proc(Num, self()).
start_proc(0, Pid) ->
  Pid ! ok;
start_proc(Num, Pid) ->
  NPid = spawn(benchmark, start_proc, [Num-1, Pid]),
  NPid ! ok,
  receive ok -> ok end.

%timer:tc(benchmark, start, [100000]). 
% It returns a tuple containing the time in microseconds it took to run the function 
%alongside the return value of the function. 