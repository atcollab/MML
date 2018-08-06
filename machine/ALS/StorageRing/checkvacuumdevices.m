function checkvacuumdevices(time);

% function checkvacuumdevices(time);
%
% This function checks all ion pumps and gauges in the storage ring to
% 		determine whether their control system values are updating. It displays a
%		list of problem IPs and IGs and their corresponding ILCs (or crates).
% This routine is normally used during startups to find which vacuum device
% 		ILCs need to be reloaded.
% IP ILCs also handle the QFA shunts. They should not be reloaded, rebooted, or reset
%		during user operations as the shunts will cycle on/off and distort the beam.
% Also: if the ILC for SR03S IP/IG is touched, the RF gate valves will close.

% 2002-08-30, Tom Scarvie

if nargin < 1
    time = input('Collect data for how many minutes? (for default 3 minutes, hit return): ');
    if time < 1
        disp('Time should be at least 1 minute!');
        return    
    end
    if isempty(time)
        time = 3;
    end
    if time < 10
        time = time*60;
    else
        ans = input('That''s a pretty long time - are you sure you want to continue? (y/n) ','s');
        if ans == 'y' | ans == 'Y'
            time = time*60;
            %continue
        else
            return
        end
    end

elseif nargin > 1
    error('Checkvacuumdevices requires 1 or no input arguments.');
end

% if time < 10
%     time = time*60;
% end
% 
% if time < 60
%     disp('You should sample for longer than 1 minute.')
% elseif time > 11*60
%     disp('No real need to sample for longer than 10 minutes.')
%     return
% end

format short e

IPlist = ['SR01C___IP1____AM00     507     '     
     'SR01C___IP2____AM00     507     '
     'SR01C___IP3____AM00     507     '
     'SR01C___IP4____AM00     507     '
     'SR01C___IP5____AM00     507     '
     'SR01C___IP6____AM00     507     '
     'SR01S___IP1____AM00     506     '
     'SR01S___IP2____AM00     506     '
     'SR01S___IP3____AM00     506     '
     'SR01S___IP4____AM00     506     '
     'SR01S___IP5____AM00     506     '
     'SR02C___IP1____AM00     509     '
     'SR02C___IP2____AM00     509     '
     'SR02C___IP3____AM00     509     '
     'SR02C___IP4____AM00     509     '
     'SR02C___IP5____AM00     509     '
     'SR02C___IP6____AM00     509     '
     'SR02S___IP1____AM00     508     '
   % 'SR02S___IP2____AM00     508     '
     'SR03C___IP1____AM00     511     '
     'SR03C___IP2____AM00     511     '
     'SR03C___IP3____AM00     511     '
     'SR03C___IP4____AM00     511     '
     'SR03C___IP5____AM00     511     '
     'SR03C___IP6____AM00     511     '
     'SR03S___IP1____AM00     510     '
     'SR03S___IP2____AM00     544     '
     'SR03S___IP4____AM01     510     '
     'SR03S___IP5____AM02     510     '
     'SR03S___IP6____AM03     510     '
     'SR03S___IP7____AM04     510     '
     'SR03S___IP8____AM04     544     '
     'SR04C___IP1____AM00     513     '
     'SR04C___IP2____AM00     513     '
     'SR04C___IP3____AM00     513     '
     'SR04C___IP4____AM00     513     '
     'SR04C___IP5____AM00     513     '
     'SR04C___IP6____AM00     513     '
     'SR04U___IP1____AM00     512     '
     'SR04U___IP2____AM00     512     '
     'SR04U___IP3____AM00     512     '
     'SR04U___IP4____AM00     512     '
     'SR05C___IP1____AM00     515     '
     'SR05C___IP2____AM00     515     '
     'SR05C___IP3____AM00     515     '
     'SR05C___IP4____AM00     515     '
     'SR05C___IP5____AM00     515     '
     'SR05C___IP6____AM00     515     '
     'SR05W___IP1____AM00     514     '
     'SR05W___IP3____AM00     514     '
     'SR05W___IP5____AM00     514     '
     'SR06C___IP1____AM00     517     '
     'SR06C___IP2____AM00     517     '
     'SR06C___IP3____AM00     517     '
     'SR06C___IP4____AM00     517     '
     'SR06C___IP5____AM00     517     '
     'SR06C___IP6____AM00     517     '
     'SR06S___IP3____AM00     vac     '
     'SR06S___IP4____AM00     vac     '
     'SR07C___IP1____AM00     519     '
     'SR07C___IP2____AM00     519     '
     'SR07C___IP3____AM00     519     '
     'SR07C___IP4____AM00     519     '
     'SR07C___IP5____AM00     519     '
     'SR07C___IP6____AM00     519     '
     'SR07U___IP1____AM00     518     '
     'SR07U___IP3____AM00     518     '
     'SR07U___IP6____AM00     vac     '
     'SR07U___IP7____AM00     vac     '
     'SR08C___IP1____AM00     521     '
     'SR08C___IP2____AM00     521     '
     'SR08C___IP3____AM00     521     '
     'SR08C___IP4____AM00     521     '
     'SR08C___IP5____AM00     521     '
     'SR08C___IP6____AM00     521     '
     'SR08U___IP1____AM00     520     '
     'SR08U___IP3____AM00     520     '
     'SR08U___IP5____AM00     520     '
     'SR09C___IP2____AM00     523     '
     'SR09C___IP3____AM00     523     '
     'SR09C___IP4____AM00     523     '
     'SR09C___IP5____AM00     523     '
     'SR09C___IP6____AM00     523     '
     'SR09U___IP1____AM00     522     '
     'SR09U___IP3____AM00     522     '
     'SR09U___IP5____AM00     522     '
     'SR10C___IP1____AM00     501     '
     'SR10C___IP2____AM00     501     '
     'SR10C___IP3____AM00     501     '
     'SR10C___IP4____AM00     501     '
     'SR10C___IP5____AM00     501     '
     'SR10C___IP6____AM00     501     '
     'SR10U___IP1____AM00     500     '
     'SR10U___IP3____AM00     500     '
     'SR10U___IP5____AM00     500     '
     'SR11C___IP1____AM00     503     '
     'SR11C___IP2____AM00     503     '
     'SR11C___IP3____AM00     503     '
     'SR11C___IP4____AM00     503     '
     'SR11C___IP5____AM00     503     '
%     'SR11C___IP6____AM00     503     '
   % 'SR11S___IP1____AM00     502     '
   % 'SR11S___IP2____AM00     502     '
     'SR11U___IP1____AM00     srioc110'
     'SR11U___IP2____AM00     srioc110'
     'SR11U___IP3____AM00     srioc110'
     'SR11U___IP4____AM00     srioc110'
     'SR12C___IP1____AM00     505     '
     'SR12C___IP2____AM00     505     '
     'SR12C___IP3____AM00     505     '
     'SR12C___IP4____AM00     505     '
     'SR12C___IP5____AM00     505     '
     'SR12C___IP6____AM00     505     '
     'SR12U___IP1____AM03     714     ' 
     'SR12U___IP3____AM04     714     '
     'SR12U___IP5____AM05     714     '];

