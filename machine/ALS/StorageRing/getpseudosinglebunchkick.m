function [x, y, PSBFlag, BPMDevList] = getpseudosinglebunchkick(BPMDevListInput, PlotFlag)
% 

% Assumes 1 kV kicker strength

if nargin < 2
    PlotFlag = 0;
end

load PseudoSingleBunchKickerData


if nargin < 1
    BPMDevListInput = BPMDevList;
end


x = x1000 - x0;
y = y1000 - y0;

% To reduce add noise for low currents
PSBFlag = 0;
KickerVoltage = getpv('SR02S___CK_AMP_AM00');
if KickerVoltage > 10
    Cam2Current = getpv('Cam2_current');
    if Cam2Current > .5
        DCCT = getdcct;
        PSBFlag = 1;
    end
end

if PSBFlag
    ScaleFactor = 60.6754; % y 
    
    %fprintf('  getpseudosinglebunchkick: the kicked orbit has been adjusted by the faction of current in the cam2 (%.1f/%.1f)\n', Cam2Current, DCCT);
    x = x * (Cam2Current/DCCT) * (KickerVoltage/999.7548);
   %y = y * (Cam2Current/DCCT) * (KickerVoltage/999.7548);
    y1 = y * (KickerVoltage/999.7548) * (Cam2Current/DCCT  + .016);
    y = y * (KickerVoltage/999.7548) * (Cam2Current  + (DCCT-Cam2Current)*.016)/DCCT;
else
    x = x * 0;
    y = y * 0;
end

[i,j] = findrowindex(BPMDevListInput, BPMDevList);

if ~isempty(j)
    error('BPM not found in getpseudosinglebunchkick');
end

x = x(i);
y = y(i);


if PlotFlag
    figure(1);
    s = getspos('BPMx', BPMDevListInput);
    
    subplot(2,1,1);
    hold on
    plot(s, 1000*x, 'g');
    hold off
    grid on
    ylabel('Horizontal [\mum]');
    
    subplot(2,1,2);
    hold on
    plot(s, 1000*y, 'g');
    grid on
    xlabel('s-position [meters]');
    ylabel('Vertical [\mum]');
end