function [kickResp]=SweepKickerAngle(displacement, delta_angle, dispRange, angleRange,delay)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/SweepKickerAngle.m 1.2 2007/03/02 09:17:45CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% SWEEPKICKERANGLE(DISPLACEMENT, DELTA_ANGLE, DISPRANGE, ANGLERANGE, DELAY) where
%   ex: SweepKickerAngle(0,0, 2, 0.5, 5) 
%       start at current location 0, 0 "displacement, delta_angle"
%       sweep displacement from the current location +- 2mm
%       sweep angle from the current angle +-0.5 mr
%       average each sample by 5 (1 sample per second) so average of 5 == 5
%       seconds
%
%   DISPLACEMENT [mm] is the spacial change in the beam at the injection point.
%   DELTA_ANGLE [mrad] is the change in the injection angle.
%   DISPRANGE [mm] is the range of displacement that will be swept, 
%       ex: DISPRANGE = 1 will sweep from 
%    (DISPLACEMENT - DISPRANGE) to (DISPLACEMENT + DISPRANGE)
%   the sweep will be in increments of 
%   ((DISPLACEMENT - DISPRANGE) to (DISPLACEMENT + DISPRANGE))/10
%   
%   ANGLERANGE [mrad] is the range of angle that will be swept
%   the range and sweep will be in the same manner as explained above
% ----------------------------------------------------------------------------------------------

% 1 mrad -> DAC conversion factor. ie. DAC = factor*mrad
% 1 mrad -> 1.58 KV
% conversion factors for each respective kicker
%factor1 = 1 / 0.63;
%factor2 = -1 / 0.63;
%factor3 = -1 / 0.63;
%factor4 = 1 / 0.63; %volts KV / mRad

factor1 = 1000;
factor2 = -1000;
factor3 = -1000;
factor4 = 1000; %volts KV / mRad


pctMonitor = [];
tdeltaI = 0;
maxDispIndex =0;
kickResponse = [];
disps = [];
angles = [];
maxIindex = 1;
startX = displacement - dispRange;
stopX = displacement + dispRange;
incrX = (stopX - startX)/10;

startA = delta_angle - angleRange;
stopA = delta_angle + angleRange;
incrA = (stopA - startA)/10;

newX = startX;
newA = startA;
%newX = stopX;
%newA = stopA;

disps(1) = startX;
angles(1) = startA;
%btsKick={
% 'KS1       '    'KS1412-01:HV        '     'KS1412-01:HV        '  1   [1 ,1]  1     1.0       [0, 4.0]        2.00  ; ...
% 'KS2       '    'KS1401-01:HV        '     'KS1401-01:HV        '  1   [2 ,1]  5     1.0       [0, 4.0]        2.00  ; ...
% 'KS3       '    'KS1401-02:HV        '     'KS1401-02:HV        '  1   [3 ,1]  9      1.0       [0, 4.0]        2.00  ; ...
% 'KS4       '    'KS1402-01:HV        '     'KS1402-01:HV        '  1   [4 ,1]  13     1.0       [0, 4.0]        2.00  ; ...
%}

Kickername1 = 'KS1412-01:HV';
Kickername2 = 'KS1401-01:HV';
Kickername3 = 'KS1401-02:HV';
Kickername4 = 'KS1402-01:HV';

% use these values until the tunes can accurately be modeled
A10 = -7.1896;
A20 = 3.3362;
B10 = 0.50673;
B20 = 1.00;
B30pos = 1.00;
A03 = 0.35580;
B40pos = 0.50568;
A04 = -8.6925;

% set the Max range to control the number of iterations for each 
if(dispRange == 0)
    dispMax=0;
else
    dispMax=10;
end   
if(angleRange == 0)
    angleMax=0;
else
    angleMax=10;
end 


