-module(in_out).
-export([funn/0]).

funn() ->
    io:format("checking....\n"),
    Input = io:get_line("anything:"), % get line returns a string/ list of characters
    io:format("you entered: ~w~n", [Input]),
    Input2 = io:read("anything:"), %gets proper data type
    io:format("you entered: ~w~n", [Input2]).

%format is similar to printf in c,
% ~w is a placeholder for any data type,
%  and it will be replaced by the value
%  of the variable in the list that follows it.
%  ~n is a newline character.