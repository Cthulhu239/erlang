-module(listss).
-import(functions, [factorial/1]).
-export([foo/0]).

% so lists are basically linked lists (not arrays)
% so they can be accessed only from head
% eg [1,2,3,4,5] ,head is 1 and tail is [2,3,4,5]

foo() ->
    factorial(5). %using the function from functions module

listing() ->
    list1 = [1],
    


