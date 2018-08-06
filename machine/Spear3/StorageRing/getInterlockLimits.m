function [xlim,xplim,ylim,yplim] = getinterlocklimits(elemlist);  
%[xlim,xplim,ylim,yplim] = getinterlocklimits(varargin);  
%load interlock phase space limits

if nargin==0
    elemlist=dev2elem('BPLD',getlist('BPLD',[]));
end
    

BPLD=getfamilydata('BPLD');

xlim =BPLD.x(elemlist);
xplim=BPLD.xp(elemlist);
ylim =BPLD.y(elemlist);
yplim=BPLD.yp(elemlist);

