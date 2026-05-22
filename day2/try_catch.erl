-module(try_catch).
-export([foo/0,another/1]).

% common error types -> error, exit, throw
% error -> runtime errors
% exit  -> when a process is killed
% throw -> when an exception is explicitly thrown

% try_catch() ->
%     try
%         10 div 0
%     of % when execution succeeds
%         Result -> Result
%     catch % when execution fails
%         error:badarith ->
%             "Cannot divide by zero"
%     end.

foo() ->
    try
        throw(my_error)
    catch
        throw:my_error ->
            "Custom error occurred"
    end.

another(Parameter) ->
    try
        case Parameter of
            0 -> throw(zero);
            1 -> throw(one);
            _ -> "All good"
        end
    catch
        _:zero ->
            "Parameter cannot be zero";
        _:one ->
            "Parameter cannot be one"
    end.


