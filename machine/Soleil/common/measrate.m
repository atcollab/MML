function [AvgRate, N] = measrate(family, elem, T);
%MEASRATE - noise on channels
%[AvgRate, N] = measrate(Family, List, T);
%
% INPUTS
% 1. Family = Family name ('BPMx', 'HCOR', etc.) 
% 2. List   = Device list or element list [column vector] {default, entire family}
% 3. T      = Time interval to check sampling rate [seconds]
%
% OUTPUTS
% 1. AvgRate = Average sample rate over T seconds perios
% 2. N       = Number of observed transitions
%
% NOTES
% 1.This method only works on noisy channels!

%
% Written by Gregory J. Portmann, ALS

if nargin == 0,
    error('Need atleast one input: family');
end 

if nargin == 1,
    elem = getlist(family);
end

if isempty(elem)
    elem = getlist(family);
end


if (size(elem,2) == 2) 
    elem = dev2elem(family, elem);
end                  

if nargin <= 2,
    T = 2;
end

OneAtATimeFlag = 0;

if OneAtATimeFlag
    DelT = .005;
else
    if length(elem)>50
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


disp(['  Checking the data rate for channel or family: ', family]); 
disp(['  Collection data for ',num2str(tin(end)),' seconds at a sample rate of ',num2str(1/mean(diff(tin))),' Hertz.']); pause(0);
disp(['  Channels must be noisy for this method to work.']);
if OneAtATimeFlag
    
    for i = 1:size(elem,1)
        % Collect data
        [a, t] = getam(family, elem(i,1), 1, tin);
        
        adiff = abs(diff(a));
        I = find(adiff>0);
        
        if size(I,2) < 3
            disp(' '); disp('  WARNING: Less than 3 update.  Increase time span or channel not noisy enough.'); disp(' ');
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
        fprintf('  %s(%2d,%2d), Sample Rate=%5.2f Hz,  Number of Samples=%d, Number of New Data Points=%d\n', family, Dev(1), Dev(2), AvgRate(i,1), length(t),N(i,1));
    end
else
    % Collect data using EPICs
    getam(family);  % just to connect to channels
    [a, t] = getam(family, [], 1, tin);
    
    %figure(3)
    %plot(tin,t)
    
    for i = 1:size(elem,1)
        adiff = abs(diff(a(i,:)));
        I = find(adiff>0);
        
        if size(I,2) < 3
            disp(' '); disp(['  WARNING: ',family,'(',num2str(i),') less than 3 update.  Increase time span or channel not noisy enough.']); disp(' ');
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
        
        Dev = elem2dev(family,elem(i));
        fprintf('  %s(%2d,%2d), Sample Rate=%5.2f Hz,  Number of Samples=%d, Number of New Data Points=%d\n', family, Dev(1), Dev(2), AvgRate(i,1), length(t),N(i,1));
    end   
end
