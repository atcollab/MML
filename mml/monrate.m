function [AvgRate, N] = monrate(family, DeviceList, T);
%MONRATE - Calculates the control system data rate of a noisy channel
%  [AvgRate, N] = monrate(Family, DeviceList, T)
%
%  INPUTS
%  1. Family - Family name ('BPMx', 'HCM', etc.) 
%  2. DeviceList - Device list or element list [column vector] {Default: entire family}
%  3. T - Time interval to check sampling rate [seconds]  {Default: 2 seconds}
%
%  OUTPUTS
%  1. AvgRate - Average sample rate over T seconds periods
%  2. N - Number of observed transitions
%
%  NOTES
%  1. This method only works on noisy channels!

%  Written by Greg Portmann

DisplayFlag = 0;
OneAtATimeFlag = 0;

if nargin == 0,
    error('Need atleast one input: family');
end 

if nargin < 2
    DeviceList = [];
end
if isempty(DeviceList)
    DeviceList = getlist(family);
end

if (size(DeviceList,2) == 1) 
    DeviceList = elem2dev(family, DeviceList);
end                  

if nargin <= 2
    T = 2;
end

if OneAtATimeFlag
    DelT = .005;
else
    if size(DeviceList,1) > 50
        DelT = .03;
    else
        DelT = .02;
    end
end
if length(T) == 1
    tin = 0:DelT:T;
else
    tin = T;
end


disp(['   Checking the data rate for channel or family: ', family]); 
disp(['   Collection data for ',num2str(tin(end)),' seconds at a sample rate of ',num2str(1/mean(diff(tin))),' Hertz.']); 
pause(0);
disp(['   Channels must be noisy for this method to work.']);
if OneAtATimeFlag
    
    for i = 1:size(DeviceList,1)
        % Collect data
        [a, t] = getam(family, DeviceList(i,:), tin);
        
        adiff = abs(diff(a));
        I = find(adiff > 0);
        
        if size(I,2) < 3
            disp(' '); 
            disp('   WARNING: Less than 3 update.  Increase time span or channel not noisy enough.'); 
            disp(' ');
        end
        
        if isempty(I)
            N(i,1) = 0;
            AvgRate(i,1) = 0;
        else
            t = t(I);
            tdiff = diff(t);
            
            N(i,1) = size(I,2)-1;
            AvgRate(i,1) = 1/mean(tdiff);
        end
        
        Dev=elem2dev(family,elem(i));
        fprintf('   %s(%2d,%2d), Sample Rate=%5.2f Hz,  Number of Samples=%d, Number of New Data Points=%d\n', family, Dev(1), Dev(2), AvgRate(i,1), length(t),N(i,1));
    end
else
    % Collect data using EPICs
    getam(family, DeviceList);  % just to connect to channels
    [a, t, DataTime] = getam(family, DeviceList, tin);
    
    for i = 1:size(DeviceList,1)
        adiff = abs(diff(a(i,:)));
        I = find(adiff>0);
        
        if size(I,2) < 3
            fprintf('\n    WARNING: %s(%d,%d) updated %d times in %.2f seconds.  Increase time span or channel is not noisy enough.\n\n', family, DeviceList(i,:), size(I,2), tin(end)); 
        end
        
        if isempty(I)
            N(i,1) = 0;
            AvgRate(i,1) = 0;
        else
            t1 = t(I);
            tdiff = diff(t1);
            
            N(i,1) = size(I,2)-1;
            AvgRate(i,1) = 1/mean(tdiff);
        end
        
        Dev = DeviceList(i,:);
        if DisplayFlag
            fprintf('   %s(%2d,%2d), Sample Rate=%5.2f Hz,  Number of Samples=%d, Number of New Data Points=%d\n', family, Dev, AvgRate(i,1), length(t), N(i,1));
        end
    end
end
