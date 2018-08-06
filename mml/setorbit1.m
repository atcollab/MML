function setorbit1(GoalOrbit, BPMFamily, BPMDevList, CMFamily, CMDevList, Iter)
%SETORBIT1 - Correct the orbit using all the SVD (1 plane)
%  setorbit1(GoalOrbit, BPMFamily, BPMDevList, CMFamily, CMDevList, Iter)
%
%  For 1 BPM, if CMDevList is empty, the most effective corrector will be used.
%
%  EXAMPLE
%  1. setorbit1(getgolden('BPMx',[8 2]), 'BPMx', [8 2]);

%  Written by Greg Portmann

WaitFlag = -2;

if nargin < 4
    if strcmpi(BPMFamily, 'BPMx')
        CMFamily= 'HCM';
    elseif strcmpi(BPMFamily, 'BPMy')
        CMFamily= 'VCM';
    else
        error('Corrector magnet family not specified.');
    end
end
if nargin < 5
    if size(BPMDevList,1) == 1
        % Pick the corrector based on most effective corrector in the response matrix
        R = getrespmat(BPMFamily, BPMDevList, CMFamily, [], 'Struct', 'Physics');
        [MaxValue, j] = max(abs(R.Data));
        CMDevList = R.Actuator.DeviceList(j,:);
    else
        error('Corrector magnet device list not specified.');
    end
end

if nargin < 6
    Iter = 3;
end


s = getrespmat(BPMFamily, BPMDevList, CMFamily, CMDevList);
if any(any(isnan(s)))
    error('Response matrix has a NaN')
end
for i = 1:Iter
    x = getam(BPMFamily, BPMDevList) - GoalOrbit;

    % Check limits
    MinSP = minsp(CMFamily, CMDevList);
    MaxSP = maxsp(CMFamily, CMDevList);
    if any(getsp(CMFamily,CMDevList)-(x/s) > MaxSP-5)
        fprintf('   Orbit not corrected because a maximum power supply limit would have been exceeded!');
        return;
    end
    if any(getsp(CMFamily,CMDevList)-(x/s) < MinSP+5)
        fprintf('   Orbit not corrected because a minimum power supply limit would have been exceeded!');
        return;
    end

    stepsp(CMFamily, -x/s, CMDevList, WaitFlag);
end