[hkick1 numopen] = mcagethandle(Kickername1);
if numopen == 0
    hkick1 = mcaopen(Kickername1);
    if hkick1 == 0
        error(['Problem opening a channel to : ' Kickername1]);
    end
end
		
[hkick2 numopen] = mcagethandle(Kickername2);
if numopen == 0
    hkick2 = mcaopen(Kickername2);
    if hkick2 == 0
        error(['Problem opening a channel to : ' Kickername2]);
    end
end

[hkick3 numopen] = mcagethandle(Kickername3);
if numopen == 0
    hkick3 = mcaopen(Kickername3);
    if hkick3 == 0
        error(['Problem opening a channel to : ' Kickername3]);
    end
end
		
[hkick4 numopen] = mcagethandle(Kickername4);
if numopen == 0
    hkick4 = mcaopen(Kickername4);
    if hkick4 == 0
        error(['Problem opening a channel to : ' Kickername4]);
    end
end

		
initkick1 = mcaget(hkick1);
initkick2 = mcaget(hkick2);
initkick3 = mcaget(hkick3);
initkick4 = mcaget(hkick4);

deltaI = 0;
pctName = 'PCT1402-01:mAChange';
pctHndle = 0;
[pctHndle numopen] = mcagethandle(pctName);
if numopen == 0
    pctHndle = mcaopen(pctName);
    if pctHndle == 0
        error(['Problem opening a channel to : ' pctName]);
    end
else 
    pctHndle = pctHndle(1);
end

%if pctHndle == 0
%    error(['Problem opening a channel to : ' pctHndle]);
%end
%fprintf('%15s: \t%10s + \t%10s = \t%10s \n', 'Kicker Name', 'Initial', 'DeltaKick', 'Final [mrad]');

fprintf('startDisp = %f stopDisp = %f | startAngle = %f stopAngle = %f\n',startX,stopX,startA,stopA);
fprintf('START:\nIn KV\nK1 [%f] \t K2 [%f] \t K3 [%f] \t K4 [%f]\n\n',initkick1,initkick2,initkick3,initkick4);

kIndex=1;

for dispIncrement = 1:dispMax+1
    for angleIncrement = 1:angleMax+1 
		%calculate the next Kicks, calculation is for Meters and radians
        %disp and angle were given in mm and mr so devide each by 1e3
        deltakick1 = (((newX/1000)*B20) - ((newA/1000)*A20))/((A10*B20)-(A20*B10));
        deltakick2 = (((newA/1000)*A10) - ((newX/1000)*B10))/((A10*B20)-(A20*B10));
        deltakick3 = (((-newA/1000)*A04) - ((newX/1000)*B40pos))/((A04*B30pos)-(A03*B40pos)); 
        deltakick4 = (((-newX/1000)*B30pos) - ((newA/1000)*A03))/((A04*B30pos)-(A03*B40pos)); 

		
		
		% Directly open a channel to the EPICS PV. Not using middleware because the
		% family and channel names are not listed as part of the accelerator
		% object.
		%initkick1 = mcaget(hkick1);
		%initkick2 = mcaget(hkick2);
		 
		
		fprintf('[%03d]:\tdisp:> %1.5f \tang:> %1.5f ',kIndex,newX,newA);
        fprintf('\tK1: %2.08f  ', initkick1+deltakick1*factor1);
        fprintf('\tK2: %2.08f  ', initkick2+deltakick2*factor2);
        fprintf('\tK3: %2.08f  ', initkick3+deltakick3*factor3);
        fprintf('\tK4: %2.08f  ', initkick4+deltakick4*factor4);

        mcaput(hkick1, initkick1+deltakick1*factor1); % These have to be in DACs
        mcaput(hkick2, initkick2+deltakick2*factor2);
        mcaput(hkick3, initkick3+deltakick3*factor3); % These have to be in DACs
        mcaput(hkick4, initkick4+deltakick4*factor4);

        
        kicks(kIndex,1)=initkick1+deltakick1*factor1;
        kicks(kIndex,2)=initkick2+deltakick2*factor2; 
        kicks(kIndex,3)=initkick3+deltakick3*factor3;
        kicks(kIndex,4)=initkick4+deltakick4*factor4; 
        
        
       
        fprintf(' ! ');
        if(pctHndle > 0 )
            %if we are connected to the PCT then average some samples
            temp = 0;
           
            pause(delay);
            fprintf(' <');
            for d=1:delay
                if(delay < 10)
                    fprintf('.');
                end    
                pause(1);
                temp = temp + mcaget(pctHndle);
                
            end    
            fprintf('>');

            deltaI = temp / delay;
            
            if(deltaI > tdeltaI)
                tdeltaI = deltaI;
                maxIindex = kIndex;
                maxDispIndex = dispIncrement;
            end    
            % do not show deltaI's less that Zero, makes the surface plots
            % easier to understand
            %if(deltaI > 0)
                kickResponse(dispIncrement,angleIncrement) = deltaI;
                pctMonitor(kIndex) = deltaI;
                %else
                %kickResponse(dispIncrement,angleIncrement) = 0; 
                %end    
            fprintf('\t\t %s: %1.5f\n', 'PCT', kickResponse(dispIncrement,angleIncrement));
        else
            pause(delay);
            fprintf('\t\t %s: NC\n', 'PCT');
        end    
        
        kIndex = kIndex+1;
        %make sure this always starts back at the beggining

        if(angleIncrement >= 1 & angleIncrement < angleMax+1)
            newA = startA + (angleIncrement * incrA);
            angles(angleIncrement) = newA;
        else
            %start at the beggining
            newA = startA ;    
        end    
        
    end
    newX = startX + (dispIncrement * incrX);
    disps(dispIncrement) = newX;
