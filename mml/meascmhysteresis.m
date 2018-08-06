function meascmhysteresis(BPMList, CMFamily, CMList, MaxChange, NSteps)
%MEASCMHYSTERESIS - Measure corrector magnet hysteresis
%
%  meascmhysteresis(BPMList, MaxChange, NSteps)
%
%  INPUTS
%  1. BPMList   - BPM list 
%  2. CMFamily  - Corrector family
%  3. CMList    - Corrector device list
%  4. MaxChange - Maximum vertical change from the starting point
%  5. NSteps    - Number of step from starting point to the maximum
%
%  NOTES
%  1. This function looks for a bump coefficient file corresponding to BPM list.  
%     For instance, VerticalBumpCoef-7_8-6_1 is the vertical file for [7 8;6 1].
%     If you don't want to use this file, delete it and a new new will be created.
%     All files are stored in <DataRoot><aperturescan>

%  Written by Greg Portmann
%  Adapted by Laurent S. Nadolski

BPMxFamily = gethbpmfamily; 
BPMyFamily = getvbpmfamily;
HCMFamily  = gethcmfamily;
VCMFamily  = getvcmfamily;


%%%%%%%%%%%%%%%%%%
% Input checking %
%%%%%%%%%%%%%%%%%%
if nargin < 1
    BPMList = [7 6; 8 1];
end
if nargin < 2
    CMFamily = VCMFamily;
end
if nargin < 3
    if size(BPMList,1) == 1
        CMList = [4 4];
    else
        CMList = [-4 -3 -2 -1 1 2 3 4];
    end
end
if nargin < 4
    MaxChange = 1.5;
end
if nargin < 5
    NSteps = 5;     % Steps from 0 to MaxChange
end


% Corrector starting points
HCM0 = getsp(HCMFamily); 
VCM0 = getsp(VCMFamily);


% Offset
Xoffset = getoffset(BPMxFamily, BPMList);
Yoffset = getoffset(BPMyFamily, BPMList);

% Gain
Xgain = getphysdata(BPMxFamily, 'Gain', BPMList);
Ygain = getphysdata(BPMyFamily, 'Gain', BPMList);


BPMxIndex = findrowindex(BPMList, getlist(BPMxFamily));
BPMyIndex = findrowindex(BPMList, getlist(BPMyFamily));

BPMxList = getlist(BPMxFamily);
BPMyList = getlist(BPMyFamily);

