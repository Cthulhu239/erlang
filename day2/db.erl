-module(db).

% Interface:
% db:new()                        
% db:destroy(Db)                  
% db:write(Key, Element, Db)      
% db:delete(Key, Db)              
% db:read(Key, Db)                
% db:match(Element, Db)           
% Example:
% 1> c(db).
% {ok,db}
% ⇒ Db.
% ⇒ ok.
% ⇒ NewDb.
% ⇒ NewDb.
% ⇒{ok, Element} | {error, instance}.
% ⇒ [Key1, ..., KeyN]

-export([new/0,destroy/1,write/3,read/2,view/1]).

new() ->
    [].

destroy(Db) ->
    Db = [],
    ok.

write(Key,Value,Db) ->
    Pair = {Key, Value},
    [Pair | Db].

read(Key, Db) ->
    case Db of
      [] -> -1;
      [{Key, Value} | _] -> {ok,Value};
      [_ | Tail] -> read(Key, Tail)
    end.

view(Db) ->
    io:format("~p~n", [Db]),
    ok.



