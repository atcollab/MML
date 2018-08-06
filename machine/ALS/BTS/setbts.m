function ErrorFlag = setbts(Family, Field, NewSP, DeviceList, WaitFlag) 
%SETBTS - Ramps the BTS magnets in steps to avoid overshoots and trips
%  ErrorFlag = setbts(Family, Field, NewSP, DeviceList, MaxStep, WaitFlag)
%
%  Written by Greg Portmann


ErrorFlag = 0;


if nargin < 1
    Family = 'BEND';
end
if nargin < 2
    Field = 'Setpoint';
end
if nargin < 3
    NewSP = [];
end
if nargin < 4
    DeviceList = [];
end


% If not input, get the setpoints from the production lattice
if isempty(NewSP)
    SP = getproductionlattice;
    NewSP = SP.(Family).('Setpoint').Data;
    if isempty(DeviceList)
        DeviceList = SP.(Family).Setpoint.DeviceList;
    else
        i = findrowindex(DeviceList ,SP.(Family).Setpoint.DeviceList);
        NewSP = NewSP(i,:);
    end
end


switch Family
    case 'BEND'
        MaxStep = 25;  % Amps
    otherwise
        MaxStep = 25;  % Amps
end


SP0 = getpv(Family, Field, DeviceList);

if ~all((NewSP - SP0) == 0)

    N = max(ceil(abs(NewSP-SP0) / MaxStep));

    % Use the AO for the BEND without the special function
    [tmp, AO] = isfamily(Family);
    AO.Setpoint = rmfield(AO.Setpoint, 'SpecialFunctionSet');

    Delta = (NewSP - SP0) / N;

    if N > 1
        if WaitFlag == 0
            fprintf('   Warning: WaitFlag==0 gets ignored if the change in current is greater than %.1f amps.\n', MaxStep);
            WaitFlag == -1;
        end
        
        SPtmp = SP0;
        for i = 1:N
            SPtmp = SPtmp + Delta;
            ErrorFlag = setpv(AO, Field, SPtmp, DeviceList, -1);
        end
    end

    ErrorFlag = setpv(AO, Field, NewSP, DeviceList, WaitFlag);
end

