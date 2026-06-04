-module(server).
-behaviour(gen_server).

%% API
-export([start_link/1, stop/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

%% Our server state holds the listening socket and the list of active user sockets
-record(state, {
    listen_socket,
    user_sockets = []
}).

start_link(Port) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Port], []).

stop() ->
    gen_server:call(?MODULE, stop).

init([Port]) ->
    %% Bind to the TCP port. {active, false} means we manually pull data via recv.
    case gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]) of
        {ok, ListenSocket} ->
            io:format("Chat Server started on port ~p...~n", [Port]),
            %% Spawn an independent background process to accept connections
            spawn_link(fun() -> accept_loop(ListenSocket) end),
            {ok, #state{listen_socket = ListenSocket}};
        {error, Reason} ->
            {stop, Reason}
    end.

%% --- Connection Acceptor Loop ---
accept_loop(ListenSocket) ->
    %% This blocks until a new client (like your user module) connects
    case gen_tcp:accept(ListenSocket) of
        {ok, ClientSocket} ->
            %% Register the new socket with our central master server process
            gen_server:cast(?MODULE, {register_user, ClientSocket}),
            
            %% Spawn an isolated worker process to continuously read from this specific user
            spawn(fun() -> client_reader_loop(ClientSocket) end),
            
            %% Instantly loop back around to wait for the NEXT user connection
            accept_loop(ListenSocket);
        {error, _Reason} ->
            ok
    end.

%% --- Individual Client Reader Process Loop ---
client_reader_loop(ClientSocket) ->
    case gen_tcp:recv(ClientSocket, 0) of
        {ok, Data} ->
            %% Caught a message from this user! Cast it to the central manager to broadcast
            gen_server:cast(?MODULE, {broadcast, ClientSocket, Data}),
            client_reader_loop(ClientSocket);
        {error, closed} ->
            %% User disconnected, tell the server to remove their socket from the ledger
            gen_server:cast(?MODULE, {deregister_user, ClientSocket})
    end.

%% --- Gen_Server Broadcast & Management Callbacks ---

handle_call(stop, _From, State) ->
    {stop, normal, ok, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({register_user, Socket}, State) ->
    NewSockets = [Socket | State#state.user_sockets],
    io:format("New user joined. Total users: ~p~n", [length(NewSockets)]),
    {noreply, State#state{user_sockets = NewSockets}};

handle_cast({deregister_user, Socket}, State) ->
    NewSockets = lists:delete(Socket, State#state.user_sockets),
    io:format("User left. Total users: ~p~n", [length(NewSockets)]),
    {noreply, State#state{user_sockets = NewSockets}};

%% 🎯 THE BROADCAST ENGINE
handle_cast({broadcast, SenderSocket, Data}, State) ->
    %% Iterate through every single socket saved in our state list
    lists:foreach(
        fun(TargetSocket) ->
            %% Optional check: ofn't mirror the text back to the person who sent it
            if 
                TargetSocket =/= SenderSocket ->
                    gen_tcp:send(TargetSocket, Data);
                true -> 
                    ok
            end
        end,
        State#state.user_sockets
    ),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, State) -> 
    gen_tcp:close(State#state.listen_socket),
    ok.