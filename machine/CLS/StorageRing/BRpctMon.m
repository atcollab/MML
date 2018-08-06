function BRpctMon(pvName)

% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/BRpctMon.m 1.2 2007/03/02 09:02:21CST matiase Exp  $
% ----------------------------------------------------------------------------------------------


%h=mcaopen(pvName);
[h numopen] = mcagethandle(pvName);
if numopen == 0
    h = mcaopen(pvName);
    if h == 0
        error(['Problem opening a channel to : ' pvName]);
    end
end

if(length(h) > 1)
    h = h(1); %only take the first one
end

figure;
if(h > 0)
    for i=1:1000
        x=mcaget(h);
        
        cla;
        plot(x,'-O');
        title('Booster PCT');
        xlabel('sample'); ylabel('mA');
        pause(0.75);
       
    end
end    
      
% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/BRpctMon.m  $
% Revision 1.2 2007/03/02 09:02:21CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------





