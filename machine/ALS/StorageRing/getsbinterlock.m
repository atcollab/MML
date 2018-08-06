function Out = getsbinterlock(Sector)
%GERSBINTERLOCK
%  Out = getsbinterlock(Sector)
%
%  INPUTS
%  1. Sector  {Default: [4; 8; 12]}
%
%  OUTPUTS
%  1. Structure (or an array of structures)
%     Out.y1              - gety([Sector 5])
%     Out.y2              - gety([Sector 6])
%     Out.y1Limit         - Y1 > LIMIT 
%     Out.y2Limit         - Y2 > LIMIT 
%     Out.yDeltaLimit     - Y1-Y2 
%     Out.x1              - getx([Sector 5])
%     Out.x2              - getx([Sector 6])
%     Out.x1Limit         - X1 > LIMIT 
%     Out.x2Limit         - X2 > LIMIT 
%     Out.xDeltaLimit     - X1-X2 
%     Out.InterlockArmed  - INTLK ARMED 
%     Out.BPMOK           - BPM OK 
%     Out.InterlockClosed - INTLK CLOSED 
%     Out.PositionOK      - POSITION OK 
%     Out.ArmedOnCurrent  - CURRENT > SP 
%

%  Written by Greg Portmann


if nargin < 1
    Sector = [4; 8; 12];
end

if size(Sector, 2) > 1
    Sector = Sector(:,1);
end

if size(Sector, 1) > 1
    for i = 1:length(Sector)
        Out(i,1) = getsbinterlock(Sector(i));
    end
    return
end


Out.Sector          = Sector;
Out.y1              = gety([Sector 5]);
Out.y2              = gety([Sector 6]);
Out.y1Limit         = getpv(sprintf('SR%02dC___BPMB___BM00', Sector)); %  Y1 BPM4 > LIMIT 
Out.y2Limit         = getpv(sprintf('SR%02dC___BPMB___BM01', Sector)); %  Y2 BPM5 > LIMIT 
Out.yDeltaLimit     = getpv(sprintf('SR%02dC___BPMB___BM02', Sector)); %  Y1-Y2 
Out.x1              = getx([Sector 5]);
Out.x2              = getx([Sector 6]);
Out.x1Limit         = getpv(sprintf('SR%02dC___BPMB___BM03', Sector)); %  X1 BPM4 > LIMIT 
Out.x2Limit         = getpv(sprintf('SR%02dC___BPMB___BM04', Sector)); %  X2 BPM5 > LIMIT 
Out.xDeltaLimit     = getpv(sprintf('SR%02dC___BPMB___BM05', Sector)); %  X1-X2 
Out.InterlockArmed  = getpv(sprintf('SR%02dC___BPMB___BM06', Sector)); %  INTLK ARMED 
Out.BPMOK           = getpv(sprintf('SR%02dC___BPMB___BM07', Sector)); %  BPM OK 
Out.InterlockClosed = getpv(sprintf('SR%02dC___BPMB___BM08', Sector)); %  INTLK CLOSED 
Out.PositionOK      = getpv(sprintf('SR%02dC___BPMB___BM09', Sector)); %  POSITION OK 
Out.ArmedOnCurrent  = getpv(sprintf('SR%02dC___BPMB___BM11', Sector)); %  CURRENT > SP 


