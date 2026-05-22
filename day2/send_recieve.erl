-module(send_recieve).
-export([p1/0,ping/1,pong/1]).

% for sending -> Pid ! Message
% for receiving -> receive -> to receive messages from the mail box

ping(Pid)->
    Pid ! "message sent". %sent to the mailbox of the process with Pid
pong(0)->ok;
pong(Count)->
    receive %process waits here until it receives a message in its mailbox
        Message->
            io:format("Message recieved: ~p~n", [Message]) %receives the message from the mailbox and prints it
    end,
    ping(self()),
    pong(Count - 1).  

p1() ->
    Pid = spawn(send_recieve,pong,[5]),
    ping(Pid).