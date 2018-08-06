function scanorbit(Family, DeviceList1, DeviceList2)
%SCANORBIT - Scans 2 correctors 90 degrees out of phase 
%            or 2 correctors of your choice
%
%  If only one corrector is selected, then automatically find a BPM at 90
%  degrees out of phase
%
%  INPUTS
%  1. Family - Family name
%  2. DeviceList1 - First corrector devicelist
%  3. DeviceList2 - Second corrector devicelist


%Amps  = [-30 -20 -10 0 10 20 30];
Amps  = [-10 -5 0 5 10];


% Inputs
if nargin < 2
    DeviceList1 = [];
end
if nargin < 1
    i = menu('Select a corrector family:','1 HCM corrector','1 VCM corrector','All HCM correctors','All VCM correctors', 'Cancel');
    switch i
        case 1 
            % HCM
            Family = gethcmfamily;
            DeviceList1 = editlist(family2dev(Family), Family, 0);
        case 2
            % VCM
            Family = getvcmfamily;
            DeviceList1 = editlist(family2dev(Family), Family, 0);
        case 3
            % All HCM
            Family = gethcmfamily;
            DeviceList1 = family2dev(Family);
        case 4 
            % All VCM
            Family = getvcmfamily;
            DeviceList1 = family2dev(Family);
        case 5 
            % Cancel
            return;
    end
end

if isempty(DeviceList1)
    DeviceList1 = family2dev(Family);
end


for i = 1:size(DeviceList1,1)
    Dev1 = DeviceList1(i,:);
    
    if nargin < 3 
        % Find a corrector 90 degrees out of phase with Dev1
        DeviceList2 = family2dev(Family);
        [Phase1, PhaseAll] = modeltwiss('Phase', Family, Dev1, Family, DeviceList2);
        [PhaseDiffRad, j] = min(abs(rem(PhaseAll-Phase1, pi/2))-1);
        Dev2 = DeviceList2(j(1),:);    
    else
        Dev2 = DeviceList2(i,:);    
    end
    
    Amps10 = getsp(Family, Dev1);
    Amps20 = getsp(Family, Dev2);
    
    for Amp1 = Amps
        setsp(Family, Amp1, Dev1);
        pause(.2);
        for Amp2 = Amps
            setsp(Family, Amp2, Dev2);
            fprintf('   %s(%d,%d)=%f  %s(%d,%d)=%f \n', Family, Dev1(1,1), Dev1(1,2), Amp1, Family, Dev2(1,1), Dev2(1,2), Amp2);
            fprintf('   Hit return to continue (Ctrl-C to exit)\n');
            pause;
            fprintf(' \n');
        end
    end   
    
    % Reset
    setsp(Family, Amps10, Dev1);
    pause(.2);
    setsp(Family, Amps20, Dev2);
end