end    
injResp = kickResponse;
if(dispMax ==1 | angleMax == 1)
else    
	
%surface(kickResponse);
	%axis([startX stopX startA stopA]);
%xlabel('Angle [measurement index]'),ylabel('Displacement [measurement index]')
%title('SR Injection Response');
%    figure;
    %plot3(disps,angles,kickResponse(maxDispIndex,:));
%    contour(kickResponse(maxDispIndex,:));
%    xlabel('Angle [measurement index]'),ylabel('Displacement [measurement index]')
%    title('SR Injection Response');
    if(length(pctMonitor) > 0)
        figure; plot(pctMonitor);   
        title('PCT Monitored Values');
        xlabel('kIndex'); ylabel('Injection Current mA/s');
    end    
end
fprintf('Sweep COMPLETE\n');

if(length(pctMonitor) > 0)
    fprintf('The max reposnse was at index %d: %f mA/s\n',maxIindex,pctMonitor(maxIindex));
end    
accept=input('Enter index value to set or 0 to reset to original positions:> ');
if(accept > 0)
    fprintf('Setting index[%d] on %s,%s,%s and %s to %d,%d,%d and %d respectively\n',accept,Kickername1,Kickername2,Kickername3,Kickername4,kicks(accept,1),kicks(accept,2),kicks(accept,3),kicks(accept,4));
    mcaput(hkick1, kicks(accept,1)); % These have to be in DACs
    mcaput(hkick2, kicks(accept,2));
    mcaput(hkick3, kicks(accept,3));
    mcaput(hkick4, kicks(accept,4));    
else
    fprintf('Resetting %s ,%s,%s and %s to %d,%d,%d and %d respectively\n',Kickername1,Kickername2,Kickername3,Kickername4,initkick1,initkick2,initkick3,initkick4);
    mcaput(hkick1, initkick1); % These have to be in DACs
    mcaput(hkick2, initkick2);
    mcaput(hkick3, initkick3);
    mcaput(hkick4, initkick4);    
end    

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/SweepKickerAngle.m  $
% Revision 1.2 2007/03/02 09:17:45CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
