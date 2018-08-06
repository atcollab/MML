function [kickResp]=SetKickerAngle(displacement, delta_angle, dispRange, angleRange,delay)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/SetKickerAngle.m 1.2 2007/03/02 09:18:00CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% SETKICKERANGLE(DISPLACEMENT, DELTA_ANGLE) where
%   ex: SetKickerAngle(1.25,0.5) 
%       set displacement to 1.25mm , 0.5 mrad "displacement, delta_angle"
%
%   DISPLACEMENT [mm] is the spacial change in the beam at the injection point.
%   DELTA_ANGLE [mrad] is the change in the injection angle.
% ----------------------------------------------------------------------------------------------

% 1 mrad -> DAC conversion factor. ie. DAC = factor*mrad
% conversion factors for each respective kicker
factor1 = 100;
factor2 = -100;
factor3 = -100;
factor4 = 100; %volts KV / mRad

newX = displacement;
newA = delta_angle;

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


pctName = 'PCT1402-01:mAChange';
pctHndle = mcaopen('PCT1402-01:mAChange');
%if pctHndle == 0
%    error(['Problem opening a channel to : ' pctHndle]);
%end
%fprintf('%15s: \t%10s + \t%10s = \t%10s \n', 'Kicker Name', 'Initial', 'DeltaKick', 'Final [mrad]');

%calculate the next Kicks, calculation is for Meters and radians
%disp and angle were given in mm and mr so devide each by 1e3
deltakick1 = (((newX/1000)*B20) - ((newA/1000)*A20))/((A10*B20)-(A20*B10));
deltakick2 = (((newA/1000)*A10) - ((newX/1000)*B10))/((A10*B20)-(A20*B10));
deltakick3 = (((-newA/1000)*A04) - ((newX/1000)*B40pos))/((A04*B30pos)-(A03*B40pos)); 
deltakick4 = (((-newX/1000)*B30pos) - ((newA/1000)*A03))/((A04*B30pos)-(A03*B40pos)); 

	
fprintf('disp:> %1.5f \tang:> %1.5f ',newX,newA);
fprintf('\tK1: %2.08f  ', initkick1+deltakick1*factor1);
fprintf('\tK2: %2.08f  ', initkick2+deltakick2*factor2);
fprintf('\tK3: %2.08f  ', initkick3+deltakick3*factor3);
fprintf('\tK4: %2.08f  ', initkick4+deltakick4*factor4);

mcaput(hkick1, initkick1+deltakick1*factor1); % These have to be in DACs
mcaput(hkick2, initkick2+deltakick2*factor2);
mcaput(hkick3, initkick3+deltakick3*factor3); % These have to be in DACs
mcaput(hkick4, initkick4+deltakick4*factor4);
        
% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/SetKickerAngle.m  $
% Revision 1.2 2007/03/02 09:18:00CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------