IGlist = ['SR01C___IG2____AM00     507     '
     'SR01S___IG1____AM00     506     '
     'SR01S___IG2____AM00     506     '
     'SR02C___IG2____AM00     509     '
     'SR03C___IG2____AM00     511     '
     'SR04C___IG2____AM00     513     '
     'SR04U___IG1____AM00     512     '
     'SR04U___IG2____AM00     512     '
     'SR05C___IG2____AM00     515     '
     'SR05W___IG1____AM00     514     '
     'SR06C___IG2____AM00     517     '
     'SR07C___IG2____AM00     519     '
     'SR07U___IG1____AM00     vac     '
     'SR07U___IG2____AM00     vac     '
     'SR08C___IG2____AM00     521     '
     'SR08U___IG1____AM00     520     '
     'SR09C___IG2____AM00     523     '
     'SR09U___IG1____AM00     522     '
     'SR10C___IG2____AM00     501     '
     'SR10U___IG1____AM00     500     '
     'SR11C___IG2____AM00     503     '
     'SR11U___IG1____AM00     s111446 '
     'SR11U___IG2____AM00     s111446 '
     'SR12C___IG2____AM00     505     '];

IPam = zeros(size(IPlist,1),time);
IGam = zeros(size(IGlist,1),time);

tic
for t = 1:time
    
    for i=1:size(IPlist,1)
        IPam(i,t) = getpvonline(IPlist(i,1:19));
    end
    for i=1:size(IGlist,1)
        IGam(i,t) = getpvonline(IGlist(i,1:19));
    end
    %	zeroIPlist = IPlist(find(IPam(:,t)==0),:)
    %	zeroIGlist = IGlist(find(IGam(:,t)==0),:)
    
    
    %	IPam(:,t)
    %	IGam(:,t)
    
    pause(1);
    
end
toc

staleIPlist = find(std(IPam,0,2)==0);
staleIGlist = find(std(IGam,0,2)==0);

badIPlist = IPlist(staleIPlist,:);
badIGlist = IGlist(staleIGlist,:);

ILClist = [badIPlist(:,25:27);badIGlist(:,25:27)];

fprintf('Ion pumps that don''t seem to be updating are:\n');
badIPlist
fprintf('\n');
fprintf('Ion gauges that don''t seem to be updating are:\n');
badIGlist
