-module(usr_db).
-include("usr.hrl").
-export([create_tables/1, close_tables/0]).


create_tables(FileName) ->
  ets:new(usrRam, [named_table, {keypos, #usr.msisdn}]),
  ets:new(usrIndex, [named_table]),
  dets:open_file(usrDisk, [{file, FileName}, {keypos, #usr.msisdn}]).
close_tables() ->
  ets:delete(usrRam),
  ets:delete(usrIndex),
  dets:close(usrDisk).