-module(info).

% atoms are not garbage collected, as they are stored in a global atom table. 
%whereis(Atom) -> Pid/undefined
%best practice is to register only long lived processes, as atoms are not garbage collected.
%DeadPid ! hello does not cause an error, the message is just lost.
% atom ! message, if the atom is not registered, badarg exception (registered processes are deemed important)
% to prevent the above error, try catch can be used

