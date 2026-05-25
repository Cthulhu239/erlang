-module(timeout).
-export([main/0,timeout/0]).

% implementing timeout in receive block
timeout() ->
    receive Message ->
            io:format("Received message: ~p~n", [Message]),
            timeout()
    after 5000 ->
        io:format("Timeout occurred! No messages received in the last 5 seconds.~n")
    end.

main() ->
    register(timeout,spawn(timeout,timeout,[])).

%even after the process is timed out, it can still receive messages
%request-response desynchronization occurs when send receives a response after the timeout,
%if a user sends a new request but the response to the previous request arrives after the timeout,
% it can match the new request, causing incorrect behaviour