FileNumberString =  sprintf('-%d_%d', BPMList');
DirectoryName = [fullfile(getfamilydata('Directory','DataRoot'),'aperturescan'),filesep];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute corrector coefficients %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BPMWeight = 40;
SVDIndex = 1e-3;

if strcmpi(CMFamily, HCMFamily)
    HorizontalBumpFile = sprintf('%sHorizontalBumpCoef%s', DirectoryName, FileNumberString);
    if size(BPMList,1) == 1 && isempty(CMList)
        % For single BPM just use one corrector
        % Pick the corrector based on the response matrix
        R = getbpmresp('Struct');
        [i, iNotFound] = findrowindex(BPMList, R(1,1).Monitor.DeviceList);
        m = R(1,1).Data(i,:);
        [MaxValue, j] = max(abs(m));
        HCMDeviceList = R(1,1).Actuator.DeviceList(j,:);
        %DeltaHCM = (1/m(j)) ./ Xgain;  % Amps/mm  (at the BPM BPMList)
        DeltaHCM = (1/max(abs(m))) ./ Xgain;  % Amps/mm  (maximum at many BPM)
        
    elseif size(CMList,1) == 1 && size(CMList,2) <= 2
        % For single corrector
        R = getbpmresp('Struct');
        [i, iNotFound] = findrowindex(BPMList, R(1,1).Monitor.DeviceList);
        [j, jNotFound] = findrowindex(CMList,  R(1,1).Actuator.DeviceList);
        m = R(1,1).Data(i,j);
        DeltaHCM = (1/m) ./ Xgain;  % Amps/mm
        
    elseif exist([HorizontalBumpFile,'.mat'], 'file')
        fprintf('   Loading horizontal corrector magnet bump coefficients from %s\n', ...
            HorizontalBumpFile);
        load(HorizontalBumpFile);
        
    else
        % Set the hysteresis
        fprintf('   Finding horizontal corrector magnet bump coefficients\n');
        DeltaX = [.2;.2] ./ Xgain;
        x0 = getam(BPMxFamily, BPMList);
        %[HOCS, RF, HOCS0] = setorbitbump(BPMxFamily, BPMList, DeltaX, HCMFamily, CMList, 1, SVDIndex, BPMWeight, 'Inc', 'NoDisplay');
        HOCS0 = setorbitbump(BPMxFamily, BPMList, DeltaX, HCMFamily, CMList, 1, ...
            BPMWeight, 'Inc', 'NoDisplay');
        x1 = getam(BPMxFamily, BPMList);
        
        % Get a clean bump
        figure(1);
        clf reset
        x2 = getam(BPMxFamily, BPMList);
        %[HOCS, RF, HOCS0] = setorbitbump(BPMxFamily, BPMList, DeltaX, HCMFamily, CMList, 1, SVDIndex, BPMWeight, 'Inc', 'NoDisplay');
        HOCS = setorbitbump(BPMxFamily, BPMList, DeltaX, HCMFamily, CMList, 1, ...
            BPMWeight, 'Inc', 'NoDisplay');
        x3 = getam(BPMxFamily, BPMList);
        drawnow;
        DeltaHCM = (HOCS.CM.Data - HOCS0.CM.Data)/.2;  % amps/mm  (real units)
        BPMDeviceList = HOCS.BPM.DeviceList;
        HCMDeviceList = HOCS.CM.DeviceList;
        setsp(HCMFamily, HCM0);
        save(HorizontalBumpFile, 'DeltaHCM', 'HCMDeviceList', 'BPMDeviceList', 'HOCS', 'HOCS0');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Linearity and hystersis check %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Starting corrector values
    hcm0 = getsp(HCMFamily, HCMDeviceList);
    
    % Set hysteresis in an upward direction
    setsp(HCMFamily, hcm0 - MaxChange * DeltaHCM, HCMDeviceList, -2);
    setsp(HCMFamily, hcm0, HCMDeviceList);
    
    % Build loop
    Loop = [linspace(0,MaxChange,NSteps+1) linspace(MaxChange-MaxChange/NSteps,-MaxChange,2*NSteps) linspace(-MaxChange+MaxChange/NSteps,0,NSteps)];
    LoopTotal = [Loop Loop(2:end)];
    
    i = 0;
    for y = LoopTotal
        i = i + 1;
        setsp(HCMFamily, hcm0 + y * DeltaHCM, HCMDeviceList, -2);
        DCCT(i) = getdcct;
        HCMsp(:,i) = getsp(HCMFamily, HCMDeviceList);
        HCMam(:,i) = getam(HCMFamily, HCMDeviceList);
        %BPMx(:,i) = raw2real(BPMxFamily, getx);
        %BPMy(:,i) = raw2real(BPMyFamily, getz);
        BPMx(:,i) = getx;
        BPMy(:,i) = getz;
    end
    
    % Reset correctors
    setsp(HCMFamily, HCM0);
    
elseif strcmpi(CMFamily, VCMFamily)
    VerticalBumpFile = sprintf('VerticalBumpCoef%s', FileNumberString);
    if size(BPMList,1) == 1 && isempty(CMList)
        % For single BPM just use one corrector
        % Pick the corrector based on the response matrix
        R = getbpmresp('Struct');
        [i, iNotFound] = findrowindex(BPMList, R(2,2).Monitor.DeviceList);
        m = R(2,2).Data(i,:);
        [MaxValue, j] = max(abs(m));
        VCMDeviceList = R(2,2).Actuator.DeviceList(j,:);
        %DeltaVCM = (1/m(j)) ./ Ygain;  % Amps/mm  (at the BPM BPMList)
        DeltaVCM = (1/max(abs(m))) ./ Ygain;  % Amps/mm  (maximum at many BPM)
        
    elseif size(CMList,1) == 1 && size(CMList,2) <= 2
        % For single corrector
        R = getbpmresp('Struct');
        [i, iNotFound] = findrowindex(BPMList, R(2,2).Monitor.DeviceList);
        [j, jNotFound] = findrowindex(CMList,  R(2,2).Actuator.DeviceList);
        m = R(2,2).Data(i,j);
        DeltaVCM = (1/m) ./ Ygain;  % Amps/mm
        VCMDeviceList = CMList;
        
    elseif exist([VerticalBumpFile,'.mat'], 'file')
        fprintf('   Loading vertical corrector magnet bump coefficients from %s\n', VerticalBumpFile);
        load(VerticalBumpFile);
    else
        % Set the hysteresis
        fprintf('   Finding vertical corrector magnet bump coefficients\n');
        DeltaY = [.2;.2] ./ Ygain;
        y0 = getam(BPMyFamily, BPMList);
        %[VOCS, RF, VOCS0] = setorbitbump(BPMyFamily, BPMList, DeltaY, VCMFamily, CMList, 1, SVDIndex, BPMWeight, 'Inc', 'NoDisplay');
        % in one iteration        
        VOCS0 = setorbitbump(BPMyFamily, BPMList, DeltaY, VCMFamily, CMList, ...
            1, BPMWeight, 'Inc', 'NoDisplay');
        y1 = getam(BPMyFamily, BPMList);
        
        % Get a clean bump
        %vcm0= getsp(VCMFamily, VOCS.CM.DeviceList);
        figure(1);
        clf reset
        y2 = getam(BPMyFamily, BPMList);
        VOCS = setorbitbump(BPMyFamily, BPMList, DeltaY, VCMFamily, CMList, ...
            5,  BPMWeight, 'Inc', 'NoDisplay');
%        [VOCS, RF, VOCS0] = setorbitbump(BPMyFamily, BPMList, DeltaY, VCMFamily, CMList, 5, SVDIndex, BPMWeight, 'Inc', 'NoDisplay');
        y3 = getam(BPMyFamily, BPMList);
        drawnow;
        %vcm1= getsp(VCMFamily, VOCS.CM.DeviceList);
        DeltaVCM = (VOCS.CM.Data - VOCS0.CM.Data) / .2;  % amps/mm  (real units)
        BPMDeviceList = VOCS.BPM.DeviceList;
        VCMDeviceList = VOCS.CM.DeviceList;
        setsp(VCMFamily, VCM0);
        save(VerticalBumpFile, 'DeltaVCM', 'VCMDeviceList', 'BPMDeviceList', 'VOCS', 'VOCS0');
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Linearity and hystersis check %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Starting corrector values
    vcm0 = getsp(VCMFamily, VCMDeviceList);
    
    % Set hysteresis in an upward direction
    %setsp(VCMFamily, vcm0 - MaxChange * DeltaVCM, VCMDeviceList, -2);
    %setsp(VCMFamily, vcm0, VCMDeviceList);
    
    % Build loop
    Loop = [linspace(0,MaxChange,NSteps+1) ...
        linspace(MaxChange-MaxChange/NSteps,-MaxChange,2*NSteps) ...
        linspace(-MaxChange+MaxChange/NSteps,0,NSteps)];
    LoopTotal = [Loop Loop(2:end)];
    
    i = 0;
    for y = LoopTotal
        i = i + 1;
        setsp(VCMFamily, vcm0 + y * DeltaVCM, VCMDeviceList, -2);
        DCCT(i) = getdcct;
        VCMsp(:,i) = getsp(VCMFamily, VCMDeviceList);
        VCMam(:,i) = getam(VCMFamily, VCMDeviceList);
        %BPMx(:,i) = raw2real(BPMxFamily, getx);
        %BPMy(:,i) = raw2real(BPMyFamily, getz);
        BPMx(:,i) = getx;
        BPMy(:,i) = getz;
        
    end
    
    % Reset correctors
    setsp(VCMFamily, VCM0);
    
else
    error('Corrector magnet family unknown');
end


% Save data
HysteresisFilename = sprintf('Hysteresis%s', FileNumberString);
HysteresisFilename = appendtimestamp(HysteresisFilename);
save(HysteresisFilename);
fprintf('   Hysteresis data saved to %s.mat\n', HysteresisFilename);


% Plot results
clf reset
LineType = '.-b';
if size(BPMList,1) == 1    
    
    subplot(2,1,1);
    plot(LoopTotal, BPMy(BPMyIndex(1),:),LineType);
    xlabel(sprintf('Goal Orbit at %s(%d,%d) [mm]', BPMyFamily, BPMList(1,:)));
    ylabel(sprintf('%s(%d,%d) [mm]', BPMyFamily, BPMList(1,:)));
    
    subplot(2,1,2);
    plot(LoopTotal, BPMy(BPMyIndex(1),:)-LoopTotal,LineType);
    xlabel(sprintf('Goal Orbit at %s(%d,%d) [mm]', BPMyFamily, BPMList(1,:)));
    ylabel(sprintf('%s(%d,%d) Error [mm]', BPMyFamily, BPMList(1,:)));
    title('Hysteresis Loops');
    
else
    
    subplot(2,2,1);
    plot(LoopTotal, BPMy(BPMyIndex(1),:),LineType);
    xlabel(sprintf('Goal Orbit at %s(%d,%d) [mm]', BPMyFamily, BPMList(1,:)));
    ylabel(sprintf('%s(%d,%d) [mm]', BPMyFamily, BPMList(1,:)));
    grid on;

    subplot(2,2,3);
    plot(LoopTotal, BPMy(BPMyIndex(1),:)-LoopTotal,LineType);
    xlabel(sprintf('Goal Orbit at %s(%d,%d) [mm]', BPMyFamily, BPMList(1,:)));
    ylabel(sprintf('%s(%d,%d) Error [mm]', BPMyFamily, BPMList(1,:)));
    grid on;
    
    subplot(2,2,2);
    plot(LoopTotal, BPMy(BPMyIndex(2),:),LineType);
    xlabel(sprintf('Goal Orbit at %s(%d,%d) [mm]', BPMyFamily, BPMList(2,:)));
    ylabel(sprintf('%s(%d,%d) [mm]', BPMyFamily, BPMList(2,:)));
    grid on;
    
    subplot(2,2,4);
    plot(LoopTotal, BPMy(BPMyIndex(2),:)-LoopTotal,LineType);
    xlabel(sprintf('Goal Orbit at %s(%d,%d) [mm]', BPMyFamily, BPMList(2,:)));
    ylabel(sprintf('%s(%d,%d) Error [mm]', BPMyFamily, BPMList(2,:)));
    grid on;
    
    h = addlabel(.5, 1, 'Hysteresis Loops');
    set(h, 'Fontsize', 12);
    orient tall
    
end

