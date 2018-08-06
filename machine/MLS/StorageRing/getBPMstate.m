%getBPMstate - List all BPM States
%  SYNTAX:
%	getBPMstate
%  Example:
%  	getBPMstate
%
%  INPUTS:
%       NONE
%
%  OUTPUT: 
%       List all BPM States
%
%  Written by Dennis Engel

function getBPMstate
x = getfamilydata('BPMx');
y = getfamilydata('BPMy');
fsprintf('\tX\t\tState\t|\tY\t\tState\n');

for i=1:size(x.Status)
    xname  = x.Monitor.ChannelNames(i,:);
    xstate = x.Status(i);
    yname  = y.Monitor.ChannelNames(i,:);
    ystate = y.Status(i);
    fprintf('\t%s\t%d\t|\t%s\t%d\n',xname, xstate, yname, ystate);
end


  
