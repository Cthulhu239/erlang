-module(mafia_db).
-include("mnesia.hrl").
-export([install/0, start/0, add_mobster/3, give_promotion/2, lookup_mobster/1]).

%% 1. Define the row structure. The 1st field (id) is automatically the Primary Key!
-record(mobster, {id, name, rank, cash = 0}).

%% ====================================================================
%% The Installer (Run this ONCE in your lifetime to prep the hard drive)
%% ====================================================================
install() ->
    %% Prepare the schema folder on the local disk
    mnesia:create_schema([node()]),
    
    %% Turn on Mnesia temporarily to carve out the table blueprints
    application:start(mnesia),
    
    %% Create the table
    mnesia:create_table(mobster, [
        {attributes, record_info(fields, mobster)}, %% Set column headers from record
        {disc_copies, [node()]}                    %% Store in RAM + backup to local Disk
    ]),
    
    %% Turn it off. Installation is finished!
    application:stop(mnesia).

%% ====================================================================
%% The Runtime Startup (Run this every time your app boots up)
%% ====================================================================
start() ->
    application:start(mnesia),
    %% Wait for tables to load from disk into RAM before accepting queries!
    mnesia:wait_for_tables([mobster], 5000).

%% ====================================================================
%% TRANSACTION WRITE (Safe Insertion)
%% ====================================================================
add_mobster(Id, Name, Rank) ->
    %% Step A: Package your logic into a functional blueprint
    WriteFun = fun() ->
        Row = #mobster{id = Id, name = Name, rank = Rank},
        mnesia:write(Row) %% Write the record directly!
    end,
    
    %% Step B: Hand the fun over to the ACID engine
    mnesia:transaction(WriteFun).

%% ====================================================================
%% TRANSACTION READ-MATCH-WRITE (Complex Workflow)
%% ====================================================================
give_promotion(Id, NewRank) ->
    PromotionFun = fun() ->
        %% Read the existing row inside a strict database lock
        case mnesia:read(mobster, Id) of
            [CurrentMobster] ->
                %% Modify the record field state
                UpdatedMobster = CurrentMobster#mobster{rank = NewRank},
                %% Overwrite the old row data
                mnesia:write(UpdatedMobster),
                promoted;
            [] ->
                %% Force a safe rollback if the user doesn't exist
                mnesia:abort(mobster_not_found)
        end
    end,
    mnesia:transaction(PromotionFun).

%% ====================================================================
%% DIRTY READ (The Ultra-Fast Lane)
%% ====================================================================
lookup_mobster(Id) ->
    %% No fun block wrapper, no locks, absolute minimum overhead.
    %% Perfect for high-speed reads where an occasional millisecond race condition won't break things.
    mnesia:dirty_read(mobster, Id).
