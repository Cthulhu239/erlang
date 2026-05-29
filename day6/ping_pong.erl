-module(ping_pong).
-export([start_worker/0, loop/0]).

start_worker() ->
    %% Registers this process with a globally accessible name locally
    register(worker_process, spawn(ping_pong, loop, [])).

loop() ->
    receive
        {FromPid, Msg} ->
            io:format("🚀 Received message: '~p' from ~p~n", [Msg, FromPid]),
            %% Send a reply back to whoever texted us
            FromPid ! {self(), "Pong! I got your message!"},
            loop();
        stop ->
            io:format("Stopping worker.~n"),
            ok
    end.