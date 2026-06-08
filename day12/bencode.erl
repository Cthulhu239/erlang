-module(bencode).
-export([parse/1]).

parse(<<"i",Rest/binary>>) ->
   [IntBinary, RestBinary] = binary:split(<<Rest/binary>>,<<"e">>),
   Integer = binary_to_integer(IntBinary),
   {Integer,RestBinary};
parse(<<Data/binary>>) ->
   [LenBinary, RestBinary] = binary:split(<<Data/binary>>,<<":">>),
   Length = binary_to_integer(LenBinary),
   <<ToString:Length/binary, Rest/binary>> = RestBinary,
   String = binary_to_list(ToString),
   {String,Rest};
parse(<<"l",Rest/binary>>) ->
    [List, Data] = binary:split(Rest, <<"e">>),
    NewList = binary_to_list(List),
    {NewList,Data}.

    