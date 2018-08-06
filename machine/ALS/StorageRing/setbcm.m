function [TriggerDelayGoal, MaxBucket, bcm] = setbcm(varargin)
%SETBCM - Set the trigger delay of the bunch current monitor
%
%
%  See also getbcm, checkbcm

% Written by Greg Portmann

% Change criteria to force the slope through zero between point 16 & 17


[TriggerDelayGoal, MaxBucket, bcm] = checkbcm(varargin{:});

line1 = sprintf('Present trigger delay of %d should be set to %d.\n', bcm.TriggerDelay, TriggerDelayGoal);
line2 = sprintf('This is a change of %d or %.1f psec.\n', TriggerDelayGoal-bcm.TriggerDelay, 62.54*(TriggerDelayGoal-bcm.TriggerDelay));
line3 = sprintf('(Measurement based on bucket %d being the maximum charge.)\n', MaxBucket);
ButtonName = questdlg({line1, line2, line3, ' ', 'Do you want to make the change?'}, 'Bunch Current Monitor', 'Yes', 'No', 'No');

if strcmpi(ButtonName, 'Yes')
    fprintf('   Changing the BCM trigger delay from %d to %d.\n', bcm.TriggerDelay, TriggerDelayGoal);
    setpvonline('SR1:BCM:triggerDelay', TriggerDelayGoal);
else
    fprintf('   No change made to the BCM trigger delay.\n');
end

