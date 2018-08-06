function timedTopUp(varargin)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/timedTopUp.m 1.2.1.2 2007/07/06 15:58:32CST Tasha Summers (summert) Exp  $
% ----------------------------------------------------------------------------------------------

% time: time interval for injections in seconds
% mAmax: limit on amount of stored current
% gun trigger: TRG2400:enable:Gun
% storage ring injection triggers: TRG2400:enable:Storage

if length(varargin)==0
    time=input('Time interval (seconds): ');
    disp('');
    mAmax=input('Maximum stored current (mA): ');
    disp('');
elseif length(varargin)==2
    time=varargin(1);
    mAmax=varargin(2);
else
    disp('Incorrect input parameters.\n');
    disp('nUse either timedTopUp with no arguments \n');
    disp('or timedTopUp(secondsinterval,mAmax)');
end

% Check if communication is open to gun trigger - if not, then do it
[h numopen] = mcagethandle('TRG2400:enable:Gun')
if numopen == 0
    hGunTrig = mcaopen('TRG2400:enable:Gun');
    if hGunTrig == 0
        error(['Error opening TRG2400:enable:Gun']);
    end
else
    hGunTrig = h(1);
end
% Check if communication is open to SR injection trigger - if not, then do it
[h numopen] = mcagethandle('TRG2400:enable:Storage')
if numopen == 0
    hSrInjTrig = mcaopen('TRG2400:enable:Storage');
    if hSrInjTrig == 0
        error(['Error opening TRG2400:enable:Storage']);
    end
else
    hSrInjTrig = h(1);
end
% Check if communication is open to SR pct - if not, then do it
[h numopen] = mcagethandle('PCT140201:mA:fbk')
if numopen == 0
    hSrCur = mcaopen('PCT140201:mA:fbk');
    if hSrCur == 0
        error(['Error opening PCT140201:mA:fbk']);
    end
else
    hSrCur = h(1);
end

done = 0; %while loop flag
while done < 1
    curr = mcaget(hSrCur);
    % if current is less than 5 mA, do not allow injection, break loop
    if curr < 5
        mcaput(hGunTrig,0);
        mcaput(hSrInjTrig,0);
        fprintf('Current too low, shutting off gun and triggers');
        done = 1;
    else
        curr = mcaget(SrCur);
        if curr > mAmax
            %do nothing - current is high enough already
        else
            %turn on kickers with SrInjTrig, turn on gun for 1 second
            mcaput(hSrInjTrig,1);
            mcaput(hGunTrig,1);
            pause(1);            
            mcaput(hGunTrig,0);
            mcaput(hSrInjTrig,0);
            fprintf('Injection at %s, SR1 current: %4.2f \n',datestr(now),mcaget(hSrCur));
        end
        %wait for predetermined time interval and loop again
        pause(time);
    end        
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/timedTopUp.m  $
% Revision 1.2.1.2 2007/07/06 15:58:32CST Tasha Summers (summert) 
% 
% Revision 1.2.1.1 2007/07/06 10:42:52GMT-06:00 Tasha Summers (summert) 
% Initial revision
% Member added to project e:/Projects/matlab/project.pj
% Revision 1.2 2007/03/13 09:08:46CST summert 
% 
% Revision 1.4 2007/03/05 16:31:27CST summert 
% 
% Revision 1.3 2007/03/02 11:14:44CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
