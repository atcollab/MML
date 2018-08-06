function [TriggerDelayGoal, MaxBucket, bcm] = checkbcm(MaxBucket)
%CHECKBCM - Check the trigger delay of the bunch current monitor
%
%  [TriggerDelayGoal, bcm] = checkbcm(MaxBucket {308})
%
%  NOTE
%  1. This function may not work quite right if there are bunches next to the maximum charge bunch
%  2. There is roughly 62.54 ps between ADC samples (also the Trigger Delay step size)  
%  3. There are 32 samples per RF bucket
% 
%  See also getbcm, setbcm

% Written by Greg Portmann based on Eric Norum's python script

if nargin < 1
    MaxBucket = 308;
end

bcm = getbcm('Struct');
iADCGoal = (MaxBucket * 32) - 16;
[ADCmax, iADCmax] = max(bcm.ADC);
[ADCmin, iADCmin] = min(bcm.ADC);

iADCmean = round(mean([iADCmin iADCmax]));

% TriggerDelay is =/-2nsec, so one can use 0 to 2ns or -1ns to 1ns
%TriggerDelayGoal = mod(bcm.TriggerDelay + iADCmax - iADCGoal + length(bcm.ADC), length(bcm.ADC));
TriggerDelayGoal = mod(bcm.TriggerDelay + iADCmean - iADCGoal + length(bcm.ADC), length(bcm.ADC));
%if TriggerDelayGoal > length(bcm.ADC)/2
%    TriggerDelayGoal = TriggerDelayGoal - length(bcm.ADC);
%end

if nargout < 1
    fprintf('   Maximum ADC value is %d at index %d -- expected index %d for bucket %d\n', ADCmax, iADCmax, iADCGoal, MaxBucket);
    fprintf('   Present trigger delay of %d should be set to %d (changed by %d or %.1f psec)\n', bcm.TriggerDelay, TriggerDelayGoal, TriggerDelayGoal-bcm.TriggerDelay, 62.54*(TriggerDelayGoal-bcm.TriggerDelay));
end

