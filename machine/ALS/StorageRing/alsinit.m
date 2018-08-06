function alsinit(OperationalMode)
%ALSINIT - MML initialization file for the ALS

%  To do:
%  1. Remove IDBPM and BBPM?
%  2. VCBSC not fully setup (limits, tolerance, k2amp/amp2k) but not used
%  3. Look for all "???" text


% For the compiler
%#function gettune_als getrf_als setrf_als getsp_quadsum setsp_quadsum getsp_cmsum setsp_cmsum getrunflagcm getrunflagquad
     

if nargin < 1
    % 2010 two-bunch operation dates
    %      DateTwoBunchStart = [2010 8 3 0 0 0];
    %      DateTwoBunchEnd   = [2010 8 16 12 0 0];
    % 2011 two bunch operation dates
    % DateTwoBunchStart = [2011 3 8 16 0 0];
    % DateTwoBunchEnd   = [2011 3 21 0 0 0];
    % 2013 two bunch operation dates
    % DateTwoBunchStart = [2013 5 21 16 0 0];
    % DateTwoBunchEnd   = [2013 6 2 8 0 0];
    % DateTwoBunchStart = [2013 8 26 14 0 0];
    % DateTwoBunchEnd   = [2013 9 8 0 0 0];
    % 2014 two bunch operation dates
    % DateTwoBunchStart = [2014 3 4 15 0 0];
    % DateTwoBunchEnd   = [2014 3 17 8 0 0];
    % 2015 two bunch operation dates
    % DateTwoBunchStart = [2014 3 4 15 0 0];
    % DateTwoBunchEnd   = [2014 3 17 8 0 0];
%     DateTwoBunchStart = [2015 8 4 15 0 0];
%     DateTwoBunchEnd   = [2015 8 17 8 0 0];
%     DateTwoBunchStart = [2016 3 16 8 0 0];
%     DateTwoBunchEnd   = [2016 3 28 8 0 0];
%     DateTwoBunchStart = [2016 8 17 8 0 0];
%     DateTwoBunchEnd   = [2016 8 29 8 0 0];
    DateTwoBunchStart = [2017 6 20 14 0 0];
    DateTwoBunchEnd   = [2017 7 10  8 0 0];

    
    Date = clock;
    if etime(Date, DateTwoBunchStart)>0 && etime(Date, DateTwoBunchEnd)<0
        OperationalMode = 6;
        fprintf('   Default mode set to 1.9 GeV, 2-bunch for August 2016 run (alsinit)\n');
    else
         OperationalMode = 888;
         fprintf('   Default mode set to Pseudo-Single Bunch (0.18,0.25) (alsinit)\n');
%            OperationalMode = 6;
%           fprintf('   Default mode set to 1.9 GeV, 2-bunch (alsinit)\n');
%         OperationalMode = 10;
%         fprintf('   Default mode set to 1.9 GeV, Low Emittance Lattice (alsinit)\n');
%         OperationalMode = 1;
%         fprintf('   Default mode set to 1.9 GeV, TopOff Lattice - QFA limitation (alsinit)\n');
%         %         OperationalMode = 4;
%         %         fprintf('   Default mode set to 1.9 GeV, High Tune  (Old BR Bend in use) for the user run starting 6-25-08 (alsinit)\n');
    end
end

NoMerlin = 0;
NoEPU62 = 1; %IOC not serving PVs as of 1-10-2018, T.Scarvie
NoEPU71 = 0;
NoEPU72 = 0;
NoEPU112 = 0;

%%%%%%%%%%%%%%%%
% Build the AO %
%%%%%%%%%%%%%%%%
setao([]);
setad([]);

% Build common devicelist
BPMlist=zeros(96,2);
HCMlist=zeros(96,2);
VCMlist=zeros(72,2);
TwoPerSectorList=zeros(24,2);

for Sector = 1:12
    
    BPMlist(8*(Sector-1)+1:8*Sector,:) = [
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;];
    
    HCMlist(8*(Sector-1)+1:8*Sector,:) = [
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;
        Sector 6;
        Sector 7;
        Sector 8;];
    
    VCMlist(6*(Sector-1)+1:6*Sector,:) = [
        Sector 1;
        Sector 2;
        Sector 4;
        Sector 5;
        Sector 7;
        Sector 8;];
    
    TwoPerSectorList(2*(Sector-1)+1:2*Sector,:) = [
        Sector 1;
        Sector 2;];
end

% Remove correctors in sector 1 & 12
HCMlist = HCMlist(2:end-1,:);
VCMlist = VCMlist(2:end-1,:);

% Add [3 10], [5 10], [6 10] and [10 10]
i = findrowindex([10 8], HCMlist);
HCMlist = [HCMlist(1:i,:); [10 10]; HCMlist(i+1:end,:)];
i = findrowindex([ 6 8], HCMlist);
HCMlist = [HCMlist(1:i,:); [ 6 10]; HCMlist(i+1:end,:)];
i = findrowindex([ 5 8], HCMlist);
HCMlist = [HCMlist(1:i,:); [ 5 10]; HCMlist(i+1:end,:)];
i = findrowindex([ 3 8], HCMlist);
HCMlist = [HCMlist(1:i,:); [ 3 10]; HCMlist(i+1:end,:)];

i = findrowindex([10 8], VCMlist);
VCMlist = [VCMlist(1:i,:); [10 10]; VCMlist(i+1:end,:)];
i = findrowindex([ 6 8], VCMlist);
VCMlist = [VCMlist(1:i,:); [ 6 10]; VCMlist(i+1:end,:)];
i = findrowindex([ 5 8], VCMlist);
VCMlist = [VCMlist(1:i,:); [ 5 10]; VCMlist(i+1:end,:)];
i = findrowindex([ 3 8], VCMlist);
VCMlist = [VCMlist(1:i,:); [ 3 10]; VCMlist(i+1:end,:)];


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build Family Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%
% BPM Families %
%%%%%%%%%%%%%%%%
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM'; 'HBPM'; 'BPMx'; 'Horizontal';};
AO.BPMx.DeviceList = [
    1 2; 1 3; 1 4; 1 5; 1 6; 1 7; 1 8; 1 9;1 10
    2 1; 2 2; 2 3; 2 4; 2 5; 2 6; 2 7; 2 8; 2 9;
    3 2; 3 3; 3 4; 3 5; 3 6; 3 7; 3 8; 3 9; 3 10; 3 11; 3 12;
    4 1; 4 2; 4 3; 4 4; 4 5; 4 6; 4 7; 4 8; 4 9; 4 10;
    5 1; 5 2; 5 3; 5 4; 5 5; 5 6; 5 7; 5 8; 5 9; 5 10; 5 11; 5 12;
    6 1; 6 2; 6 3; 6 4; 6 5; 6 6; 6 7; 6 8; 6 9; 6 10; 6 11; 6 12;
    7 1; 7 2; 7 3; 7 4; 7 5; 7 6; 7 7; 7 8; 7 9; 7 10;
    8 1; 8 2; 8 3; 8 4; 8 5; 8 6; 8 7; 8 8; 8 9; 8 10;
    9 1; 9 2; 9 3; 9 4; 9 5; 9 6; 9 7; 9 8; 9 9; 9 10;
    10 1;10 2;10 3;10 4;10 5;10 6;10 7;10 8;10 9;10 10;10 11;10 12;
    11 1;11 2;11 3;11 4;11 5;11 6;11 7;11 8;11 9;11 10;
    12 1;12 2;12 3;12 4;12 5;12 6;12 7;12 8;12 9;
    ];
AO.BPMx.ElementList = 12*(AO.BPMx.DeviceList(:,1)-1)+AO.BPMx.DeviceList(:,2);
AO.BPMx.Status = ones(size(AO.BPMx.ElementList,1),1);
%iBad = [];
%iBad = findrowindex([1 10; 6 2; 8 7], AO.BPMx.DeviceList);
%iBad = findrowindex([1  7; 6 2;    ], AO.BPMx.DeviceList);


% [1 5] for BPM development
% [1 7] new BPM electronics, was for development work (was the BCM until it moved to an old TFB button)
% [2 1] Channel A rigid coax had a mangled center conductor (Fix 1/2/2016)
% [2 2] being used by TFB/LFB (basically perminently)
% [3 3] had a low channel D (fixed 10/2014)
% [4 2] has a low channel C (fixed 10/25/2016)
% [9 5] channel D is shorted at the button, C has unknown problem
% [9 8] had a low channel B (fixed 10/2014)
%iBad = findrowindex([1  5;1  7; 2 2; 3 3;4 2; 9 8], AO.BPMx.DeviceList);
%iBad = findrowindex([1  5; 2 2; ], AO.BPMx.DeviceList); 
%iBad = findrowindex([1 5; 1 7; 2 2; 9 5], AO.BPMx.DeviceList); 
iBad = findrowindex([1 5; 1 7; 2 2; 9 5], AO.BPMx.DeviceList); % Installed a working BPM in [1 7] and added back into BPMlist, 2017-09-11
AO.BPMx.Status(iBad) = 0;    % Remove bad BPMs

AO.BPMx.Monitor.MemberOf = {'BPM'; 'HBPM'; 'Horizontal'; 'Monitor'; 'measbpmresp'; 'Save';};
AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_als(AO.BPMx.FamilyName, AO.BPMx.DeviceList, 0);
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.Monitor.Physics2HWParams = 1000;
AO.BPMx.Monitor.Units            = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMx.Monitor.SpecialFunctionGet = @getbpm_als;


AO.BPMx.GoldenSetpoint.MemberOf = {'Save'};
AO.BPMx.GoldenSetpoint.Mode = 'Simulator';
AO.BPMx.GoldenSetpoint.DataType = 'Scalar';
% AO.BPMx.GoldenSetpoint.ChannelNames = strcat(AO.BPMx.Monitor.ChannelNames(:,1:end-4), 'GOLDEN');
AO.BPMx.GoldenSetpoint.ChannelNames = getname_als('BPMxGoldenSetpoint', AO.BPMx.DeviceList, 0);
AO.BPMx.GoldenSetpoint.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMx.GoldenSetpoint.Physics2HWParams = 1000;
AO.BPMx.GoldenSetpoint.Units            = 'Hardware';
AO.BPMx.GoldenSetpoint.HWUnits          = 'mm';
AO.BPMx.GoldenSetpoint.PhysicsUnits     = 'Meter';

% Clean up channels not there yet
AO.BPMx.GoldenSetpoint.ChannelNames( 4,:) = '                     ';
AO.BPMx.GoldenSetpoint.ChannelNames( 6,:) = '                     ';
AO.BPMx.GoldenSetpoint.ChannelNames(11,:) = '                     ';


AO.BPMx.TimeConstant.MemberOf = {'Setpoint'};
AO.BPMx.TimeConstant.Mode = 'Simulator';
AO.BPMx.TimeConstant.DataType = 'Scalar';
AO.BPMx.TimeConstant.ChannelNames = getname_als('BPMxTimeConstant', AO.BPMx.DeviceList, 0);
AO.BPMx.TimeConstant.HW2PhysicsParams = 1;
AO.BPMx.TimeConstant.Physics2HWParams = 1;
AO.BPMx.TimeConstant.Units            = 'Hardware';
AO.BPMx.TimeConstant.HWUnits          = '';
AO.BPMx.TimeConstant.PhysicsUnits     = '';

n = AO.BPMx.Monitor.ChannelNames;
%Name = zeros(size(n,1),19); Don't do this!
for i = 1:size(n,1)
    %fprintf('%d. %d %d %s\n', i, strcmpi(n(i,9),'B') , strcmpi(n(i,14),'X'), n(i,:));
    if strcmpi(n(i,9),'B')  && strcmpi(n(i,14),'X')
        % Old style BPM - get the block average
        Name(i,:) = sprintf('%s___BPMAVG%sAC99', n(i,1:5), n(i,12));
    else
        Name(i,:) = '                   ';
    end
end

AO.BPMx.NumberOfAverages.MemberOf = {'Setpoint'};
AO.BPMx.NumberOfAverages.Mode = 'Simulator';
AO.BPMx.NumberOfAverages.DataType = 'Scalar';
AO.BPMx.NumberOfAverages.ChannelNames = Name;
AO.BPMx.NumberOfAverages.HW2PhysicsParams = 1;
AO.BPMx.NumberOfAverages.Physics2HWParams = 1;
AO.BPMx.NumberOfAverages.Units = 'Hardware';
AO.BPMx.NumberOfAverages.HWUnits          = '';
AO.BPMx.NumberOfAverages.PhysicsUnits     = '';


AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'PlotFamily'; 'BPM'; 'VBPM'; 'BPMy'; 'Vertical';};
AO.BPMy.DeviceList = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status = ones(size(AO.BPMy.ElementList,1),1);
%AO.BPMy.Status(9) = 0;
AO.BPMy.Status(iBad) = 0;   % Remove bad BPMs

AO.BPMy.Monitor.MemberOf = {'BPM'; 'VBPM'; 'Vertical'; 'measbpmresp'; 'Monitor'; 'Save';};
AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_als(AO.BPMy.FamilyName, AO.BPMy.DeviceList, 0);
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.Monitor.Physics2HWParams = 1000;
AO.BPMy.Monitor.Units            = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
%AO.BPMy.Monitor.SpecialFunctionGet = @getbpm_als;

AO.BPMy.GoldenSetpoint.MemberOf = {'Save'};
AO.BPMy.GoldenSetpoint.Mode = 'Simulator';
AO.BPMy.GoldenSetpoint.DataType = 'Scalar';
% AO.BPMy.GoldenSetpoint.ChannelNames = strcat(AO.BPMy.Monitor.ChannelNames(:,1:end-4), 'GOLDEN');
AO.BPMy.GoldenSetpoint.ChannelNames = getname_als('BPMyGoldenSetpoint', AO.BPMy.DeviceList, 0);
AO.BPMy.GoldenSetpoint.HW2PhysicsParams = 1e-3;  % HW [mm], Simulator [Meters]
AO.BPMy.GoldenSetpoint.Physics2HWParams = 1000;
AO.BPMy.GoldenSetpoint.Units            = 'Hardware';
AO.BPMy.GoldenSetpoint.HWUnits          = 'mm';
AO.BPMy.GoldenSetpoint.PhysicsUnits     = 'Meter';

% Clean up channels not there yet
AO.BPMy.GoldenSetpoint.ChannelNames( 4,:) = '                     ';
AO.BPMy.GoldenSetpoint.ChannelNames( 6,:) = '                     ';
AO.BPMy.GoldenSetpoint.ChannelNames(11,:) = '                     ';

AO.BPMy.TimeConstant.MemberOf = {'Setpoint'};
AO.BPMy.TimeConstant.Mode = 'Simulator';
AO.BPMy.TimeConstant.DataType = 'Scalar';
AO.BPMy.TimeConstant.ChannelNames = getname_als('BPMyTimeConstant', AO.BPMy.DeviceList, 0);
AO.BPMy.TimeConstant.HW2PhysicsParams = 1;
AO.BPMy.TimeConstant.Physics2HWParams = 1;
AO.BPMy.TimeConstant.Units            = 'Hardware';
AO.BPMy.TimeConstant.HWUnits          = '';
AO.BPMy.TimeConstant.PhysicsUnits     = '';

AO.BPMy.NumberOfAverages = AO.BPMx.NumberOfAverages;


% Special vertical orbit family to remove the effect of the cam-kicker
%AO.BPMyCam.FamilyName = 'BPMyCam';     % Just a placeholder
%AO.BPMyCam.MemberOf   = {'PlotFamily'; 'Vertical';};


% BPM
setao(AO);
AO = buildmmlbpmfamily(AO, 'StorageRing');
AO = buildmmlbpmfamily(AO, 'SRTest');

% 

% % Replace [1 7] with new BPM (just happens to be BPM5 electronics)
% i = findrowindex([1 7], AO.BPMx.DeviceList);
% AO.BPMx.Monitor.ChannelNames(i,:) = 'SR01C:BPM5:SA:X    ';
% AO.BPMy.Monitor.ChannelNames(i,:) = 'SR01C:BPM5:SA:Y    ';

%%%%%%%%%%%%%%%%%%%%%%
% Corrector Families %
%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = HCMlist;
AO.HCM.ElementList = local_dev2elem('HCM', AO.HCM.DeviceList);
AO.HCM.Status = ones(size(HCMlist,1),1);
AO.HCM.Position = [];  % Just a place holder

for i = 1:size(AO.HCM.DeviceList,1)
    AO.HCM.BaseName{i,1} = '';
    AO.HCM.DeviceType{i,1} = '';
end
i = findrowindex([3 10], HCMlist);
AO.HCM.BaseName{i,1}   = 'SR04U:HCM2';
AO.HCM.DeviceType{i,1} = 'Caen SY3634';
i = findrowindex([5 10], HCMlist);
AO.HCM.BaseName{i,1}   = 'SR06U:HCM2';
AO.HCM.DeviceType{i,1} = 'Caen SY3634';
i = findrowindex([6 10], HCMlist);
AO.HCM.BaseName{i,1}   = 'SR07U:HCM2';
AO.HCM.DeviceType{i,1} = 'Caen SY3634';
i = findrowindex([10 10], HCMlist);
AO.HCM.BaseName{i,1}   = 'SR11U:HCM2';
AO.HCM.DeviceType{i,1} = 'Caen SY3634';

AO.HCM.Monitor.MemberOf = {'PlotFamily'; 'COR'; 'Horizontal'; 'HCM'; 'Magnet'; 'Monitor'; 'Save';};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_als(AO.HCM.FamilyName, AO.HCM.DeviceList, 0);
AO.HCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.HCM.Monitor.Physics2HWFcn = @k2amp;
AO.HCM.Monitor.Units        = 'Hardware';
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';

AO.HCM.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore'; 'COR'; 'Horizontal'; 'HCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_als(AO.HCM.FamilyName, AO.HCM.DeviceList, 1);
AO.HCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.HCM.Setpoint.Physics2HWFcn = @k2amp;
AO.HCM.Setpoint.Units        = 'Hardware';
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.RunFlagFcn = @getrunflagcm;

AO.HCM.Trim.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Trim.Mode = 'Simulator';
AO.HCM.Trim.DataType = 'Scalar';
AO.HCM.Trim.ChannelNames = getname_als('HCMtrim', AO.HCM.DeviceList, 1);
AO.HCM.Trim.HW2PhysicsFcn = @amp2k;
AO.HCM.Trim.Physics2HWFcn = @k2amp;
AO.HCM.Trim.Units        = 'Hardware';
AO.HCM.Trim.HWUnits      = 'Ampere';
AO.HCM.Trim.PhysicsUnits = 'Radian';
AO.HCM.Trim.RunFlagFcn = @getrunflagcm;

AO.HCM.FF1.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.FF1.Mode = 'Simulator';
AO.HCM.FF1.DataType = 'Scalar';
AO.HCM.FF1.ChannelNames = getname_als('HCMFF1', AO.HCM.DeviceList, 1);
AO.HCM.FF1.HW2PhysicsFcn = @amp2k;
AO.HCM.FF1.Physics2HWFcn = @k2amp;
AO.HCM.FF1.Units        = 'Hardware';
AO.HCM.FF1.HWUnits      = 'Ampere';
AO.HCM.FF1.PhysicsUnits = 'Radian';
AO.HCM.FF1.RunFlagFcn = @getrunflagcm;
% AO.HCM.FF1.SpecialFunctionSet = @setsp_cmff;
% AO.HCM.FF1.SpecialFunctionGet = @getsp_cmff;

AO.HCM.FF2.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.FF2.Mode = 'Simulator';
AO.HCM.FF2.DataType = 'Scalar';
AO.HCM.FF2.ChannelNames = getname_als('HCMFF2', AO.HCM.DeviceList, 1);
AO.HCM.FF2.HW2PhysicsFcn = @amp2k;
AO.HCM.FF2.Physics2HWFcn = @k2amp;
AO.HCM.FF2.Units        = 'Hardware';
AO.HCM.FF2.HWUnits      = 'Ampere';
AO.HCM.FF2.PhysicsUnits = 'Radian';
AO.HCM.FF2.RunFlagFcn = @getrunflagcm;
% AO.HCM.FF2.SpecialFunctionSet = @setsp_cmff;
% AO.HCM.FF2.SpecialFunctionGet = @getsp_cmff;

AO.HCM.FFMultiplier.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint';};
AO.HCM.FFMultiplier.Mode = 'Simulator';
AO.HCM.FFMultiplier.DataType = 'Scalar';
AO.HCM.FFMultiplier.ChannelNames = getname_als('HCMFF2', AO.HCM.DeviceList, 1);  % Just to fill the matrix
AO.HCM.FFMultiplier.HW2PhysicsParams = 1;
AO.HCM.FFMultiplier.Physics2HWParams = 1;
AO.HCM.FFMultiplier.Units        = 'Hardware';
AO.HCM.FFMultiplier.HWUnits      = '';
AO.HCM.FFMultiplier.PhysicsUnits = '';

% Sector 4
i = findrowindex('SR03C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR03C___HCM4M__AC00';
i = findrowindex('SR04U___HCM2', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR04U___HCM2M__AC00';
i = findrowindex('SR04C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR04C___HCM1M__AC00';

% Sector 5
i = findrowindex('SR04C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR04C___HCM4M__AC00';
i = findrowindex('SR05C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR05C___HCM1M__AC00';

% Sector 6
i = findrowindex('SR05C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR05C___HCM4M__AC00';
i = findrowindex('SR06U___HCM2', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR06U___HCM2M__AC00';
i = findrowindex('SR06C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR06C___HCM1M__AC00';

% Sector 7
i = findrowindex('SR06C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR06C___HCM4M__AC00';
i = findrowindex('SR07U___HCM2', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR07U___HCM2M__AC00';
i = findrowindex('SR07C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR07C___HCM1M__AC00';

% Sector 8
i = findrowindex('SR07C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR07C___HCM4M__AC00';
i = findrowindex('SR08C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR08C___HCM1M__AC00';

% Sector 9
i = findrowindex('SR08C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR08C___HCM4M__AC00';
i = findrowindex('SR09C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR09C___HCM1M__AC00';

% Sector 10
i = findrowindex('SR09C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR09C___HCM4M__AC00';
i = findrowindex('SR10C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR10C___HCM1M__AC00';

% Sector 11
i = findrowindex('SR10C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR10C___HCM4M__AC00';
i = findrowindex('SR11U___HCM2', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR11U___HCM2M__AC00';
i = findrowindex('SR11C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR11C___HCM1M__AC00';

% Sector 12
i = findrowindex('SR11C___HCM4', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR11C___HCM4M__AC00';
i = findrowindex('SR12C___HCM1', AO.HCM.Setpoint.ChannelNames(:,1:12));
AO.HCM.FFMultiplier.ChannelNames(i, :) = 'SR12C___HCM1M__AC00';

AO.HCM.Sum.MemberOf = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Sum.Mode = 'Simulator';
AO.HCM.Sum.DataType = 'Scalar';
% % Channel names are not used if a Special function is defined
% AO.HCM.Sum.ChannelNames = getname_als('HCMdac', AO.HCM.DeviceList, 1);
% i = find(AO.HCM.Sum.ChannelNames(:,1)=='S');
% AO.HCM.Sum.ChannelNames(i,13) = 'J';
% AO.HCM.Sum.ChannelNames(i,18) = '0';
% AO.HCM.Sum.ChannelNames(i,19) = '0';
AO.HCM.Sum.HW2PhysicsFcn = @amp2k;
AO.HCM.Sum.Physics2HWFcn = @k2amp;
AO.HCM.Sum.Units        = 'Hardware';
AO.HCM.Sum.HWUnits      = 'Ampere';
AO.HCM.Sum.PhysicsUnits = 'Radian';
AO.HCM.Sum.RunFlagFcn = @getrunflagcm;
AO.HCM.Sum.SpecialFunctionSet = @setsp_cmsum;
AO.HCM.Sum.SpecialFunctionGet = @getsp_cmsum;

AO.HCM.DAC.MemberOf = {'PlotFamily'; 'Save';};
AO.HCM.DAC.Mode = 'Simulator';
AO.HCM.DAC.DataType = 'Scalar';
AO.HCM.DAC.ChannelNames = getname_als('HCMdac', AO.HCM.DeviceList, 1);
AO.HCM.DAC.HW2PhysicsParams = 1;
AO.HCM.DAC.Physics2HWParams = 1;
AO.HCM.DAC.Units        = 'Hardware';
AO.HCM.DAC.HWUnits      = 'Ampere';
AO.HCM.DAC.PhysicsUnits = 'Ampere';

AO.HCM.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.HCM.RampRate.Mode = 'Simulator';
AO.HCM.RampRate.DataType = 'Scalar';
AO.HCM.RampRate.ChannelNames = getname_als('HCMramprate', AO.HCM.DeviceList, 1);
AO.HCM.RampRate.HW2PhysicsParams = 1;
AO.HCM.RampRate.Physics2HWParams = 1;
AO.HCM.RampRate.Units        = 'Hardware';
AO.HCM.RampRate.HWUnits      = 'Ampere/Second';
AO.HCM.RampRate.PhysicsUnits = 'Ampere/Second';

AO.HCM.TimeConstant.MemberOf = {'PlotFamily';};
AO.HCM.TimeConstant.Mode = 'Simulator';
AO.HCM.TimeConstant.DataType = 'Scalar';
AO.HCM.TimeConstant.ChannelNames = getname_als('HCMtimeconstant', AO.HCM.DeviceList, 1);
AO.HCM.TimeConstant.HW2PhysicsParams = 1;
AO.HCM.TimeConstant.Physics2HWParams = 1;
AO.HCM.TimeConstant.Units        = 'Hardware';
AO.HCM.TimeConstant.HWUnits      = 'Second';
AO.HCM.TimeConstant.PhysicsUnits = 'Second';

AO.HCM.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.HCM.OnControl.Mode = 'Simulator';
AO.HCM.OnControl.DataType = 'Scalar';
AO.HCM.OnControl.ChannelNames = getname_als('HCMon', AO.HCM.DeviceList, 1);
AO.HCM.OnControl.HW2PhysicsParams = 1;
AO.HCM.OnControl.Physics2HWParams = 1;
AO.HCM.OnControl.Units        = 'Hardware';
AO.HCM.OnControl.HWUnits      = '';
AO.HCM.OnControl.PhysicsUnits = '';
AO.HCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.HCM.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.HCM.On.Mode = 'Simulator';
AO.HCM.On.DataType = 'Scalar';
AO.HCM.On.ChannelNames = getname_als('HCMon', AO.HCM.DeviceList, 0);
AO.HCM.On.HW2PhysicsParams = 1;
AO.HCM.On.Physics2HWParams = 1;
AO.HCM.On.Units        = 'Hardware';
AO.HCM.On.HWUnits      = '';
AO.HCM.On.PhysicsUnits = '';

AO.HCM.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.HCM.Reset.Mode = 'Simulator';
AO.HCM.Reset.DataType = 'Scalar';
AO.HCM.Reset.ChannelNames = getname_als('HCMreset', AO.HCM.DeviceList, 1);
AO.HCM.Reset.HW2PhysicsParams = 1;
AO.HCM.Reset.Physics2HWParams = 1;
AO.HCM.Reset.Units        = 'Hardware';
AO.HCM.Reset.HWUnits      = '';
AO.HCM.Reset.PhysicsUnits = '';

AO.HCM.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.HCM.Ready.Mode = 'Simulator';
AO.HCM.Ready.DataType = 'Scalar';
AO.HCM.Ready.ChannelNames = getname_als('HCMready', AO.HCM.DeviceList, 0);
AO.HCM.Ready.HW2PhysicsParams = 1;
AO.HCM.Ready.Physics2HWParams = 1;
AO.HCM.Ready.Units        = 'Hardware';
AO.HCM.Ready.HWUnits      = '';
AO.HCM.Ready.PhysicsUnits = '';


AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'COR'; 'VCM'; 'Vertical'; 'Magnet';};
AO.VCM.DeviceList = VCMlist;
AO.VCM.ElementList = local_dev2elem('VCM', AO.VCM.DeviceList);
AO.VCM.Status = ones(size(VCMlist,1),1);
AO.VCM.Position = [];  % Just a place holder

for i = 1:size(AO.VCM.DeviceList,1)
    AO.VCM.BaseName{i,1} = '';
    AO.VCM.DeviceType{i,1} = '';
end
i = findrowindex([3 10], VCMlist);
AO.VCM.BaseName{i,1}   = 'SR04U:VCM2';
AO.VCM.DeviceType{i,1} = 'Caen SY3634';
i = findrowindex([5 10], VCMlist);
AO.VCM.BaseName{i,1}   = 'SR06U:VCM2';
AO.VCM.DeviceType{i,1} = 'Caen SY3634';
i = findrowindex([6 10], VCMlist);
AO.VCM.BaseName{i,1}   = 'SR07U:VCM2';
AO.VCM.DeviceType{i,1} = 'Caen SY3634';
i = findrowindex([10 10], VCMlist);
AO.VCM.BaseName{i,1}   = 'SR11U:VCM2';
AO.VCM.DeviceType{i,1} = 'Caen SY3634';

% AO.VCM.BaseName{18,1}   = 'SR04U:VCM2';
% AO.VCM.DeviceType{18,1} = 'Caen SY3634';

AO.VCM.Monitor.MemberOf = {'PlotFamily'; 'COR'; 'Vertical'; 'VCM'; 'Magnet'; 'Monitor'; 'Save';};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_als(AO.VCM.FamilyName, AO.VCM.DeviceList, 0);
AO.VCM.Monitor.HW2PhysicsFcn = @amp2k;
AO.VCM.Monitor.Physics2HWFcn = @k2amp;
AO.VCM.Monitor.Units        = 'Hardware';
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';

AO.VCM.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'; 'measbpmresp';};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_als(AO.VCM.FamilyName, AO.VCM.DeviceList, 1);
AO.VCM.Setpoint.HW2PhysicsFcn = @amp2k;
AO.VCM.Setpoint.Physics2HWFcn = @k2amp;
AO.VCM.Setpoint.Units        = 'Hardware';
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.RunFlagFcn = @getrunflagcm;

AO.VCM.Trim.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Trim.Mode = 'Simulator';
AO.VCM.Trim.DataType = 'Scalar';
AO.VCM.Trim.ChannelNames = getname_als('VCMtrim', AO.VCM.DeviceList, 1);
AO.VCM.Trim.HW2PhysicsFcn = @amp2k;
AO.VCM.Trim.Physics2HWFcn = @k2amp;
AO.VCM.Trim.Units        = 'Hardware';
AO.VCM.Trim.HWUnits      = 'Ampere';
AO.VCM.Trim.PhysicsUnits = 'Radian';
AO.VCM.Trim.RunFlagFcn = @getrunflagcm;

AO.VCM.FF1.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.FF1.Mode = 'Simulator';
AO.VCM.FF1.DataType = 'Scalar';
AO.VCM.FF1.ChannelNames = getname_als('VCMFF1', AO.VCM.DeviceList, 1);
AO.VCM.FF1.HW2PhysicsFcn = @amp2k;
AO.VCM.FF1.Physics2HWFcn = @k2amp;
AO.VCM.FF1.Units        = 'Hardware';
AO.VCM.FF1.HWUnits      = 'Ampere';
AO.VCM.FF1.PhysicsUnits = 'Radian';
AO.VCM.FF1.RunFlagFcn = @getrunflagcm;
% AO.VCM.FF1.SpecialFunctionSet = @setsp_cmff;
% AO.VCM.FF1.SpecialFunctionGet = @getsp_cmff;

AO.VCM.FF2.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.FF2.Mode = 'Simulator';
AO.VCM.FF2.DataType = 'Scalar';
AO.VCM.FF2.ChannelNames = getname_als('VCMFF2', AO.VCM.DeviceList, 1);
AO.VCM.FF2.HW2PhysicsFcn = @amp2k;
AO.VCM.FF2.Physics2HWFcn = @k2amp;
AO.VCM.FF2.Units        = 'Hardware';
AO.VCM.FF2.HWUnits      = 'Ampere';
AO.VCM.FF2.PhysicsUnits = 'Radian';
AO.VCM.FF2.RunFlagFcn = @getrunflagcm;
% AO.VCM.FF2.SpecialFunctionSet = @setsp_cmff;
% AO.VCM.FF2.SpecialFunctionGet = @getsp_cmff;


AO.VCM.FFMultiplier.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint';};
AO.VCM.FFMultiplier.Mode = 'Simulator';
AO.VCM.FFMultiplier.DataType = 'Scalar';
AO.VCM.FFMultiplier.ChannelNames = getname_als('VCMFF2', AO.VCM.DeviceList, 1);  % Just to fill the matrix
AO.VCM.FFMultiplier.HW2PhysicsParams = 1;
AO.VCM.FFMultiplier.Physics2HWParams = 1;
AO.VCM.FFMultiplier.Units        = 'Hardware';
AO.VCM.FFMultiplier.HWUnits      = '';
AO.VCM.FFMultiplier.PhysicsUnits = '';

% Sector 4
i = findrowindex('SR03C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR03C___VCM4M__AC00';
i = findrowindex('SR04U___VCM2', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR04U___VCM2M__AC00';
i = findrowindex('SR04C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR04C___VCM1M__AC00';

% Sector 5
i = findrowindex('SR04C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR04C___VCM4M__AC00';
i = findrowindex('SR05C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR05C___VCM1M__AC00';

% Sector 6
i = findrowindex('SR05C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR05C___VCM4M__AC00';
i = findrowindex('SR06U___VCM2', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR06U___VCM2M__AC00';
i = findrowindex('SR06C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR06C___VCM1M__AC00';

% Sector 7
i = findrowindex('SR06C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR06C___VCM4M__AC00';
i = findrowindex('SR07U___VCM2', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR07U___VCM2M__AC00';
i = findrowindex('SR07C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR07C___VCM1M__AC00';

% Sector 8
i = findrowindex('SR07C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR07C___VCM4M__AC00';
i = findrowindex('SR08C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR08C___VCM1M__AC00';

% Sector 9
i = findrowindex('SR08C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR08C___VCM4M__AC00';
i = findrowindex('SR09C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR09C___VCM1M__AC00';

% Sector 10
i = findrowindex('SR09C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR09C___VCM4M__AC00';
i = findrowindex('SR10C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR10C___VCM1M__AC00';

% Sector 11
i = findrowindex('SR10C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR10C___VCM4M__AC00';
i = findrowindex('SR11U___VCM2', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR11U___VCM2M__AC00';
i = findrowindex('SR11C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR11C___VCM1M__AC00';

% Sector 12
i = findrowindex('SR11C___VCM4', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR11C___VCM4M__AC00';
i = findrowindex('SR12C___VCM1', AO.VCM.Setpoint.ChannelNames(:,1:12));
AO.VCM.FFMultiplier.ChannelNames(i, :) = 'SR12C___VCM1M__AC00';

AO.VCM.Sum.MemberOf = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Sum.Mode = 'Simulator';
AO.VCM.Sum.DataType = 'Scalar';
% % Channel names are not used if a Special function is defined
% AO.VCM.Sum.ChannelNames = getname_als('VCMdac', AO.VCM.DeviceList, 1);
% i = find(AO.VCM.Sum.ChannelNames(:,1)=='S');
% AO.VCM.Sum.ChannelNames(i,13) = 'J';
% AO.VCM.Sum.ChannelNames(i,18) = '0';
% AO.VCM.Sum.ChannelNames(i,19) = '0';
AO.VCM.Sum.HW2PhysicsFcn = @amp2k;
AO.VCM.Sum.Physics2HWFcn = @k2amp;
AO.VCM.Sum.Units        = 'Hardware';
AO.VCM.Sum.HWUnits      = 'Ampere';
AO.VCM.Sum.PhysicsUnits = 'Radian';
AO.VCM.Sum.RunFlagFcn = @getrunflagcm;
AO.VCM.Sum.SpecialFunctionSet = @setsp_cmsum;
AO.VCM.Sum.SpecialFunctionGet = @getsp_cmsum;

AO.VCM.DAC.MemberOf = {'PlotFamily'; 'Save';};
AO.VCM.DAC.Mode = 'Simulator';
AO.VCM.DAC.DataType = 'Scalar';
AO.VCM.DAC.ChannelNames = getname_als('VCMdac', AO.VCM.DeviceList, 1);
AO.VCM.DAC.HW2PhysicsParams = 1;
AO.VCM.DAC.Physics2HWParams = 1;
AO.VCM.DAC.Units        = 'Hardware';
AO.VCM.DAC.HWUnits      = 'Ampere';
AO.VCM.DAC.PhysicsUnits = 'Ampere';

AO.VCM.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.VCM.RampRate.Mode = 'Simulator';
AO.VCM.RampRate.DataType = 'Scalar';
AO.VCM.RampRate.ChannelNames = getname_als('VCMramprate', AO.VCM.DeviceList, 1);
AO.VCM.RampRate.HW2PhysicsParams = 1;
AO.VCM.RampRate.Physics2HWParams = 1;
AO.VCM.RampRate.Units        = 'Hardware';
AO.VCM.RampRate.HWUnits      = 'Ampere/Second';
AO.VCM.RampRate.PhysicsUnits = 'Ampere/Second';

AO.VCM.TimeConstant.MemberOf = {'PlotFamily';};
AO.VCM.TimeConstant.Mode = 'Simulator';
AO.VCM.TimeConstant.DataType = 'Scalar';
AO.VCM.TimeConstant.ChannelNames = getname_als('VCMtimeconstant', AO.VCM.DeviceList, 1);
AO.VCM.TimeConstant.HW2PhysicsParams = 1;
AO.VCM.TimeConstant.Physics2HWParams = 1;
AO.VCM.TimeConstant.Units        = 'Hardware';
AO.VCM.TimeConstant.HWUnits      = 'Second';
AO.VCM.TimeConstant.PhysicsUnits = 'Second';

AO.VCM.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.VCM.OnControl.Mode = 'Simulator';
AO.VCM.OnControl.DataType = 'Scalar';
AO.VCM.OnControl.ChannelNames = getname_als('VCMon', AO.VCM.DeviceList, 1);
AO.VCM.OnControl.HW2PhysicsParams = 1;
AO.VCM.OnControl.Physics2HWParams = 1;
AO.VCM.OnControl.Units        = 'Hardware';
AO.VCM.OnControl.HWUnits      = '';
AO.VCM.OnControl.PhysicsUnits = '';
AO.VCM.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.VCM.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.VCM.On.Mode = 'Simulator';
AO.VCM.On.DataType = 'Scalar';
AO.VCM.On.ChannelNames = getname_als('VCMon', AO.VCM.DeviceList, 0);
AO.VCM.On.HW2PhysicsParams = 1;
AO.VCM.On.Physics2HWParams = 1;
AO.VCM.On.Units        = 'Hardware';
AO.VCM.On.HWUnits      = '';
AO.VCM.On.PhysicsUnits = '';

AO.VCM.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.VCM.Reset.Mode = 'Simulator';
AO.VCM.Reset.DataType = 'Scalar';
AO.VCM.Reset.ChannelNames = getname_als('VCMreset', AO.VCM.DeviceList, 1);
AO.VCM.Reset.HW2PhysicsParams = 1;
AO.VCM.Reset.Physics2HWParams = 1;
AO.VCM.Reset.Units        = 'Hardware';
AO.VCM.Reset.HWUnits      = '';
AO.VCM.Reset.PhysicsUnits = '';

AO.VCM.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.VCM.Ready.Mode = 'Simulator';
AO.VCM.Ready.DataType = 'Scalar';
AO.VCM.Ready.ChannelNames = getname_als('VCMready', AO.VCM.DeviceList, 0);
AO.VCM.Ready.HW2PhysicsParams = 1;
AO.VCM.Ready.Physics2HWParams = 1;
AO.VCM.Ready.Units        = 'Hardware';
AO.VCM.Ready.HWUnits      = 'Second';
AO.VCM.Ready.PhysicsUnits = 'Second';


%%%%%%%%%%%%%%%%%%%%%%%
% Quadrupole Families %
%%%%%%%%%%%%%%%%%%%%%%%
[Gain, Offset] = QFQDMonitorGainOffset;

AO.QF.FamilyName = 'QF';
AO.QF.MemberOf   = {'Tune Corrector'; 'QF'; 'QUAD'; 'Magnet';};
AO.QF.DeviceList = TwoPerSectorList;
AO.QF.ElementList = local_dev2elem('QF', AO.QF.DeviceList);
AO.QF.Status = 1;

AO.QF.Monitor.MemberOf = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'; 'Monitor'; 'Save';};
AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_als(AO.QF.FamilyName, AO.QF.DeviceList, 0);
AO.QF.Monitor.HW2PhysicsFcn = @amp2k;
AO.QF.Monitor.Physics2HWFcn = @k2amp;
%AO.QF.Monitor.Physics2HWParams = (74.8377/2.2103);
%AO.QF.Monitor.HW2PhysicsParams = (2.2103/74.8377);    % K/Ampere:  HW2Physics*Amps=K
AO.QF.Monitor.Units        = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = '1/Meter^2';
AO.QF.Monitor.Gain = Gain(:,1);
AO.QF.Monitor.Offset = Offset(:,1);


AO.QF.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore'; 'QF'; 'QUAD'; 'Magnet';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_als(AO.QF.FamilyName, AO.QF.DeviceList, 1);
AO.QF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QF.Setpoint.Physics2HWFcn = @k2amp;
%AO.QF.Setpoint.HW2PhysicsParams = (2.2103/74.8377);    % K/Ampere:  HW2Physics*Amps=K
%AO.QF.Setpoint.Physics2HWParams = (74.8377/2.2103);
AO.QF.Setpoint.Units        = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = '1/Meter^2';
AO.QF.Setpoint.RunFlagFcn = @getrunflagquad;

AO.QF.FF.MemberOf = {'PlotFamily';};
AO.QF.FF.Mode = 'Simulator';
AO.QF.FF.DataType = 'Scalar';
AO.QF.FF.ChannelNames = getname_als('QFFF', AO.QF.DeviceList);
AO.QF.FF.HW2PhysicsFcn = @amp2k;
AO.QF.FF.Physics2HWFcn = @k2amp;
%AO.QF.FF.HW2PhysicsParams = (2.2103/74.8377);    % K/Ampere:  HW2Physics*Amps=K
%AO.QF.FF.Physics2HWParams = (74.8377/2.2103);
AO.QF.FF.Units        = 'Hardware';
AO.QF.FF.HWUnits      = 'Ampere';
AO.QF.FF.PhysicsUnits = '1/Meter^2';
AO.QF.FF.RunFlagFcn = @getrunflagquad;

AO.QF.FFMultiplier.MemberOf = {'PlotFamily';};
AO.QF.FFMultiplier.Mode = 'Simulator';
AO.QF.FFMultiplier.DataType = 'Scalar';
AO.QF.FFMultiplier.ChannelNames = getname_als('QFM', AO.QF.DeviceList);
AO.QF.FFMultiplier.HW2PhysicsParams = 1;
AO.QF.FFMultiplier.Physics2HWParams = 1;
AO.QF.FFMultiplier.Units        = 'Hardware';
AO.QF.FFMultiplier.HWUnits      = '';
AO.QF.FFMultiplier.PhysicsUnits = '';

AO.QF.Sum.MemberOf = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'; 'Setpoint'};
AO.QF.Sum.Mode = 'Simulator';
AO.QF.Sum.DataType = 'Scalar';
AO.QF.Sum.HW2PhysicsFcn = @amp2k;
AO.QF.Sum.Physics2HWFcn = @k2amp;
AO.QF.Sum.Units        = 'Hardware';
AO.QF.Sum.HWUnits      = 'Ampere';
AO.QF.Sum.PhysicsUnits = 'Radian';
AO.QF.Sum.RunFlagFcn = @getrunflagquad;
AO.QF.Sum.SpecialFunctionSet = @setsp_quadsum;
AO.QF.Sum.SpecialFunctionGet = @getsp_quadsum;

AO.QF.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.QF.RampRate.Mode = 'Simulator';
AO.QF.RampRate.DataType = 'Scalar';
AO.QF.RampRate.ChannelNames = getname_als('QFramprate', AO.QF.DeviceList, 1);
AO.QF.RampRate.HW2PhysicsFcn = @amp2k;
AO.QF.RampRate.Physics2HWFcn = @k2amp;
%AO.QF.RampRate.HW2PhysicsParams = 1;
%AO.QF.RampRate.Physics2HWParams = 1;
AO.QF.RampRate.Units        = 'Hardware';
AO.QF.RampRate.HWUnits      = 'Ampere/Second';
AO.QF.RampRate.PhysicsUnits = 'Ampere/Second';

AO.QF.TimeConstant.MemberOf = {'PlotFamily'; 'Save';};
AO.QF.TimeConstant.Mode = 'Simulator';
AO.QF.TimeConstant.DataType = 'Scalar';
AO.QF.TimeConstant.ChannelNames = getname_als('QFtimeconstant', AO.QF.DeviceList, 1);
AO.QF.TimeConstant.HW2PhysicsParams = 1;
AO.QF.TimeConstant.Physics2HWParams = 1;
AO.QF.TimeConstant.Units        = 'Hardware';
AO.QF.TimeConstant.HWUnits      = 'Second';
AO.QF.TimeConstant.PhysicsUnits = 'Second';

AO.QF.DAC.MemberOf = {'PlotFamily'; 'Save';};
AO.QF.DAC.Mode = 'Simulator';
AO.QF.DAC.DataType = 'Scalar';
AO.QF.DAC.ChannelNames = getname_als('QFdac', AO.QF.DeviceList, 1);
AO.QF.DAC.HW2PhysicsParams = 1;
AO.QF.DAC.Physics2HWParams = 1;
AO.QF.DAC.Units        = 'Hardware';
AO.QF.DAC.HWUnits      = 'Ampere';
AO.QF.DAC.PhysicsUnits = 'Ampere';

AO.QF.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.QF.OnControl.Mode = 'Simulator';
AO.QF.OnControl.DataType = 'Scalar';
AO.QF.OnControl.ChannelNames = getname_als('QFon', AO.QF.DeviceList, 1);
AO.QF.OnControl.HW2PhysicsParams = 1;
AO.QF.OnControl.Physics2HWParams = 1;
AO.QF.OnControl.Units        = 'Hardware';
AO.QF.OnControl.HWUnits      = '';
AO.QF.OnControl.PhysicsUnits = '';
AO.QF.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.QF.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.QF.On.Mode = 'Simulator';
AO.QF.On.DataType = 'Scalar';
AO.QF.On.ChannelNames = getname_als('QFon', AO.QF.DeviceList, 0);
AO.QF.On.HW2PhysicsParams = 1;
AO.QF.On.Physics2HWParams = 1;
AO.QF.On.Units        = 'Hardware';
AO.QF.On.HWUnits      = '';
AO.QF.On.PhysicsUnits = '';

AO.QF.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.QF.Reset.Mode = 'Simulator';
AO.QF.Reset.DataType = 'Scalar';
AO.QF.Reset.ChannelNames = getname_als('QFreset', AO.QF.DeviceList, 1);
AO.QF.Reset.HW2PhysicsParams = 1;
AO.QF.Reset.Physics2HWParams = 1;
AO.QF.Reset.Units        = 'Hardware';
AO.QF.Reset.HWUnits      = '';
AO.QF.Reset.PhysicsUnits = '';

AO.QF.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.QF.Ready.Mode = 'Simulator';
AO.QF.Ready.DataType = 'Scalar';
AO.QF.Ready.ChannelNames = getname_als('QFready', AO.QF.DeviceList, 0);
AO.QF.Ready.HW2PhysicsParams = 1;
AO.QF.Ready.Physics2HWParams = 1;
AO.QF.Ready.Units        = 'Hardware';
AO.QF.Ready.HWUnits      = '';
AO.QF.Ready.PhysicsUnits = '';


AO.QD.FamilyName = 'QD';
AO.QD.MemberOf   = {'Tune Corrector'; 'QD'; 'QUAD'; 'Magnet'};
AO.QD.DeviceList = TwoPerSectorList;
AO.QD.ElementList = local_dev2elem('QD', AO.QD.DeviceList);
AO.QD.Status = 1;

AO.QD.Monitor.MemberOf = {'PlotFamily'; 'QD'; 'QUAD'; 'Magnet'; 'Monitor'; 'Save';};
AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_als(AO.QD.FamilyName, AO.QD.DeviceList, 0);
AO.QD.Monitor.HW2PhysicsFcn = @amp2k;
AO.QD.Monitor.Physics2HWFcn = @k2amp;
%AO.QD.Monitor.HW2PhysicsParams = (-2.3366/77.3692);    % K/Ampere:  HW2Physics*Amps=K
%AO.QD.Monitor.Physics2HWParams = (77.3692/-2.3366);
AO.QD.Monitor.Units        = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = '1/Meter^2';
AO.QD.Monitor.Gain = Gain(:,2);
AO.QD.Monitor.Offset = Offset(:,2);

AO.QD.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore'; 'QD'; 'QUAD'; 'Magnet';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_als(AO.QD.FamilyName, AO.QF.DeviceList, 1);
AO.QD.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QD.Setpoint.Physics2HWFcn = @k2amp;
%AO.QD.Setpoint.HW2PhysicsParams = (-2.3366/77.3692);    % K/Ampere:  HW2Physics*Amps=K
%AO.QD.Setpoint.Physics2HWParams = (77.3692/-2.3366);
AO.QD.Setpoint.Units        = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = '1/Meter^2';
AO.QD.Setpoint.RunFlagFcn = @getrunflagquad;

AO.QD.FF.MemberOf = {'PlotFamily';};
AO.QD.FF.Mode = 'Simulator';
AO.QD.FF.DataType = 'Scalar';
AO.QD.FF.ChannelNames = getname_als('QDFF', AO.QF.DeviceList);
AO.QD.FF.HW2PhysicsFcn = @amp2k;
AO.QD.FF.Physics2HWFcn = @k2amp;
%AO.QD.FF.HW2PhysicsParams = (-2.3366/77.3692);    % K/Ampere:  HW2Physics*Amps=K
%AO.QD.FF.Physics2HWParams = (77.3692/-2.3366);
AO.QD.FF.Units        = 'Hardware';
AO.QD.FF.HWUnits      = 'Ampere';
AO.QD.FF.PhysicsUnits = '1/Meter^2';
AO.QD.FF.RunFlagFcn = @getrunflagquad;

AO.QD.FFMultiplier.MemberOf = {'PlotFamily';};
AO.QD.FFMultiplier.Mode = 'Simulator';
AO.QD.FFMultiplier.DataType = 'Scalar';
AO.QD.FFMultiplier.ChannelNames = getname_als('QDM', AO.QD.DeviceList);
AO.QD.FFMultiplier.HW2PhysicsParams = 1;
AO.QD.FFMultiplier.Physics2HWParams = 1;
AO.QD.FFMultiplier.Units        = 'Hardware';
AO.QD.FFMultiplier.HWUnits      = '';
AO.QD.FFMultiplier.PhysicsUnits = '';

AO.QD.Sum.MemberOf = {'PlotFamily'; 'QD'; 'QUAD'; 'Magnet'; 'Setpoint'};
AO.QD.Sum.Mode = 'Simulator';
AO.QD.Sum.DataType = 'Scalar';
AO.QD.Sum.HW2PhysicsFcn = @amp2k;
AO.QD.Sum.Physics2HWFcn = @k2amp;
AO.QD.Sum.Units        = 'Hardware';
AO.QD.Sum.HWUnits      = 'Ampere';
AO.QD.Sum.PhysicsUnits = 'Radian';
AO.QD.Sum.RunFlagFcn = @getrunflagquad;
AO.QD.Sum.SpecialFunctionSet = @setsp_quadsum;
AO.QD.Sum.SpecialFunctionGet = @getsp_quadsum;

AO.QD.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.QD.RampRate.Mode = 'Simulator';
AO.QD.RampRate.DataType = 'Scalar';
AO.QD.RampRate.ChannelNames = getname_als('QDramprate', AO.QD.DeviceList, 1);
AO.QD.RampRate.HW2PhysicsFcn = @amp2k;
AO.QD.RampRate.Physics2HWFcn = @k2amp;
%AO.QD.RampRate.HW2PhysicsParams = 1;
%AO.QD.RampRate.Physics2HWParams = 1;
AO.QD.RampRate.Units        = 'Hardware';
AO.QD.RampRate.HWUnits      = 'Ampere/Second';
AO.QD.RampRate.PhysicsUnits = 'Ampere/Second';

AO.QD.TimeConstant.MemberOf = {'PlotFamily'; 'Save';};
AO.QD.TimeConstant.Mode = 'Simulator';
AO.QD.TimeConstant.DataType = 'Scalar';
AO.QD.TimeConstant.ChannelNames = getname_als('QDtimeconstant', AO.QD.DeviceList, 1);
AO.QD.TimeConstant.HW2PhysicsParams = 1;
AO.QD.TimeConstant.Physics2HWParams = 1;
AO.QD.TimeConstant.Units        = 'Hardware';
AO.QD.TimeConstant.HWUnits      = 'Second';
AO.QD.TimeConstant.PhysicsUnits = 'Second';

AO.QD.DAC.MemberOf = {'PlotFamily'; 'Save';};
AO.QD.DAC.Mode = 'Simulator';
AO.QD.DAC.DataType = 'Scalar';
AO.QD.DAC.ChannelNames = getname_als('QDdac', AO.QD.DeviceList, 1);
AO.QD.DAC.HW2PhysicsParams = 1;
AO.QD.DAC.Physics2HWParams = 1;
AO.QD.DAC.Units        = 'Hardware';
AO.QD.DAC.HWUnits      = 'Ampere';
AO.QD.DAC.PhysicsUnits = 'Ampere';

AO.QD.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.QD.OnControl.Mode = 'Simulator';
AO.QD.OnControl.DataType = 'Scalar';
AO.QD.OnControl.ChannelNames = getname_als('QDon', AO.QD.DeviceList, 1);
AO.QD.OnControl.HW2PhysicsParams = 1;
AO.QD.OnControl.Physics2HWParams = 1;
AO.QD.OnControl.Units        = 'Hardware';
AO.QD.OnControl.HWUnits      = '';
AO.QD.OnControl.PhysicsUnits = '';
AO.QD.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.QD.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.QD.On.Mode = 'Simulator';
AO.QD.On.DataType = 'Scalar';
AO.QD.On.ChannelNames = getname_als('QDon', AO.QD.DeviceList, 0);
AO.QD.On.HW2PhysicsParams = 1;
AO.QD.On.Physics2HWParams = 1;
AO.QD.On.Units        = 'Hardware';
AO.QD.On.HWUnits      = '';
AO.QD.On.PhysicsUnits = '';

AO.QD.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.QD.Reset.Mode = 'Simulator';
AO.QD.Reset.DataType = 'Scalar';
AO.QD.Reset.ChannelNames = getname_als('QDreset', AO.QD.DeviceList, 1);
AO.QD.Reset.HW2PhysicsParams = 1;
AO.QD.Reset.Physics2HWParams = 1;
AO.QD.Reset.Units        = 'Hardware';
AO.QD.Reset.HWUnits      = '';
AO.QD.Reset.PhysicsUnits = '';

AO.QD.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.QD.Ready.Mode = 'Simulator';
AO.QD.Ready.DataType = 'Scalar';
AO.QD.Ready.ChannelNames = getname_als('QDready', AO.QD.DeviceList, 0);
AO.QD.Ready.HW2PhysicsParams = 1;
AO.QD.Ready.Physics2HWParams = 1;
AO.QD.Ready.Units        = 'Hardware';
AO.QD.Ready.HWUnits      = '';
AO.QD.Ready.PhysicsUnits = '';



AO.QFA.FamilyName = 'QFA';
AO.QFA.MemberOf   = {'QF'; 'QUAD'; 'Magnet'};
AO.QFA.DeviceList = [
    1 1; 1 2;
    2 1; 2 2;
    3 1; 3 2;
    4 1; 4 2;
    5 1; 5 2;
    6 1; 6 2;
    7 1; 7 2;
    8 1; 8 2;
    9 1; 9 2;
    10 1;10 2;
    11 1;11 2;
    12 1;12 2];
AO.QFA.ElementList = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]';
AO.QFA.Status = 1;

AO.QFA.Monitor.MemberOf = {'PlotFamily'; 'QFA'; 'QUAD'; 'Magnet'; 'Monitor'; 'Save';};
AO.QFA.Monitor.Mode = 'Simulator';
AO.QFA.Monitor.DataType = 'Scalar';
AO.QFA.Monitor.ChannelNames = getname_als(AO.QFA.FamilyName, AO.QFA.DeviceList, 0);
AO.QFA.Monitor.HW2PhysicsFcn = @amp2k;
AO.QFA.Monitor.Physics2HWFcn = @k2amp;
AO.QFA.Monitor.Units        = 'Hardware';
AO.QFA.Monitor.HWUnits      = 'Ampere';
AO.QFA.Monitor.PhysicsUnits = '1/Meter^2';
AO.QFA.Monitor.Gain = QFAMonitorGainOffset;

AO.QFA.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.QFA.Setpoint.Mode = 'Simulator';
AO.QFA.Setpoint.DataType = 'Scalar';
AO.QFA.Setpoint.ChannelNames = getname_als(AO.QFA.FamilyName, AO.QFA.DeviceList, 1);
AO.QFA.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QFA.Setpoint.Physics2HWFcn = @k2amp;
AO.QFA.Setpoint.Units        = 'Hardware';
AO.QFA.Setpoint.HWUnits      = 'Ampere';
AO.QFA.Setpoint.PhysicsUnits = '1/Meter^2';

AO.QFA.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.QFA.RampRate.Mode = 'Simulator';
AO.QFA.RampRate.DataType = 'Scalar';
AO.QFA.RampRate.ChannelNames = getname_als('QFAramprate', AO.QFA.DeviceList, 1);
AO.QFA.RampRate.HW2PhysicsParams = 1;
AO.QFA.RampRate.Physics2HWParams = 1;
AO.QFA.RampRate.Units        = 'Hardware';
AO.QFA.RampRate.HWUnits      = 'Ampere/Second';
AO.QFA.RampRate.PhysicsUnits = 'Ampere/Second';

AO.QFA.TimeConstant.MemberOf = {'PlotFamily'; 'Save';};
AO.QFA.TimeConstant.Mode = 'Simulator';
AO.QFA.TimeConstant.DataType = 'Scalar';
AO.QFA.TimeConstant.ChannelNames = getname_als('QFAtimeconstant', AO.QFA.DeviceList, 1);
AO.QFA.TimeConstant.HW2PhysicsParams = 1;
AO.QFA.TimeConstant.Physics2HWParams = 1;
AO.QFA.TimeConstant.Units        = 'Hardware';
AO.QFA.TimeConstant.HWUnits      = 'Second';
AO.QFA.TimeConstant.PhysicsUnits = 'Second';

% AO.QFA.DAC.MemberOf = {'PlotFamily';};
% AO.QFA.DAC.Mode = 'Simulator';
% AO.QFA.DAC.DataType = 'Scalar';
% AO.QFA.DAC.ChannelNames = getname_als('QFAdac', AO.QFA.DeviceList, 1);
% AO.QFA.DAC.HW2PhysicsParams = 1;
% AO.QFA.DAC.Physics2HWParams = 1;
% AO.QFA.DAC.Units        = 'Hardware';
% AO.QFA.DAC.HWUnits      = 'Ampere';
% AO.QFA.DAC.PhysicsUnits = 'Ampere';

AO.QFA.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.QFA.OnControl.Mode = 'Simulator';
AO.QFA.OnControl.DataType = 'Scalar';
AO.QFA.OnControl.ChannelNames = getname_als('QFAon', AO.QFA.DeviceList, 1);
AO.QFA.OnControl.HW2PhysicsParams = 1;
AO.QFA.OnControl.Physics2HWParams = 1;
AO.QFA.OnControl.Units        = 'Hardware';
AO.QFA.OnControl.HWUnits      = '';
AO.QFA.OnControl.PhysicsUnits = '';
AO.QFA.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.QFA.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.QFA.On.Mode = 'Simulator';
AO.QFA.On.DataType = 'Scalar';
AO.QFA.On.ChannelNames = getname_als('QFAon', AO.QFA.DeviceList, 0);
AO.QFA.On.HW2PhysicsParams = 1;
AO.QFA.On.Physics2HWParams = 1;
AO.QFA.On.Units        = 'Hardware';
AO.QFA.On.HWUnits      = '';
AO.QFA.On.PhysicsUnits = '';

AO.QFA.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.QFA.Reset.Mode = 'Simulator';
AO.QFA.Reset.DataType = 'Scalar';
AO.QFA.Reset.ChannelNames = getname_als('QFAreset', AO.QFA.DeviceList, 1);
AO.QFA.Reset.HW2PhysicsParams = 1;
AO.QFA.Reset.Physics2HWParams = 1;
AO.QFA.Reset.Units        = 'Hardware';
AO.QFA.Reset.HWUnits      = '';
AO.QFA.Reset.PhysicsUnits = '';

AO.QFA.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.QFA.Ready.Mode = 'Simulator';
AO.QFA.Ready.DataType = 'Scalar';
AO.QFA.Ready.ChannelNames = getname_als('QFAready', AO.QFA.DeviceList, 0);
AO.QFA.Ready.HW2PhysicsParams = 1;
AO.QFA.Ready.Physics2HWParams = 1;
AO.QFA.Ready.Units        = 'Hardware';
AO.QFA.Ready.HWUnits      = '';
AO.QFA.Ready.PhysicsUnits = '';

AO.QFA.Shunt1Control.MemberOf = {'PlotFamily'; 'Shunt'; 'Boolean Control';};
AO.QFA.Shunt1Control.Mode = 'Simulator';
AO.QFA.Shunt1Control.DataType = 'Scalar';
AO.QFA.Shunt1Control.ChannelNames = [];
AO.QFA.Shunt1Control.HW2PhysicsParams = 1;
AO.QFA.Shunt1Control.Physics2HWParams = 1;
AO.QFA.Shunt1Control.Units        = 'Hardware';
AO.QFA.Shunt1Control.HWUnits      = '';
AO.QFA.Shunt1Control.PhysicsUnits = '';
AO.QFA.Shunt1Control.RunFlagFcn = @getrunflagqfashunt;
AO.QFA.Shunt1Control.Range = [0 1];

AO.QFA.Shunt1.MemberOf = {'PlotFamily'; 'Shunt'; 'Boolean Monitor'; 'Save';};
AO.QFA.Shunt1.Mode = 'Simulator';
AO.QFA.Shunt1.DataType = 'Scalar';
AO.QFA.Shunt1.ChannelNames = [];
AO.QFA.Shunt1.HW2PhysicsParams = 1;
AO.QFA.Shunt1.Physics2HWParams = 1;
AO.QFA.Shunt1.Units        = 'Hardware';
AO.QFA.Shunt1.HWUnits      = '';
AO.QFA.Shunt1.PhysicsUnits = '';

AO.QFA.Shunt2Control.MemberOf = {'PlotFamily'; 'Shunt'; 'Boolean Control';};
AO.QFA.Shunt2Control.Mode = 'Simulator';
AO.QFA.Shunt2Control.DataType = 'Scalar';
AO.QFA.Shunt2Control.ChannelNames = [];
AO.QFA.Shunt2Control.HW2PhysicsParams = 1;
AO.QFA.Shunt2Control.Physics2HWParams = 1;
AO.QFA.Shunt2Control.Units        = 'Hardware';
AO.QFA.Shunt2Control.HWUnits      = '';
AO.QFA.Shunt2Control.PhysicsUnits = '';
AO.QFA.Shunt2Control.RunFlagFcn = @getrunflagqfashunt;
AO.QFA.Shunt2Control.Range = [0 1];

AO.QFA.Shunt2.MemberOf = {'PlotFamily'; 'Shunt'; 'Boolean Monitor'; 'Save';};
AO.QFA.Shunt2.Mode = 'Simulator';
AO.QFA.Shunt2.DataType = 'Scalar';
AO.QFA.Shunt2.ChannelNames = [];
AO.QFA.Shunt2.HW2PhysicsParams = 1;
AO.QFA.Shunt2.Physics2HWParams = 1;
AO.QFA.Shunt2.Units        = 'Hardware';
AO.QFA.Shunt2.HWUnits      = '';
AO.QFA.Shunt2.PhysicsUnits = '';

for i = 1:12
    AO.QFA.Shunt1Control.ChannelNames = [AO.QFA.Shunt1Control.ChannelNames; sprintf('SR%02dC___QFA1S1_BC19', i)];
    AO.QFA.Shunt2Control.ChannelNames = [AO.QFA.Shunt2Control.ChannelNames; sprintf('SR%02dC___QFA1S2_BC18', i)];
    AO.QFA.Shunt1Control.ChannelNames = [AO.QFA.Shunt1Control.ChannelNames; sprintf('SR%02dC___QFA2S1_BC17', i)];
    AO.QFA.Shunt2Control.ChannelNames = [AO.QFA.Shunt2Control.ChannelNames; sprintf('SR%02dC___QFA2S2_BC16', i)];
end

for i = 1:12
    AO.QFA.Shunt1.ChannelNames = [AO.QFA.Shunt1.ChannelNames; sprintf('SR%02dC___QFA1S1_BM23', i)];
    AO.QFA.Shunt2.ChannelNames = [AO.QFA.Shunt2.ChannelNames; sprintf('SR%02dC___QFA1S2_BM22', i)];
    AO.QFA.Shunt1.ChannelNames = [AO.QFA.Shunt1.ChannelNames; sprintf('SR%02dC___QFA2S1_BM21', i)];
    AO.QFA.Shunt2.ChannelNames = [AO.QFA.Shunt2.ChannelNames; sprintf('SR%02dC___QFA2S2_BM20', i)];
end



AO.QDA.FamilyName = 'QDA';
AO.QDA.MemberOf   = {'QD'; 'QUAD'; 'Magnet'};
AO.QDA.DeviceList = [4 1; 4 2; 8 1; 8 2; 12 1; 12 2];
AO.QDA.ElementList= [ 7;   8;   15;  16;   23;   24];
AO.QDA.Status = 1;

AO.QDA.Monitor.MemberOf = {'PlotFamily'; 'QDA'; 'QUAD'; 'Magnet'; 'Monitor'; 'Save';};
AO.QDA.Monitor.Mode = 'Simulator';
AO.QDA.Monitor.DataType = 'Scalar';
AO.QDA.Monitor.ChannelNames = getname_als(AO.QDA.FamilyName, AO.QDA.DeviceList, 0);
AO.QDA.Monitor.HW2PhysicsFcn = @amp2k;
AO.QDA.Monitor.Physics2HWFcn = @k2amp;
AO.QDA.Monitor.Units        = 'Hardware';
AO.QDA.Monitor.HWUnits      = 'Ampere';
AO.QDA.Monitor.PhysicsUnits = '1/Meter^2';

AO.QDA.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.QDA.Setpoint.Mode = 'Simulator';
AO.QDA.Setpoint.DataType = 'Scalar';
AO.QDA.Setpoint.ChannelNames = getname_als(AO.QDA.FamilyName, AO.QDA.DeviceList, 1);
AO.QDA.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QDA.Setpoint.Physics2HWFcn = @k2amp;
AO.QDA.Setpoint.Units        = 'Hardware';
AO.QDA.Setpoint.HWUnits      = 'Ampere';
AO.QDA.Setpoint.PhysicsUnits = '1/Meter^2';

AO.QDA.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.QDA.RampRate.Mode = 'Simulator';
AO.QDA.RampRate.DataType = 'Scalar';
AO.QDA.RampRate.ChannelNames = getname_als('QDAramprate', AO.QDA.DeviceList, 1);
AO.QDA.RampRate.HW2PhysicsParams = 1;
AO.QDA.RampRate.Physics2HWParams = 1;
AO.QDA.RampRate.Units        = 'Hardware';
AO.QDA.RampRate.HWUnits      = 'Ampere/Second';
AO.QDA.RampRate.PhysicsUnits = 'Ampere/Second';

AO.QDA.TimeConstant.MemberOf = {'PlotFamily'; 'Save';};
AO.QDA.TimeConstant.Mode = 'Simulator';
AO.QDA.TimeConstant.DataType = 'Scalar';
AO.QDA.TimeConstant.ChannelNames = getname_als('QDAtimeconstant', AO.QDA.DeviceList, 1);
AO.QDA.TimeConstant.HW2PhysicsParams = 1;
AO.QDA.TimeConstant.Physics2HWParams = 1;
AO.QDA.TimeConstant.Units        = 'Hardware';
AO.QDA.TimeConstant.HWUnits      = 'Second';
AO.QDA.TimeConstant.PhysicsUnits = 'Second';

AO.QDA.DAC.MemberOf = {'PlotFamily'; 'Save';};
AO.QDA.DAC.Mode = 'Simulator';
AO.QDA.DAC.DataType = 'Scalar';
AO.QDA.DAC.ChannelNames = getname_als('QDAdac', AO.QDA.DeviceList, 1);
AO.QDA.DAC.HW2PhysicsParams = 1;
AO.QDA.DAC.Physics2HWParams = 1;
AO.QDA.DAC.Units        = 'Hardware';
AO.QDA.DAC.HWUnits      = 'Ampere';
AO.QDA.DAC.PhysicsUnits = 'Ampere';

AO.QDA.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.QDA.OnControl.Mode = 'Simulator';
AO.QDA.OnControl.DataType = 'Scalar';
AO.QDA.OnControl.ChannelNames = getname_als('QDAon', AO.QDA.DeviceList, 1);
AO.QDA.OnControl.HW2PhysicsParams = 1;
AO.QDA.OnControl.Physics2HWParams = 1;
AO.QDA.OnControl.Units        = 'Hardware';
AO.QDA.OnControl.HWUnits      = '';
AO.QDA.OnControl.PhysicsUnits = '';
AO.QDA.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.QDA.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.QDA.On.Mode = 'Simulator';
AO.QDA.On.DataType = 'Scalar';
AO.QDA.On.ChannelNames = getname_als('QDAon', AO.QDA.DeviceList, 0);
AO.QDA.On.HW2PhysicsParams = 1;
AO.QDA.On.Physics2HWParams = 1;
AO.QDA.On.Units        = 'Hardware';
AO.QDA.On.HWUnits      = '';
AO.QDA.On.PhysicsUnits = '';

AO.QDA.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.QDA.Reset.Mode = 'Simulator';
AO.QDA.Reset.DataType = 'Scalar';
AO.QDA.Reset.ChannelNames = getname_als('QDAreset', AO.QDA.DeviceList, 1);
AO.QDA.Reset.HW2PhysicsParams = 1;
AO.QDA.Reset.Physics2HWParams = 1;
AO.QDA.Reset.Units        = 'Hardware';
AO.QDA.Reset.HWUnits      = '';
AO.QDA.Reset.PhysicsUnits = '';

AO.QDA.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.QDA.Ready.Mode = 'Simulator';
AO.QDA.Ready.DataType = 'Scalar';
AO.QDA.Ready.ChannelNames = getname_als('QDAready', AO.QDA.DeviceList, 0);
AO.QDA.Ready.HW2PhysicsParams = 1;
AO.QDA.Ready.Physics2HWParams = 1;
AO.QDA.Ready.Units        = 'Hardware';
AO.QDA.Ready.HWUnits      = '';
AO.QDA.Ready.PhysicsUnits = '';


%%%%%%%%%%%%%%%%%%%%%%
% Sextupole Families %
%%%%%%%%%%%%%%%%%%%%%%
AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
AO.SF.DeviceList = TwoPerSectorList;
AO.SF.ElementList = local_dev2elem('SF', AO.SF.DeviceList);
AO.SF.Status = 1;

AO.SF.Monitor.MemberOf = {'PlotFamily'; 'SF'; 'SEXT'; 'Magnet'; 'Monitor'; 'Save';};
AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_als(AO.SF.FamilyName, AO.SF.DeviceList, 0);
AO.SF.Monitor.HW2PhysicsFcn = @amp2k;
AO.SF.Monitor.Physics2HWFcn = @k2amp;
%AO.SF.Monitor.HW2PhysicsParams = 1;
%AO.SF.Monitor.Physics2HWParams = 1;
AO.SF.Monitor.Units        = 'Hardware';
AO.SF.Monitor.HWUnits      = 'Ampere';
AO.SF.Monitor.PhysicsUnits = '1/Meter^3';

AO.SF.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_als(AO.SF.FamilyName, AO.SF.DeviceList, 1);
AO.SF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SF.Setpoint.Physics2HWFcn = @k2amp;
%AO.SF.Setpoint.HW2PhysicsParams = 1;
%AO.SF.Setpoint.Physics2HWParams = 1;
AO.SF.Setpoint.Units        = 'Hardware';
AO.SF.Setpoint.HWUnits      = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^3';

AO.SF.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.SF.RampRate.Mode = 'Simulator';
AO.SF.RampRate.DataType = 'Scalar';
AO.SF.RampRate.ChannelNames = getname_als('SFramprate', AO.SF.DeviceList, 1);
AO.SF.RampRate.HW2PhysicsFcn = @amp2k;
AO.SF.RampRate.Physics2HWFcn = @k2amp;
%AO.SF.RampRate.HW2PhysicsParams = 1;
%AO.SF.RampRate.Physics2HWParams = 1;
AO.SF.RampRate.Units        = 'Hardware';
AO.SF.RampRate.HWUnits      = 'Ampere/Second';
AO.SF.RampRate.PhysicsUnits = 'Ampere/Second';

AO.SF.TimeConstant.MemberOf = {'PlotFamily'; 'Save';};
AO.SF.TimeConstant.Mode = 'Simulator';
AO.SF.TimeConstant.DataType = 'Scalar';
AO.SF.TimeConstant.ChannelNames = getname_als('SFtimeconstant', AO.SF.DeviceList, 1);
AO.SF.TimeConstant.HW2PhysicsParams = 1;
AO.SF.TimeConstant.Physics2HWParams = 1;
AO.SF.TimeConstant.Units        = 'Hardware';
AO.SF.TimeConstant.HWUnits      = 'Second';
AO.SF.TimeConstant.PhysicsUnits = 'Second';

AO.SF.DAC.MemberOf = {'PlotFamily'; 'Save';};
AO.SF.DAC.Mode = 'Simulator';
AO.SF.DAC.DataType = 'Scalar';
AO.SF.DAC.ChannelNames = getname_als('SFdac', AO.SF.DeviceList, 1);
AO.SF.DAC.HW2PhysicsParams = 1;
AO.SF.DAC.Physics2HWParams = 1;
AO.SF.DAC.Units        = 'Hardware';
AO.SF.DAC.HWUnits      = 'Ampere';
AO.SF.DAC.PhysicsUnits = 'Ampere';

AO.SF.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SF.OnControl.Mode = 'Simulator';
AO.SF.OnControl.DataType = 'Scalar';
AO.SF.OnControl.ChannelNames = getname_als('SFon', AO.SF.DeviceList, 1);
AO.SF.OnControl.HW2PhysicsParams = 1;
AO.SF.OnControl.Physics2HWParams = 1;
AO.SF.OnControl.Units        = 'Hardware';
AO.SF.OnControl.HWUnits      = '';
AO.SF.OnControl.PhysicsUnits = '';
AO.SF.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.SF.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SF.On.Mode = 'Simulator';
AO.SF.On.DataType = 'Scalar';
AO.SF.On.ChannelNames = getname_als('SFon', AO.SF.DeviceList, 0);
AO.SF.On.HW2PhysicsParams = 1;
AO.SF.On.Physics2HWParams = 1;
AO.SF.On.Units        = 'Hardware';
AO.SF.On.HWUnits      = '';
AO.SF.On.PhysicsUnits = '';

AO.SF.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SF.Reset.Mode = 'Simulator';
AO.SF.Reset.DataType = 'Scalar';
AO.SF.Reset.ChannelNames = getname_als('SFreset', AO.SF.DeviceList, 1);
AO.SF.Reset.HW2PhysicsParams = 1;
AO.SF.Reset.Physics2HWParams = 1;
AO.SF.Reset.Units        = 'Hardware';
AO.SF.Reset.HWUnits      = '';
AO.SF.Reset.PhysicsUnits = '';

AO.SF.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SF.Ready.Mode = 'Simulator';
AO.SF.Ready.DataType = 'Scalar';
AO.SF.Ready.ChannelNames = getname_als('SFready', AO.SF.DeviceList, 0);
AO.SF.Ready.HW2PhysicsParams = 1;
AO.SF.Ready.Physics2HWParams = 1;
AO.SF.Ready.Units        = 'Hardware';
AO.SF.Ready.HWUnits      = '';
AO.SF.Ready.PhysicsUnits = '';


AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'Chromaticity Corrector'; 'SD'; 'SEXT'; 'Magnet'};
AO.SD.DeviceList = TwoPerSectorList;
AO.SD.ElementList = local_dev2elem('SD', AO.SD.DeviceList);
AO.SD.Status = 1;

AO.SD.Monitor.MemberOf =  {'PlotFamily'; 'SD'; 'SEXT'; 'Magnet'; 'Monitor'; 'Save';};
AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_als(AO.SD.FamilyName, AO.SD.DeviceList, 0);
AO.SD.Monitor.HW2PhysicsFcn = @amp2k;
AO.SD.Monitor.Physics2HWFcn = @k2amp;
AO.SD.Monitor.Units        = 'Hardware';
AO.SD.Monitor.HWUnits      = 'Ampere';
AO.SD.Monitor.PhysicsUnits = '1/Meter^3';

AO.SD.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_als(AO.SD.FamilyName, AO.SD.DeviceList, 1);
AO.SD.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SD.Setpoint.Physics2HWFcn = @k2amp;
AO.SD.Setpoint.Units        = 'Hardware';
AO.SD.Setpoint.HWUnits      = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^3';

AO.SD.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.SD.RampRate.Mode = 'Simulator';
AO.SD.RampRate.DataType = 'Scalar';
AO.SD.RampRate.ChannelNames = getname_als('SDramprate', AO.SD.DeviceList, 1);
AO.SD.RampRate.HW2PhysicsParams = 1;
AO.SD.RampRate.Physics2HWParams = 1;
AO.SD.RampRate.Units        = 'Hardware';
AO.SD.RampRate.HWUnits      = 'Ampere/Second';
AO.SD.RampRate.PhysicsUnits = 'Ampere/Second';

AO.SD.TimeConstant.MemberOf = {'PlotFamily'; 'Save'; };
AO.SD.TimeConstant.Mode = 'Simulator';
AO.SD.TimeConstant.DataType = 'Scalar';
AO.SD.TimeConstant.ChannelNames = getname_als('SDtimeconstant', AO.SD.DeviceList, 1);
AO.SD.TimeConstant.HW2PhysicsParams = 1;
AO.SD.TimeConstant.Physics2HWParams = 1;
AO.SD.TimeConstant.Units        = 'Hardware';
AO.SD.TimeConstant.HWUnits      = 'Second';
AO.SD.TimeConstant.PhysicsUnits = 'Second';

AO.SD.DAC.MemberOf = {'PlotFamily'; 'Save';};
AO.SD.DAC.Mode = 'Simulator';
AO.SD.DAC.DataType = 'Scalar';
AO.SD.DAC.ChannelNames = getname_als('SFdac', AO.SD.DeviceList, 1);
AO.SD.DAC.HW2PhysicsParams = 1;
AO.SD.DAC.Physics2HWParams = 1;
AO.SD.DAC.Units        = 'Hardware';
AO.SD.DAC.HWUnits      = 'Ampere';
AO.SD.DAC.PhysicsUnits = 'Ampere';

AO.SD.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SD.OnControl.Mode = 'Simulator';
AO.SD.OnControl.DataType = 'Scalar';
AO.SD.OnControl.ChannelNames = getname_als('SDon', AO.SD.DeviceList, 1);
AO.SD.OnControl.HW2PhysicsParams = 1;
AO.SD.OnControl.Physics2HWParams = 1;
AO.SD.OnControl.Units        = 'Hardware';
AO.SD.OnControl.HWUnits      = '';
AO.SD.OnControl.PhysicsUnits = '';
AO.SD.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.SD.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SD.On.Mode = 'Simulator';
AO.SD.On.DataType = 'Scalar';
AO.SD.On.ChannelNames = getname_als('SDon', AO.SD.DeviceList, 0);
AO.SD.On.HW2PhysicsParams = 1;
AO.SD.On.Physics2HWParams = 1;
AO.SD.On.Units        = 'Hardware';
AO.SD.On.HWUnits      = '';
AO.SD.On.PhysicsUnits = '';

AO.SD.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SD.Reset.Mode = 'Simulator';
AO.SD.Reset.DataType = 'Scalar';
AO.SD.Reset.ChannelNames = getname_als('SDreset', AO.SD.DeviceList, 1);
AO.SD.Reset.HW2PhysicsParams = 1;
AO.SD.Reset.Physics2HWParams = 1;
AO.SD.Reset.Units        = 'Hardware';
AO.SD.Reset.HWUnits      = '';
AO.SD.Reset.PhysicsUnits = '';

AO.SD.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SD.Ready.Mode = 'Simulator';
AO.SD.Ready.DataType = 'Scalar';
AO.SD.Ready.ChannelNames = getname_als('SDready', AO.SD.DeviceList, 0);
AO.SD.Ready.HW2PhysicsParams = 1;
AO.SD.Ready.Physics2HWParams = 1;
AO.SD.Ready.Units        = 'Hardware';
AO.SD.Ready.HWUnits      = '';
AO.SD.Ready.PhysicsUnits = '';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Harmonic Sextupole Families %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.SHF.FamilyName = 'SHF';
AO.SHF.MemberOf   = {'SHF'; 'SEXT'; 'Magnet'};
AO.SHF.DeviceList = [
    1 1; 1 2;
    2 1; 2 2;
    3 1; 3 2;
    4 1; 4 2;
    5 1; 5 2;
    6 1; 6 2;
    7 1; 7 2;
    8 1; 8 2;
    9 1; 9 2;
    10 1;10 2;
    11 1;11 2;
    12 1;12 2];
AO.SHF.ElementList = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]';
AO.SHF.Status = 1;

for i = 1:12
    AO.SHF.BaseName{2*(i-1)+1,1}   = sprintf('s%02dshf1',i);
    AO.SHF.DeviceType{2*(i-1)+1,1} = 'TDK';
    AO.SHF.BaseName{2*(i-1)+2,1}   = sprintf('s%02dshf2',i);
    AO.SHF.DeviceType{2*(i-1)+2,1} = 'TDK';
end
AO.SHF.BaseName{1}   = 's01shfa';
AO.SHF.BaseName{end} = 's12shfa';

AO.SHF.Monitor.MemberOf = {'PlotFamily'; 'SHF'; 'SEXT'; 'Magnet'; 'Monitor'; 'Save';};
AO.SHF.Monitor.Mode = 'Simulator';
AO.SHF.Monitor.DataType = 'Scalar';
AO.SHF.Monitor.ChannelNames = getname_als(AO.SHF.FamilyName, AO.SHF.DeviceList, 0);
AO.SHF.Monitor.HW2PhysicsFcn = @amp2k;
AO.SHF.Monitor.Physics2HWFcn = @k2amp;
AO.SHF.Monitor.Units        = 'Hardware';
AO.SHF.Monitor.HWUnits      = 'Ampere';
AO.SHF.Monitor.PhysicsUnits = '1/Meter^2';
%AO.SHF.Monitor.Gain = SHFMonitorGainOffset;

AO.SHF.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.SHF.Setpoint.Mode = 'Simulator';
AO.SHF.Setpoint.DataType = 'Scalar';
AO.SHF.Setpoint.ChannelNames = getname_als(AO.SHF.FamilyName, AO.SHF.DeviceList, 1);
AO.SHF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SHF.Setpoint.Physics2HWFcn = @k2amp;
AO.SHF.Setpoint.Units        = 'Hardware';
AO.SHF.Setpoint.HWUnits      = 'Ampere';
AO.SHF.Setpoint.PhysicsUnits = '1/Meter^2';

AO.SHF.RampRate.MemberOf = {'PlotFamily'; 'Save'; };
AO.SHF.RampRate.Mode = 'Simulator';
AO.SHF.RampRate.DataType = 'Scalar';
AO.SHF.RampRate.ChannelNames = getname_als('SHFramprate', AO.SHF.DeviceList, 1);
AO.SHF.RampRate.HW2PhysicsParams = 1;
AO.SHF.RampRate.Physics2HWParams = 1;
AO.SHF.RampRate.Units        = 'Hardware';
AO.SHF.RampRate.HWUnits      = 'Ampere/Second';
AO.SHF.RampRate.PhysicsUnits = 'Ampere/Second';

% AO.SHF.TimeConstant.MemberOf = {'PlotFamily'; 'Save'; };
% AO.SHF.TimeConstant.Mode = 'Simulator';
% AO.SHF.TimeConstant.DataType = 'Scalar';
% AO.SHF.TimeConstant.ChannelNames = getname_als('SHFtimeconstant', AO.SHF.DeviceList, 1);
% AO.SHF.TimeConstant.HW2PhysicsParams = 1;
% AO.SHF.TimeConstant.Physics2HWParams = 1;
% AO.SHF.TimeConstant.Units        = 'Hardware';
% AO.SHF.TimeConstant.HWUnits      = 'Second';
% AO.SHF.TimeConstant.PhysicsUnits = 'Second';

AO.SHF.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SHF.OnControl.Mode = 'Simulator';
AO.SHF.OnControl.DataType = 'Scalar';
AO.SHF.OnControl.ChannelNames = getname_als('SHFon', AO.SHF.DeviceList, 1);
AO.SHF.OnControl.HW2PhysicsParams = 1;
AO.SHF.OnControl.Physics2HWParams = 1;
AO.SHF.OnControl.Units        = 'Hardware';
AO.SHF.OnControl.HWUnits      = '';
AO.SHF.OnControl.PhysicsUnits = '';
AO.SHF.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.SHF.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SHF.On.Mode = 'Simulator';
AO.SHF.On.DataType = 'Scalar';
AO.SHF.On.ChannelNames = getname_als('SHFon', AO.SHF.DeviceList, 0);
AO.SHF.On.HW2PhysicsParams = 1;
AO.SHF.On.Physics2HWParams = 1;
AO.SHF.On.Units        = 'Hardware';
AO.SHF.On.HWUnits      = '';
AO.SHF.On.PhysicsUnits = '';

AO.SHF.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SHF.Reset.Mode = 'Simulator';
AO.SHF.Reset.DataType = 'Scalar';
AO.SHF.Reset.ChannelNames = getname_als('SHFreset', AO.SHF.DeviceList, 1);
AO.SHF.Reset.HW2PhysicsParams = 1;
AO.SHF.Reset.Physics2HWParams = 1;
AO.SHF.Reset.Units        = 'Hardware';
AO.SHF.Reset.HWUnits      = '';
AO.SHF.Reset.PhysicsUnits = '';

AO.SHF.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SHF.Ready.Mode = 'Simulator';
AO.SHF.Ready.DataType = 'Scalar';
AO.SHF.Ready.ChannelNames = getname_als('SHFready', AO.SHF.DeviceList, 0);
AO.SHF.Ready.HW2PhysicsParams = 1;
AO.SHF.Ready.Physics2HWParams = 1;
AO.SHF.Ready.Units        = 'Hardware';
AO.SHF.Ready.HWUnits      = '';
AO.SHF.Ready.PhysicsUnits = '';


AO.SHD.FamilyName = 'SHD';
AO.SHD.MemberOf   = {'SHD'; 'SEXT'; 'Magnet'};
AO.SHD.DeviceList = [
    1 1; 1 2;
    2 1; 2 2;
    3 1; 3 2;
    4 1; 4 2;
    5 1; 5 2;
    6 1; 6 2;
    7 1; 7 2;
    8 1; 8 2;
    9 1; 9 2;
    10 1;10 2;
    11 1;11 2;
    12 1;12 2];
AO.SHD.ElementList = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24]';
AO.SHD.Status = 1;

for i = 1:12
    AO.SHD.BaseName{2*(i-1)+1,1}   = sprintf('s%02dshd1',i);
    AO.SHD.DeviceType{2*(i-1)+1,1} = 'TDK';
    AO.SHD.BaseName{2*(i-1)+2,1}   = sprintf('s%02dshd2',i);
    AO.SHD.DeviceType{2*(i-1)+2,1} = 'TDK';
end

AO.SHD.Monitor.MemberOf = {'PlotFamily'; 'SHD'; 'SEXT'; 'Magnet'; 'Monitor'; 'Save';};
AO.SHD.Monitor.Mode = 'Simulator';
AO.SHD.Monitor.DataType = 'Scalar';
AO.SHD.Monitor.ChannelNames = getname_als(AO.SHD.FamilyName, AO.SHD.DeviceList, 0);
AO.SHD.Monitor.HW2PhysicsFcn = @amp2k;
AO.SHD.Monitor.Physics2HWFcn = @k2amp;
AO.SHD.Monitor.Units        = 'Hardware';
AO.SHD.Monitor.HWUnits      = 'Ampere';
AO.SHD.Monitor.PhysicsUnits = '1/Meter^2';
%AO.SHD.Monitor.Gain = SHDMonitorGainOffset;

AO.SHD.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.SHD.Setpoint.Mode = 'Simulator';
AO.SHD.Setpoint.DataType = 'Scalar';
AO.SHD.Setpoint.ChannelNames = getname_als(AO.SHD.FamilyName, AO.SHD.DeviceList, 1);
AO.SHD.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SHD.Setpoint.Physics2HWFcn = @k2amp;
AO.SHD.Setpoint.Units        = 'Hardware';
AO.SHD.Setpoint.HWUnits      = 'Ampere';
AO.SHD.Setpoint.PhysicsUnits = '1/Meter^2';

AO.SHD.RampRate.MemberOf = {'PlotFamily'; 'Save'; };
AO.SHD.RampRate.Mode = 'Simulator';
AO.SHD.RampRate.DataType = 'Scalar';
AO.SHD.RampRate.ChannelNames = getname_als('SHDramprate', AO.SHD.DeviceList, 1);
AO.SHD.RampRate.HW2PhysicsParams = 1;
AO.SHD.RampRate.Physics2HWParams = 1;
AO.SHD.RampRate.Units        = 'Hardware';
AO.SHD.RampRate.HWUnits      = 'Ampere/Second';
AO.SHD.RampRate.PhysicsUnits = 'Ampere/Second';

% AO.SHD.TimeConstant.MemberOf = {'PlotFamily'; 'Save'; };
% AO.SHD.TimeConstant.Mode = 'Simulator';
% AO.SHD.TimeConstant.DataType = 'Scalar';
% AO.SHD.TimeConstant.ChannelNames = getname_als('SHDtimeconstant', AO.SHD.DeviceList, 1);
% AO.SHD.TimeConstant.HW2PhysicsParams = 1;
% AO.SHD.TimeConstant.Physics2HWParams = 1;
% AO.SHD.TimeConstant.Units        = 'Hardware';
% AO.SHD.TimeConstant.HWUnits      = 'Second';
% AO.SHD.TimeConstant.PhysicsUnits = 'Second';

AO.SHD.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SHD.OnControl.Mode = 'Simulator';
AO.SHD.OnControl.DataType = 'Scalar';
AO.SHD.OnControl.ChannelNames = getname_als('SHDon', AO.SHD.DeviceList, 1);
AO.SHD.OnControl.HW2PhysicsParams = 1;
AO.SHD.OnControl.Physics2HWParams = 1;
AO.SHD.OnControl.Units        = 'Hardware';
AO.SHD.OnControl.HWUnits      = '';
AO.SHD.OnControl.PhysicsUnits = '';
AO.SHD.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.SHD.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SHD.On.Mode = 'Simulator';
AO.SHD.On.DataType = 'Scalar';
AO.SHD.On.ChannelNames = getname_als('SHDon', AO.SHD.DeviceList, 0);
AO.SHD.On.HW2PhysicsParams = 1;
AO.SHD.On.Physics2HWParams = 1;
AO.SHD.On.Units        = 'Hardware';
AO.SHD.On.HWUnits      = '';
AO.SHD.On.PhysicsUnits = '';

AO.SHD.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SHD.Reset.Mode = 'Simulator';
AO.SHD.Reset.DataType = 'Scalar';
AO.SHD.Reset.ChannelNames = getname_als('SHDreset', AO.SHD.DeviceList, 1);
AO.SHD.Reset.HW2PhysicsParams = 1;
AO.SHD.Reset.Physics2HWParams = 1;
AO.SHD.Reset.Units        = 'Hardware';
AO.SHD.Reset.HWUnits      = '';
AO.SHD.Reset.PhysicsUnits = '';

AO.SHD.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SHD.Ready.Mode = 'Simulator';
AO.SHD.Ready.DataType = 'Scalar';
AO.SHD.Ready.ChannelNames = getname_als('SHDready', AO.SHD.DeviceList, 0);
AO.SHD.Ready.HW2PhysicsParams = 1;
AO.SHD.Ready.Physics2HWParams = 1;
AO.SHD.Ready.Units        = 'Hardware';
AO.SHD.Ready.HWUnits      = '';
AO.SHD.Ready.PhysicsUnits = '';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Skew Quadrupole Families %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.SQSF.FamilyName = 'SQSF';
AO.SQSF.MemberOf   = {'SKEWQUAD'; 'Magnet'};
AO.SQSF.DeviceList = TwoPerSectorList;
AO.SQSF.ElementList = local_dev2elem('SQSF', AO.SQSF.DeviceList);
%                 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4
AO.SQSF.Status = [1 0 1 0 1 1 1 0 1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 0]';

AO.SQSF.BaseName = {
    'SR01C:SQSF1'
    ''
    'SR02C:SQSF1'
    ''
    'SR03C:SQSF1'
    'SR03C:SQSF2'
    'SR04C:SQSF1'
    ''
    ''
    'SR05C:SQSF2'
    ''
    'SR06C:SQSF2'
    'SR07C:SQSF1'
    'SR07C:SQSF2'
    'SR08C:SQSF1'
    ''
    'SR09C:SQSF1'
    ''
    'SR10C:SQSF1'
    ''
    'SR11C:SQSF1'
    ''
    'SR12C:SQSF1'
    ''
    };
AO.SQSF.DeviceType = {
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    ''
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
};

AO.SQSF.Monitor.MemberOf = {'PlotFamily'; 'SQSF'; 'SKEWQUAD'; 'Magnet'; 'Monitor'; 'Save';};
AO.SQSF.Monitor.Mode = 'Simulator';
AO.SQSF.Monitor.DataType = 'Scalar';
AO.SQSF.Monitor.ChannelNames = getname_als(AO.SQSF.FamilyName, AO.SQSF.DeviceList, 0);
AO.SQSF.Monitor.HW2PhysicsFcn = @amp2k;
AO.SQSF.Monitor.Physics2HWFcn = @k2amp;
%AO.SQSF.Monitor.HW2PhysicsParams = SQSFfac;
%AO.SQSF.Monitor.Physics2HWParams = 1./SQSFfac;
AO.SQSF.Monitor.Units        = 'Hardware';
AO.SQSF.Monitor.HWUnits      = 'Ampere';
AO.SQSF.Monitor.PhysicsUnits = '1/Meter^2';

AO.SQSF.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.SQSF.Setpoint.Mode = 'Simulator';
AO.SQSF.Setpoint.DataType = 'Scalar';
AO.SQSF.Setpoint.ChannelNames = getname_als(AO.SQSF.FamilyName, AO.SQSF.DeviceList, 1);
AO.SQSF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SQSF.Setpoint.Physics2HWFcn = @k2amp;
%AO.SQSF.Setpoint.HW2PhysicsParams = SQSFfac;
%AO.SQSF.Setpoint.Physics2HWParams = 1./SQSFfac;
AO.SQSF.Setpoint.Units        = 'Hardware';
AO.SQSF.Setpoint.HWUnits      = 'Ampere';
AO.SQSF.Setpoint.PhysicsUnits = '1/Meter^2';

AO.SQSF.RampRate.MemberOf = {'PlotFamily'; };
AO.SQSF.RampRate.Mode = 'Simulator';
AO.SQSF.RampRate.DataType = 'Scalar';
AO.SQSF.RampRate.ChannelNames = getname_als('SQSFramprate', AO.SQSF.DeviceList, 1);
AO.SQSF.RampRate.HW2PhysicsParams = 1;
AO.SQSF.RampRate.Physics2HWParams = 1;
AO.SQSF.RampRate.Units        = 'Hardware';
AO.SQSF.RampRate.HWUnits      = 'Ampere/Second';
AO.SQSF.RampRate.PhysicsUnits = 'Ampere/Second';

AO.SQSF.TimeConstant.MemberOf = {'PlotFamily'; };
AO.SQSF.TimeConstant.Mode = 'Simulator';
AO.SQSF.TimeConstant.DataType = 'Scalar';
AO.SQSF.TimeConstant.ChannelNames = getname_als('SQSFtimeconstant', AO.SQSF.DeviceList, 1);
AO.SQSF.TimeConstant.HW2PhysicsParams = 1;
AO.SQSF.TimeConstant.Physics2HWParams = 1;
AO.SQSF.TimeConstant.Units        = 'Hardware';
AO.SQSF.TimeConstant.HWUnits      = 'Second';
AO.SQSF.TimeConstant.PhysicsUnits = 'Second';

% AO.SQSF.DAC.MemberOf = {'PlotFamily'; 'Save';};
% AO.SQSF.DAC.Mode = 'Simulator';
% AO.SQSF.DAC.DataType = 'Scalar';
% AO.SQSF.DAC.ChannelNames = getname_als('SQSFdac', AO.SQSF.DeviceList, 1);
% AO.SQSF.DAC.HW2PhysicsParams = 1;
% AO.SQSF.DAC.Physics2HWParams = 1;
% AO.SQSF.DAC.Units        = 'Hardware';
% AO.SQSF.DAC.HWUnits      = 'Ampere';
% AO.SQSF.DAC.PhysicsUnits = 'Ampere';

AO.SQSF.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SQSF.OnControl.Mode = 'Simulator';
AO.SQSF.OnControl.DataType = 'Scalar';
AO.SQSF.OnControl.ChannelNames = getname_als('SQSFon', AO.SQSF.DeviceList, 1);
AO.SQSF.OnControl.HW2PhysicsParams = 1;
AO.SQSF.OnControl.Physics2HWParams = 1;
AO.SQSF.OnControl.Units        = 'Hardware';
AO.SQSF.OnControl.HWUnits      = '';
AO.SQSF.OnControl.PhysicsUnits = '';
AO.SQSF.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.SQSF.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SQSF.On.Mode = 'Simulator';
AO.SQSF.On.DataType = 'Scalar';
AO.SQSF.On.ChannelNames = getname_als('SQSFon', AO.SQSF.DeviceList, 0);
AO.SQSF.On.HW2PhysicsParams = 1;
AO.SQSF.On.Physics2HWParams = 1;
AO.SQSF.On.Units        = 'Hardware';
AO.SQSF.On.HWUnits      = '';
AO.SQSF.On.PhysicsUnits = '';

AO.SQSF.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SQSF.Reset.Mode = 'Simulator';
AO.SQSF.Reset.DataType = 'Scalar';
AO.SQSF.Reset.ChannelNames = getname_als('SQSFreset', AO.SQSF.DeviceList, 3);
AO.SQSF.Reset.HW2PhysicsParams = 1;
AO.SQSF.Reset.Physics2HWParams = 1;
AO.SQSF.Reset.Units        = 'Hardware';
AO.SQSF.Reset.HWUnits      = '';
AO.SQSF.Reset.PhysicsUnits = '';

AO.SQSF.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SQSF.Ready.Mode = 'Simulator';
AO.SQSF.Ready.DataType = 'Scalar';
AO.SQSF.Ready.ChannelNames = getname_als('SQSFready', AO.SQSF.DeviceList, 0);
AO.SQSF.Ready.HW2PhysicsParams = 1;
AO.SQSF.Ready.Physics2HWParams = 1;
AO.SQSF.Ready.Units        = 'Hardware';
AO.SQSF.Ready.HWUnits      = '';
AO.SQSF.Ready.PhysicsUnits = '';

AO.SQSF.Offset = zeros(size(AO.SQSF.DeviceList,1),1);


AO.SQSD.FamilyName = 'SQSD';
AO.SQSD.MemberOf   = {'SKEWQUAD'; 'Magnet'};
AO.SQSD.DeviceList = TwoPerSectorList;
AO.SQSD.ElementList = local_dev2elem('SQSD', AO.SQSD.DeviceList);
%                 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4
AO.SQSD.Status = [1 0 1 0 1 1 1 0 1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 0]';
AO.SQSD.BaseName = {
    'SR01C:SQSD1'
    ''
    'SR02C:SQSD1'
    ''
    'SR03C:SQSD1'
    'SR03C:SQSD2'
    'SR04C:SQSD1'
    ''
    'SR05C:SQSD1'
    'SR05C:SQSD2'
    'SR06C:SQSD1'
    'SR06C:SQSD2'
    'SR07C:SQSD1'
    'SR07C:SQSD2'
    'SR08C:SQSD1'
    ''
    'SR09C:SQSD1'
    ''
    'SR10C:SQSD1'
    ''
    'SR11C:SQSD1'
    ''
    'SR12C:SQSD1'
    ''
    };

AO.SQSD.DeviceType = {
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    ''
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
    'Caen SY3634'
    ''
};

AO.SQSD.Monitor.MemberOf = {'PlotFamily'; 'SQSF'; 'SKEWQUAD'; 'Magnet'; 'Monitor'; 'Save';};
AO.SQSD.Monitor.Mode = 'Simulator';
AO.SQSD.Monitor.DataType = 'Scalar';
AO.SQSD.Monitor.ChannelNames = getname_als('SQSD', AO.SQSD.DeviceList, 0);
AO.SQSD.Monitor.HW2PhysicsFcn = @amp2k;
AO.SQSD.Monitor.Physics2HWFcn = @k2amp;
%AO.SQSD.Monitor.HW2PhysicsParams = SQSDfac;
%AO.SQSD.Monitor.Physics2HWParams = 1./SQSDfac;
AO.SQSD.Monitor.Units        = 'Hardware';
AO.SQSD.Monitor.HWUnits      = 'Ampere';
AO.SQSD.Monitor.PhysicsUnits = '1/Meter^2';

AO.SQSD.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.SQSD.Setpoint.Mode = 'Simulator';
AO.SQSD.Setpoint.DataType = 'Scalar';
AO.SQSD.Setpoint.ChannelNames = getname_als('SQSD', AO.SQSD.DeviceList, 1);
AO.SQSD.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SQSD.Setpoint.Physics2HWFcn = @k2amp;
%AO.SQSD.Setpoint.HW2PhysicsParams = SQSDfac;
%AO.SQSD.Setpoint.Physics2HWParams = 1./SQSDfac;
AO.SQSD.Setpoint.Units        = 'Hardware';
AO.SQSD.Setpoint.HWUnits      = 'Ampere';
AO.SQSD.Setpoint.PhysicsUnits = '1/Meter^2';

AO.SQSD.RampRate.MemberOf = {'PlotFamily'; };
AO.SQSD.RampRate.Mode = 'Simulator';
AO.SQSD.RampRate.DataType = 'Scalar';
AO.SQSD.RampRate.ChannelNames = getname_als('SQSDramprate', AO.SQSD.DeviceList, 1);
AO.SQSD.RampRate.HW2PhysicsParams = 1;
AO.SQSD.RampRate.Physics2HWParams = 1;
AO.SQSD.RampRate.Units        = 'Hardware';
AO.SQSD.RampRate.HWUnits      = 'Ampere/Second';
AO.SQSD.RampRate.PhysicsUnits = 'Ampere/Second';

AO.SQSD.TimeConstant.MemberOf = {'PlotFamily'; };
AO.SQSD.TimeConstant.Mode = 'Simulator';
AO.SQSD.TimeConstant.DataType = 'Scalar';
AO.SQSD.TimeConstant.ChannelNames = getname_als('SQSDtimeconstant', AO.SQSD.DeviceList, 1);
AO.SQSD.TimeConstant.HW2PhysicsParams = 1;
AO.SQSD.TimeConstant.Physics2HWParams = 1;
AO.SQSD.TimeConstant.Units        = 'Hardware';
AO.SQSD.TimeConstant.HWUnits      = 'Second';
AO.SQSD.TimeConstant.PhysicsUnits = 'Second';

% AO.SQSD.DAC.MemberOf = {'PlotFamily'; 'Save';};
% AO.SQSD.DAC.Mode = 'Simulator';
% AO.SQSD.DAC.DataType = 'Scalar';
% AO.SQSD.DAC.ChannelNames = getname_als('SQSDdac', AO.SQSD.DeviceList, 1);
% AO.SQSD.DAC.HW2PhysicsParams = 1;
% AO.SQSD.DAC.Physics2HWParams = 1;
% AO.SQSD.DAC.Units        = 'Hardware';
% AO.SQSD.DAC.HWUnits      = 'Ampere';
% AO.SQSD.DAC.PhysicsUnits = 'Ampere';

AO.SQSD.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SQSD.OnControl.Mode = 'Simulator';
AO.SQSD.OnControl.DataType = 'Scalar';
AO.SQSD.OnControl.ChannelNames = getname_als('SQSDon', AO.SQSD.DeviceList, 1);
AO.SQSD.OnControl.HW2PhysicsParams = 1;
AO.SQSD.OnControl.Physics2HWParams = 1;
AO.SQSD.OnControl.Units        = 'Hardware';
AO.SQSD.OnControl.HWUnits      = '';
AO.SQSD.OnControl.PhysicsUnits = '';
AO.SQSD.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.SQSD.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SQSD.On.Mode = 'Simulator';
AO.SQSD.On.DataType = 'Scalar';
AO.SQSD.On.ChannelNames = getname_als('SQSDon', AO.SQSD.DeviceList, 0);
AO.SQSD.On.HW2PhysicsParams = 1;
AO.SQSD.On.Physics2HWParams = 1;
AO.SQSD.On.Units        = 'Hardware';
AO.SQSD.On.HWUnits      = '';
AO.SQSD.On.PhysicsUnits = '';

AO.SQSD.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SQSD.Reset.Mode = 'Simulator';
AO.SQSD.Reset.DataType = 'Scalar';
AO.SQSD.Reset.ChannelNames = getname_als('SQSDreset', AO.SQSD.DeviceList, 3);
AO.SQSD.Reset.HW2PhysicsParams = 1;
AO.SQSD.Reset.Physics2HWParams = 1;
AO.SQSD.Reset.Units        = 'Hardware';
AO.SQSD.Reset.HWUnits      = '';
AO.SQSD.Reset.PhysicsUnits = '';

AO.SQSD.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SQSD.Ready.Mode = 'Simulator';
AO.SQSD.Ready.DataType = 'Scalar';
AO.SQSD.Ready.ChannelNames = getname_als('SQSDready', AO.SQSD.DeviceList, 0);
AO.SQSD.Ready.HW2PhysicsParams = 1;
AO.SQSD.Ready.Physics2HWParams = 1;
AO.SQSD.Ready.Units        = 'Hardware';
AO.SQSD.Ready.HWUnits      = '';
AO.SQSD.Ready.PhysicsUnits = '';

AO.SQSD.Offset = zeros(size(AO.SQSD.DeviceList,1),1);


% Take out some channels for Caens
for i = 1:length(AO.SQSF.DeviceType)
    if strcmpi(AO.SQSF.DeviceType{i}, 'Caen SY3634')
        AO.SQSF.TimeConstant.ChannelNames(i,:) = ' ';
    end
end
for i = 1:length(AO.SQSD.DeviceType)
    if strcmpi(AO.SQSD.DeviceType{i}, 'Caen SY3634')
        AO.SQSD.TimeConstant.ChannelNames(i,:) = ' ';
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Harmonic Sextupole Skew Quads %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO = buildmml_sextupole_harmonic(AO, 'SQSHF');


%%%%%%%%
% BEND %
%%%%%%%%
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'BEND'; 'Magnet'};
AO.BEND.Status = 1;
AO.BEND.DeviceList = [
    1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3;
    4 1; 4 2; 4 3; 5 1; 5 2; 5 3; 6 1; 6 2; 6 3;
    7 1; 7 2; 7 3; 8 1; 8 2; 8 3; 9 1; 9 2; 9 3;
    10 1;10 2;10 3;11 1;11 2;11 3;12 1;12 2; 12 3];
AO.BEND.ElementList = [1 2 3  4 5 6  7 8 9  10 11 12  13 14 15  16 17 18  19 20 21  22 23 24  25 26 27  28 29 30  31 32 33  34 35 36]';
% AO.BEND.DeviceList = [
%          1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3;
%          4 1;      4 3; 5 1; 5 2; 5 3; 6 1; 6 2; 6 3;
%          7 1; 7 2; 7 3; 8 1;      8 3; 9 1; 9 2; 9 3;
%         10 1;10 2;10 3;11 1;11 2;11 3;12 1;     12 3];
% AO.BEND.ElementList = [1 2 3  4 5 6  7 8 9  10    12  13 14 15  16 17 18  19 20 21  22    24  25 26 27 28 29 30 31 32 33  34    36]';

AO.BEND.Monitor.MemberOf = {'PlotFamily'; 'BEND'; 'Magnet'; 'Monitor'; 'Save';};
AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_als(AO.BEND.FamilyName, AO.BEND.DeviceList, 0);
AO.BEND.Monitor.HW2PhysicsFcn = @amp2k;
AO.BEND.Monitor.Physics2HWFcn = @k2amp;
AO.BEND.Monitor.Units        = 'Hardware';
AO.BEND.Monitor.HWUnits      = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';
AO.BEND.Monitor.Gain = BENDMonitorGainOffset;

AO.BEND.Setpoint.MemberOf = {'PlotFamily'; 'Setpoint'; 'Save/Restore';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_als(AO.BEND.FamilyName, AO.BEND.DeviceList, 1);
AO.BEND.Setpoint.HW2PhysicsFcn = @amp2k;
AO.BEND.Setpoint.Physics2HWFcn = @k2amp;
AO.BEND.Setpoint.Units        = 'Hardware';
AO.BEND.Setpoint.HWUnits      = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';

AO.BEND.DAC.MemberOf = {'PlotFamily';};
AO.BEND.DAC.Mode = 'Simulator';
AO.BEND.DAC.DataType = 'Scalar';
AO.BEND.DAC.ChannelNames = getname_als('BENDdac', AO.BEND.DeviceList, 1);
AO.BEND.DAC.HW2PhysicsParams = 1;
AO.BEND.DAC.Physics2HWParams = 1;
AO.BEND.DAC.Units        = 'Hardware';
AO.BEND.DAC.HWUnits      = 'Ampere';
AO.BEND.DAC.PhysicsUnits = 'Ampere';

AO.BEND.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.BEND.RampRate.Mode = 'Simulator';
AO.BEND.RampRate.DataType = 'Scalar';
AO.BEND.RampRate.ChannelNames = getname_als('BENDramprate', AO.BEND.DeviceList, 1);
AO.BEND.RampRate.HW2PhysicsParams = 1;
AO.BEND.RampRate.Physics2HWParams = 1;
AO.BEND.RampRate.Units        = 'Hardware';
AO.BEND.RampRate.HWUnits      = 'Ampere/Second';
AO.BEND.RampRate.PhysicsUnits = 'Ampere/Second';

AO.BEND.TimeConstant.MemberOf = {'PlotFamily'; 'Save';};
AO.BEND.TimeConstant.Mode = 'Simulator';
AO.BEND.TimeConstant.DataType = 'Scalar';
AO.BEND.TimeConstant.ChannelNames = getname_als('BENDtimeconstant', AO.BEND.DeviceList, 1);
AO.BEND.TimeConstant.HW2PhysicsParams = 1;
AO.BEND.TimeConstant.Physics2HWParams = 1;
AO.BEND.TimeConstant.Units        = 'Hardware';
AO.BEND.TimeConstant.HWUnits      = 'Second';
AO.BEND.TimeConstant.PhysicsUnits = 'Second';

AO.BEND.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.BEND.OnControl.Mode = 'Simulator';
AO.BEND.OnControl.DataType = 'Scalar';
AO.BEND.OnControl.ChannelNames = getname_als('BENDon', AO.BEND.DeviceList, 1);
AO.BEND.OnControl.HW2PhysicsParams = 1;
AO.BEND.OnControl.Physics2HWParams = 1;
AO.BEND.OnControl.Units        = 'Hardware';
AO.BEND.OnControl.HWUnits      = '';
AO.BEND.OnControl.PhysicsUnits = '';
AO.BEND.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.BEND.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.BEND.On.Mode = 'Simulator';
AO.BEND.On.DataType = 'Scalar';
AO.BEND.On.ChannelNames = getname_als('BENDon', AO.BEND.DeviceList, 0);
AO.BEND.On.HW2PhysicsParams = 1;
AO.BEND.On.Physics2HWParams = 1;
AO.BEND.On.Units        = 'Hardware';
AO.BEND.On.HWUnits      = '';
AO.BEND.On.PhysicsUnits = '';

AO.BEND.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.BEND.Reset.Mode = 'Simulator';
AO.BEND.Reset.DataType = 'Scalar';
AO.BEND.Reset.ChannelNames = getname_als('BENDreset', AO.BEND.DeviceList, 1);
AO.BEND.Reset.HW2PhysicsParams = 1;
AO.BEND.Reset.Physics2HWParams = 1;
AO.BEND.Reset.Units        = 'Hardware';
AO.BEND.Reset.HWUnits      = '';
AO.BEND.Reset.PhysicsUnits = '';

AO.BEND.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.BEND.Ready.Mode = 'Simulator';
AO.BEND.Ready.DataType = 'Scalar';
AO.BEND.Ready.ChannelNames = getname_als('BENDready', AO.BEND.DeviceList, 0);
AO.BEND.Ready.HW2PhysicsParams = 1;
AO.BEND.Ready.Physics2HWParams = 1;
AO.BEND.Ready.Units        = 'Hardware';
AO.BEND.Ready.HWUnits      = '';
AO.BEND.Ready.PhysicsUnits = '';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Superbend Family  (Note: also included in the BEND family) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.BSC.FamilyName = 'BSC';
AO.BSC.MemberOf   = {'BEND';};
AO.BSC.DeviceList = [4 2; 8 2; 12 2];
AO.BSC.ElementList= [ 11;  23;   35];
AO.BSC.Status = 1;

AO.BSC.Monitor.MemberOf = {'PlotFamily'; 'Monitor';};
AO.BSC.Monitor.Mode = 'Simulator';
AO.BSC.Monitor.DataType = 'Scalar';
AO.BSC.Monitor.ChannelNames  = getname_als('BSC', AO.BSC.DeviceList, 0);
AO.BSC.Monitor.HW2PhysicsFcn = @amp2k;
AO.BSC.Monitor.Physics2HWFcn = @k2amp;
AO.BSC.Monitor.Units        = 'Hardware';
AO.BSC.Monitor.HWUnits      = 'Ampere';
AO.BSC.Monitor.PhysicsUnits = 'Radian';

AO.BSC.Setpoint.MemberOf = {'PlotFamily';};
AO.BSC.Setpoint.Mode = 'Simulator';
AO.BSC.Setpoint.DataType = 'Scalar';
AO.BSC.Setpoint.ChannelNames = getname_als('BSC', AO.BSC.DeviceList, 1);
AO.BSC.Setpoint.HW2PhysicsFcn = @amp2k;
AO.BSC.Setpoint.Physics2HWFcn = @k2amp;
AO.BSC.Setpoint.Units        = 'Hardware';
AO.BSC.Setpoint.HWUnits      = 'Ampere';
AO.BSC.Setpoint.PhysicsUnits = 'Radian';

AO.BSC.HallProbe.MemberOf = {'PlotFamily'; 'BEND'; 'Magnet'; 'Monitor';};
AO.BSC.HallProbe.Mode = 'Simulator';
AO.BSC.HallProbe.DataType = 'Scalar';
AO.BSC.HallProbe.ChannelNames = getname_als('BSChall', AO.BSC.DeviceList, 0);
AO.BSC.HallProbe.HW2PhysicsParams = 1;
AO.BSC.HallProbe.Physics2HWParams = 1;
AO.BSC.HallProbe.Units        = 'Hardware';
AO.BSC.HallProbe.HWUnits      = 'Tesla';
AO.BSC.HallProbe.PhysicsUnits = 'Tesla';

AO.BSC.RampRate.MemberOf = {'PlotFamily'; 'BEND'; 'Magnet';};
AO.BSC.RampRate.Mode = 'Simulator';
AO.BSC.RampRate.DataType = 'Scalar';
AO.BSC.RampRate.ChannelNames = getname_als('BENDramprate', AO.BSC.DeviceList, 1);
AO.BSC.RampRate.HW2PhysicsParams = 1;
AO.BSC.RampRate.HW2PhysicsParams = 1;
AO.BSC.RampRate.Units        = 'Hardware';
AO.BSC.RampRate.HWUnits      = 'Ampere/Second';
AO.BSC.RampRate.PhysicsUnits = 'Ampere/Second';

AO.BSC.Limit.MemberOf = {'PlotFamily'; 'BEND'; 'Magnet'; 'Boolean Monitor';};
AO.BSC.Limit.Mode = 'Simulator';
AO.BSC.Limit.DataType = 'Scalar';
AO.BSC.Limit.ChannelNames = getname_als('BSClimit', AO.BSC.DeviceList, 1);
AO.BSC.Limit.HW2PhysicsFcn = @amp2k;
AO.BSC.Limit.Physics2HWFcn = @k2amp;
AO.BSC.Limit.Units        = 'Hardware';
AO.BSC.Limit.HWUnits      = 'Ampere';
AO.BSC.Limit.PhysicsUnits = 'Radian';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VCBSC - Superbend corrector %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.VCBSC.FamilyName = 'VCBSC';
AO.VCBSC.MemberOf   = {};
AO.VCBSC.DeviceList = AO.BSC.DeviceList;
AO.VCBSC.ElementList= AO.BSC.ElementList;
AO.VCBSC.Status = 1;

AO.VCBSC.Monitor.MemberOf = {'PlotFamily'; 'Monitor';};
AO.VCBSC.Monitor.Mode = 'Simulator';
AO.VCBSC.Monitor.DataType = 'Scalar';
AO.VCBSC.Monitor.ChannelNames = getname_als('VCBSC', AO.VCBSC.DeviceList, 0);
AO.VCBSC.Monitor.HW2PhysicsParams = 1;    % Radian/Ampere:  HW2Physics*Amps=Radian
AO.VCBSC.Monitor.Physics2HWParams = 1;
AO.VCBSC.Monitor.Units        = 'Hardware';
AO.VCBSC.Monitor.HWUnits      = 'Ampere';
AO.VCBSC.Monitor.PhysicsUnits = 'Radian';

AO.VCBSC.Setpoint.MemberOf = {'PlotFamily';};
AO.VCBSC.Setpoint.Mode = 'Simulator';
AO.VCBSC.Setpoint.DataType = 'Scalar';
AO.VCBSC.Setpoint.ChannelNames = getname_als('VCBSC', AO.VCBSC.DeviceList, 1);
AO.VCBSC.Setpoint.HW2PhysicsParams = 1;    % Radian/Ampere:  HW2Physics*Amps=Radian
AO.VCBSC.Setpoint.Physics2HWParams = 1;
AO.VCBSC.Setpoint.Units        = 'Hardware';
AO.VCBSC.Setpoint.HWUnits      = 'Ampere';
AO.VCBSC.Setpoint.PhysicsUnits = 'Radian';

AO.VCBSC.RampRate.MemberOf = {'PlotFamily';};
AO.VCBSC.RampRate.Mode = 'Simulator';
AO.VCBSC.RampRate.DataType = 'Scalar';
AO.VCBSC.RampRate.ChannelNames = getname_als('VCBSCramprate', AO.VCBSC.DeviceList, 1);
AO.VCBSC.RampRate.HW2PhysicsParams = 1;
AO.VCBSC.RampRate.Physics2HWParams = 1;
AO.VCBSC.RampRate.Units        = 'Hardware';
AO.VCBSC.RampRate.HWUnits      = 'Ampere/Second';
AO.VCBSC.RampRate.PhysicsUnits = 'Ampere/Second';

AO.VCBSC.TimeConstant.MemberOf = {'PlotFamily';};
AO.VCBSC.TimeConstant.Mode = 'Simulator';
AO.VCBSC.TimeConstant.DataType = 'Scalar';
AO.VCBSC.TimeConstant.ChannelNames = getname_als('VCBSCtimeconstant', AO.VCBSC.DeviceList, 1);
AO.VCBSC.TimeConstant.HW2PhysicsParams = 1;
AO.VCBSC.TimeConstant.Physics2HWParams = 1;
AO.VCBSC.TimeConstant.Units        = 'Hardware';
AO.VCBSC.TimeConstant.HWUnits      = 'Second';
AO.VCBSC.TimeConstant.PhysicsUnits = 'Second';

AO.VCBSC.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.VCBSC.OnControl.Mode = 'Simulator';
AO.VCBSC.OnControl.DataType = 'Scalar';
AO.VCBSC.OnControl.ChannelNames = getname_als('VCBSCon', AO.VCBSC.DeviceList, 1);
AO.VCBSC.OnControl.HW2PhysicsParams = 1;
AO.VCBSC.OnControl.Physics2HWParams = 1;
AO.VCBSC.OnControl.Units        = 'Hardware';
AO.VCBSC.OnControl.HWUnits      = '';
AO.VCBSC.OnControl.PhysicsUnits = '';
AO.VCBSC.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.VCBSC.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.VCBSC.On.Mode = 'Simulator';
AO.VCBSC.On.DataType = 'Scalar';
AO.VCBSC.On.ChannelNames = getname_als('VCBSCon', AO.VCBSC.DeviceList, 0);
AO.VCBSC.On.HW2PhysicsParams = 1;
AO.VCBSC.On.Physics2HWParams = 1;
AO.VCBSC.On.Units        = 'Hardware';
AO.VCBSC.On.HWUnits      = '';
AO.VCBSC.On.PhysicsUnits = '';

AO.VCBSC.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.VCBSC.Ready.Mode = 'Simulator';
AO.VCBSC.Ready.DataType = 'Scalar';
AO.VCBSC.Ready.ChannelNames = getname_als('VCBSCready', AO.VCBSC.DeviceList, 0);
AO.VCBSC.Ready.HW2PhysicsParams = 1;
AO.VCBSC.Ready.Physics2HWParams = 1;
AO.VCBSC.Ready.Units        = 'Hardware';
AO.VCBSC.Ready.HWUnits      = '';
AO.VCBSC.Ready.PhysicsUnits = '';

AO.VCBSC.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.VCBSC.Reset.Mode = 'Simulator';
AO.VCBSC.Reset.DataType = 'Scalar';
AO.VCBSC.Reset.ChannelNames = getname_als('VCBSCreset', AO.VCBSC.DeviceList, 0);
AO.VCBSC.Reset.HW2PhysicsParams = 1;
AO.VCBSC.Reset.Physics2HWParams = 1;
AO.VCBSC.Reset.Units        = 'Hardware';
AO.VCBSC.Reset.HWUnits      = '';
AO.VCBSC.Reset.PhysicsUnits = '';


%%%%%%%%%%%%%%%%%%%%
% Chicane Families %
%%%%%%%%%%%%%%%%%%%%
AO.HCMCHICANE.FamilyName = 'HCMCHICANE';
AO.HCMCHICANE.MemberOf   = {'HCMCHICANE'; 'Magnet'};
AO.HCMCHICANE.DeviceList = [
    4 1;
    4 3;
    6 1
    6 3
    ];
AO.HCMCHICANE.ElementList = local_dev2elem('HCMCHICANE', AO.HCMCHICANE.DeviceList);
AO.HCMCHICANE.Status = ones(size(AO.HCMCHICANE.DeviceList,1),1);
%AO.HCMCHICANE.Status = [1 1 1]';

AO.HCMCHICANE.Monitor.MemberOf = {'PlotFamily'; 'Monitor'; 'Save';};
AO.HCMCHICANE.Monitor.Mode = 'Simulator';
AO.HCMCHICANE.Monitor.DataType = 'Scalar';
AO.HCMCHICANE.Monitor.ChannelNames = getname_als(AO.HCMCHICANE.FamilyName, AO.HCMCHICANE.DeviceList, 0);
AO.HCMCHICANE.Monitor.HW2PhysicsFcn = @amp2k;
AO.HCMCHICANE.Monitor.Physics2HWFcn = @k2amp;
%AO.HCMCHICANE.Monitor.HW2PhysicsParams = 1;    % Radian/Ampere:  HW2Physics*Amps=Radian
%AO.HCMCHICANE.Monitor.Physics2HWParams = 1;
AO.HCMCHICANE.Monitor.Units        = 'Hardware';
AO.HCMCHICANE.Monitor.HWUnits      = 'Ampere';
AO.HCMCHICANE.Monitor.PhysicsUnits = 'Radian';

AO.HCMCHICANE.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.HCMCHICANE.Setpoint.Mode = 'Simulator';
AO.HCMCHICANE.Setpoint.DataType = 'Scalar';
AO.HCMCHICANE.Setpoint.ChannelNames = getname_als(AO.HCMCHICANE.FamilyName, AO.HCMCHICANE.DeviceList, 1);
AO.HCMCHICANE.Setpoint.HW2PhysicsFcn = @amp2k;
AO.HCMCHICANE.Setpoint.Physics2HWFcn = @k2amp;
%AO.HCMCHICANE.Setpoint.HW2PhysicsParams = 1;    % Radian/Ampere:  HW2Physics*Amps=Radian
%AO.HCMCHICANE.Setpoint.Physics2HWParams = 1;
AO.HCMCHICANE.Setpoint.Units        = 'Hardware';
AO.HCMCHICANE.Setpoint.HWUnits      = 'Ampere';
AO.HCMCHICANE.Setpoint.PhysicsUnits = 'Radian';

AO.HCMCHICANE.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.HCMCHICANE.RampRate.Mode = 'Simulator';
AO.HCMCHICANE.RampRate.DataType = 'Scalar';
AO.HCMCHICANE.RampRate.ChannelNames = getname_als('HCMCHICANEramprate', AO.HCMCHICANE.DeviceList, 1);
AO.HCMCHICANE.RampRate.HW2PhysicsParams = 1;
AO.HCMCHICANE.RampRate.Physics2HWParams = 1;
AO.HCMCHICANE.RampRate.Units        = 'Hardware';
AO.HCMCHICANE.RampRate.HWUnits      = 'Ampere/Second';
AO.HCMCHICANE.RampRate.PhysicsUnits = 'Radian/Second';

AO.HCMCHICANE.TimeConstant.MemberOf = {'PlotFamily'; 'Save';};
AO.HCMCHICANE.TimeConstant.Mode = 'Simulator';
AO.HCMCHICANE.TimeConstant.DataType = 'Scalar';
AO.HCMCHICANE.TimeConstant.ChannelNames = getname_als('HCMCHICANEtimeconstant', AO.HCMCHICANE.DeviceList, 1);
AO.HCMCHICANE.TimeConstant.HW2PhysicsParams = 1;
AO.HCMCHICANE.TimeConstant.Physics2HWParams = 1;
AO.HCMCHICANE.TimeConstant.Units        = 'Hardware';
AO.HCMCHICANE.TimeConstant.HWUnits      = 'Second';
AO.HCMCHICANE.TimeConstant.PhysicsUnits = 'Second';

AO.HCMCHICANE.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.HCMCHICANE.OnControl.Mode = 'Simulator';
AO.HCMCHICANE.OnControl.DataType = 'Scalar';
AO.HCMCHICANE.OnControl.ChannelNames = getname_als('HCMCHICANEon', AO.HCMCHICANE.DeviceList, 1);
AO.HCMCHICANE.OnControl.HW2PhysicsParams = 1;
AO.HCMCHICANE.OnControl.Physics2HWParams = 1;
AO.HCMCHICANE.OnControl.Units        = 'Hardware';
AO.HCMCHICANE.OnControl.HWUnits      = '';
AO.HCMCHICANE.OnControl.PhysicsUnits = '';
AO.HCMCHICANE.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.HCMCHICANE.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.HCMCHICANE.On.Mode = 'Simulator';
AO.HCMCHICANE.On.DataType = 'Scalar';
AO.HCMCHICANE.On.ChannelNames = getname_als('HCMCHICANEon', AO.HCMCHICANE.DeviceList, 0);
AO.HCMCHICANE.On.HW2PhysicsParams = 1;
AO.HCMCHICANE.On.Physics2HWParams = 1;
AO.HCMCHICANE.On.Units        = 'Hardware';
AO.HCMCHICANE.On.HWUnits      = '';
AO.HCMCHICANE.On.PhysicsUnits = '';



AO.VCMCHICANE.FamilyName = 'VCMCHICANE';
AO.VCMCHICANE.MemberOf   = {'VCMCHICANE'; 'Magnet'};
AO.VCMCHICANE.DeviceList = [
    4 1; 4 3;];
% AO.VCMCHICANE.DeviceList = [
%     4 1; 4 2; 4 3;
%     6 2;
%     11 2];
AO.VCMCHICANE.ElementList = local_dev2elem('VCMCHICANE', AO.VCMCHICANE.DeviceList);
AO.VCMCHICANE.Status = ones(size(AO.VCMCHICANE.DeviceList,1),1);

AO.VCMCHICANE.Monitor.MemberOf = {'PlotFamily'; 'Monitor';};
AO.VCMCHICANE.Monitor.Mode = 'Simulator';
AO.VCMCHICANE.Monitor.DataType = 'Scalar';
AO.VCMCHICANE.Monitor.ChannelNames = getname_als(AO.VCMCHICANE.FamilyName, AO.VCMCHICANE.DeviceList, 0);
AO.VCMCHICANE.Monitor.HW2PhysicsFcn = @amp2k;
AO.VCMCHICANE.Monitor.Physics2HWFcn = @k2amp;
%AO.VCMCHICANE.Monitor.HW2PhysicsParams = 1;    % Radian/Ampere:  HW2Physics*Amps=Radian
%AO.VCMCHICANE.Monitor.Physics2HWParams = 1;
AO.VCMCHICANE.Monitor.Units        = 'Hardware';
AO.VCMCHICANE.Monitor.HWUnits      = 'Ampere';
AO.VCMCHICANE.Monitor.PhysicsUnits = 'Radian';

AO.VCMCHICANE.Setpoint.MemberOf = {'PlotFamily';};
AO.VCMCHICANE.Setpoint.Mode = 'Simulator';
AO.VCMCHICANE.Setpoint.DataType = 'Scalar';
AO.VCMCHICANE.Setpoint.ChannelNames = getname_als(AO.VCMCHICANE.FamilyName, AO.VCMCHICANE.DeviceList, 1);
AO.VCMCHICANE.Setpoint.HW2PhysicsFcn = @amp2k;
AO.VCMCHICANE.Setpoint.Physics2HWFcn = @k2amp;
%AO.VCMCHICANE.Setpoint.HW2PhysicsParams = 1;    % Radian/Ampere:  HW2Physics*Amps=Radian
%AO.VCMCHICANE.Setpoint.Physics2HWParams = 1;
AO.VCMCHICANE.Setpoint.Units        = 'Hardware';
AO.VCMCHICANE.Setpoint.HWUnits      = 'Ampere';
AO.VCMCHICANE.Setpoint.PhysicsUnits = 'Radian';

AO.VCMCHICANE.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.VCMCHICANE.RampRate.Mode = 'Simulator';
AO.VCMCHICANE.RampRate.DataType = 'Scalar';
AO.VCMCHICANE.RampRate.ChannelNames = getname_als('VCMCHICANEramprate', AO.VCMCHICANE.DeviceList, 1);
AO.VCMCHICANE.RampRate.HW2PhysicsParams = 1;
AO.VCMCHICANE.RampRate.Physics2HWParams = 1;
AO.VCMCHICANE.RampRate.Units        = 'Hardware';
AO.VCMCHICANE.RampRate.HWUnits      = 'Ampere/Second';
AO.VCMCHICANE.RampRate.PhysicsUnits = 'Radian/Second';

AO.VCMCHICANE.TimeConstant.MemberOf = {'PlotFamily'; 'Save';};
AO.VCMCHICANE.TimeConstant.Mode = 'Simulator';
AO.VCMCHICANE.TimeConstant.DataType = 'Scalar';
AO.VCMCHICANE.TimeConstant.ChannelNames = getname_als('VCMCHICANEtimeconstant', AO.VCMCHICANE.DeviceList, 1);
AO.VCMCHICANE.TimeConstant.HW2PhysicsParams = 1;
AO.VCMCHICANE.TimeConstant.Physics2HWParams = 1;
AO.VCMCHICANE.TimeConstant.Units        = 'Hardware';
AO.VCMCHICANE.TimeConstant.HWUnits      = 'Second';
AO.VCMCHICANE.TimeConstant.PhysicsUnits = 'Second';

AO.VCMCHICANE.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.VCMCHICANE.OnControl.Mode = 'Simulator';
AO.VCMCHICANE.OnControl.DataType = 'Scalar';
AO.VCMCHICANE.OnControl.ChannelNames = getname_als('VCMCHICANEon', AO.VCMCHICANE.DeviceList, 1);
AO.VCMCHICANE.OnControl.HW2PhysicsParams = 1;
AO.VCMCHICANE.OnControl.Physics2HWParams = 1;
AO.VCMCHICANE.OnControl.Units        = 'Hardware';
AO.VCMCHICANE.OnControl.HWUnits      = '';
AO.VCMCHICANE.OnControl.PhysicsUnits = '';
AO.VCMCHICANE.OnControl.SpecialFunctionSet = @setsp_OnControlMagnet;

AO.VCMCHICANE.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.VCMCHICANE.On.Mode = 'Simulator';
AO.VCMCHICANE.On.DataType = 'Scalar';
AO.VCMCHICANE.On.ChannelNames = getname_als('VCMCHICANEon', AO.VCMCHICANE.DeviceList, 0);
AO.VCMCHICANE.On.HW2PhysicsParams = 1;
AO.VCMCHICANE.On.Physics2HWParams = 1;
AO.VCMCHICANE.On.Units        = 'Hardware';
AO.VCMCHICANE.On.HWUnits      = '';
AO.VCMCHICANE.On.PhysicsUnits = '';


% Motor Chicane Family
% Device [Sector 1] - Motor 1
% Device [Sector 2] - Motor 2
% Device [Sector 3] - Motor 3 (sector 6 does not have motor 3)
AO.HCMCHICANEM.FamilyName = 'HCMCHICANEM';
AO.HCMCHICANEM.MemberOf   = {'Motor Chicane'; 'Magnet'};
AO.HCMCHICANEM.DeviceList = [4 1; 4 2; 6 1; 6 2; 7 1; 7 2; 11 1; 11 2];
AO.HCMCHICANEM.ElementList = [3*3+1; 3*3+2; 5*3+1; 5*3+2; 6*3+1; 6*3+2; 10*3+1; 10*3+2];
%AO.HCMCHICANEM.ElementList = [3*3+1; 3*3+2; 3*3+3; 5*3+1; 5*3+2; 10*3+1; 10*3+2; 10*3+3;];
AO.HCMCHICANEM.Status = ones(size(AO.HCMCHICANEM.ElementList));

AO.HCMCHICANEM.Monitor.MemberOf = {'PlotFamily'; 'Monitor'; 'Save';};
AO.HCMCHICANEM.Monitor.Mode = 'Simulator';
AO.HCMCHICANEM.Monitor.DataType = 'Scalar';
AO.HCMCHICANEM.Monitor.ChannelNames = getname_als(AO.HCMCHICANEM.FamilyName, AO.HCMCHICANEM.DeviceList, 0);
AO.HCMCHICANEM.Monitor.HW2PhysicsParams = 1;
AO.HCMCHICANEM.Monitor.Physics2HWParams = 1;
AO.HCMCHICANEM.Monitor.Units        = 'Hardware';
AO.HCMCHICANEM.Monitor.HWUnits      = 'Degrees';
AO.HCMCHICANEM.Monitor.PhysicsUnits = 'Radian';

AO.HCMCHICANEM.Monitor.AT.SpecialFunctionGet = @getpvmodel_hcmchicanem;
AO.HCMCHICANEM.Monitor.AT.SpecialFunctionSet = @setpvmodel_hcmchicanem;

AO.HCMCHICANEM.Setpoint.MemberOf = {'PlotFamily'; 'Save/Restore';};
AO.HCMCHICANEM.Setpoint.Mode = 'Simulator';
AO.HCMCHICANEM.Setpoint.DataType = 'Scalar';
AO.HCMCHICANEM.Setpoint.ChannelNames = getname_als(AO.HCMCHICANEM.FamilyName, AO.HCMCHICANEM.DeviceList, 1);
AO.HCMCHICANEM.Setpoint.HW2PhysicsParams = 1;
AO.HCMCHICANEM.Setpoint.Physics2HWParams = 1;
AO.HCMCHICANEM.Setpoint.Units        = 'Hardware';
AO.HCMCHICANEM.Setpoint.HWUnits      = 'Degrees';
AO.HCMCHICANEM.Setpoint.PhysicsUnits = 'Radian';

AO.HCMCHICANEM.Setpoint.AT.SpecialFunctionGet = @getpvmodel_hcmchicanem;
AO.HCMCHICANEM.Setpoint.AT.SpecialFunctionSet = @setpvmodel_hcmchicanem;

AO.HCMCHICANEM.RampRate.MemberOf = {'PlotFamily'; 'Save';};
AO.HCMCHICANEM.RampRate.Mode = 'Simulator';
AO.HCMCHICANEM.RampRate.DataType = 'Scalar';
AO.HCMCHICANEM.RampRate.ChannelNames = getname_als('HCMCHICANEMramprate', AO.HCMCHICANEM.DeviceList, 1);
AO.HCMCHICANEM.RampRate.HW2PhysicsParams = 1;
AO.HCMCHICANEM.RampRate.Physics2HWParams = 1;
AO.HCMCHICANEM.RampRate.Units        = 'Hardware';
AO.HCMCHICANEM.RampRate.HWUnits      = 'Degree/Second';
AO.HCMCHICANEM.RampRate.PhysicsUnits = 'Radian/Second';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Insertion Device Families %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.ID.FamilyName = 'ID';
AO.ID.MemberOf   = {'ID'; 'Insertion Device'};
AO.ID.DeviceList = [
    4 1     %IDJ
    4 2     %MERLIN
    5 1	    %IDH
    6 1	    %IDP - IVID
    6 2     %IDQ
    7 1     % COSMIC
    7 2	    %IDK
    8 1	    %IDA
    9 1	    %IDG
    10 1    %IDM
    11 1    %IDL
    11 2    %IDN
    12 1];  %IDC
AO.ID.ElementList = local_dev2elem('ID', AO.ID.DeviceList);
AO.ID.Status = ones(size(AO.ID.DeviceList,1),1);
% AO.ID.CommonNames = [
%     'SR04U1'
%     'SR04U2'
%     'SR05W '
%     'SR06U1'
%     'SR06U2'
%     'SR07U2'
%     'SR08U '
%     'SR09U '
%     'SR10U '
%     'SR11U1'
%     'SR11U2'
%     'SR12U1'
%     ];

if NoMerlin
    i = findrowindex([4 2], AO.ID.DeviceList);
    AO.ID.Status(i) = 0;
    fprintf('   Merlin status turned off.  Use DeviceList=[4 2] explicitly to get or set.\n');
end

if NoEPU62
    i = findrowindex([6 2], AO.ID.DeviceList);
    AO.ID.Status(i) = 0;
    fprintf('   EPU6-2 / IDQ status turned off.  Use DeviceList=[6 2] explicitly to get or set.\n');
end

if NoEPU71
    i = findrowindex([7 1], AO.ID.DeviceList);
    AO.ID.Status(i) = 0;
    fprintf('   EPU7-1 / COSMIC status turned off.  Use DeviceList=[7 1] explicitly to get or set.\n');
end

if NoEPU72
    i = findrowindex([7 2], AO.ID.DeviceList);
    AO.ID.Status(i) = 0;
    fprintf('   EPU7-2 / IDK status turned off.  Use DeviceList=[7 2] explicitly to get or set.\n');
end

if NoEPU112
    i = findrowindex([11 2], AO.ID.DeviceList);
    AO.ID.Status(i) = 0;
    fprintf('   EPU11-2 / IDN status turned off.  Use DeviceList=[11 2] explicitly to get or set.\n');
end

AO.ID.Monitor.MemberOf = {'PlotFamily'; 'Monitor'; 'Save';};
AO.ID.Monitor.Mode = 'Simulator';
AO.ID.Monitor.DataType = 'Scalar';
AO.ID.Monitor.ChannelNames = getname_als(AO.ID.FamilyName, AO.ID.DeviceList, 0);
AO.ID.Monitor.HW2PhysicsParams = 1;
AO.ID.Monitor.Physics2HWParams = 1;
AO.ID.Monitor.Units        = 'Hardware';
AO.ID.Monitor.HWUnits      = 'mm';
AO.ID.Monitor.PhysicsUnits = 'mm';

AO.ID.Setpoint.MemberOf = {'PlotFamily'; 'Setpoint'; 'Save';};
AO.ID.Setpoint.Mode = 'Simulator';
AO.ID.Setpoint.DataType = 'Scalar';
AO.ID.Setpoint.ChannelNames = getname_als(AO.ID.FamilyName, AO.ID.DeviceList, 1);
AO.ID.Setpoint.HW2PhysicsParams = 1;
AO.ID.Setpoint.Physics2HWParams = 1;
AO.ID.Setpoint.Units        = 'Hardware';
AO.ID.Setpoint.HWUnits      = 'mm';
AO.ID.Setpoint.PhysicsUnits = 'mm';

AO.ID.Velocity.MemberOf = {'PlotFamily'; 'Monitor';};
AO.ID.Velocity.Mode = 'Simulator';
AO.ID.Velocity.DataType = 'Scalar';
AO.ID.Velocity.ChannelNames = getname_als('IDvel', AO.ID.DeviceList, 0);
AO.ID.Velocity.HW2PhysicsParams = 1;
AO.ID.Velocity.Physics2HWParams = 1;
AO.ID.Velocity.Units        = 'Hardware';
AO.ID.Velocity.HWUnits      = 'mm/s';
AO.ID.Velocity.PhysicsUnits = 'mm/s';

AO.ID.VelocityControl.MemberOf = {'PlotFamily';};
AO.ID.VelocityControl.Mode = 'Simulator';
AO.ID.VelocityControl.DataType = 'Scalar';
AO.ID.VelocityControl.ChannelNames = getname_als('IDvel', AO.ID.DeviceList, 1);
AO.ID.VelocityControl.HW2PhysicsParams = 1;
AO.ID.VelocityControl.Physics2HWParams = 1;
AO.ID.VelocityControl.Units        = 'Hardware';
AO.ID.VelocityControl.HWUnits      = 'mm/s';
AO.ID.VelocityControl.PhysicsUnits = 'mm/s';

AO.ID.VelocityProfile.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.ID.VelocityProfile.Mode = 'Simulator';
AO.ID.VelocityProfile.DataType = 'Scalar';
AO.ID.VelocityProfile.ChannelNames = getname_als('IDVelocityProfile', AO.ID.DeviceList, 0);
AO.ID.VelocityProfile.HW2PhysicsParams = 1;
AO.ID.VelocityProfile.Physics2HWParams = 1;
AO.ID.VelocityProfile.Units        = 'Hardware';
AO.ID.VelocityProfile.HWUnits      = '';
AO.ID.VelocityProfile.PhysicsUnits = '';

AO.ID.RunFlag.MemberOf = {'PlotFamily'; 'Boolean Monitor'; 'RunFlag';};
AO.ID.RunFlag.Mode = 'Simulator';
AO.ID.RunFlag.DataType = 'Scalar';
AO.ID.RunFlag.ChannelNames = getname_als('IDrunflag', AO.ID.DeviceList, 2);
AO.ID.RunFlag.HW2PhysicsParams = 1;
AO.ID.RunFlag.Physics2HWParams = 1;
AO.ID.RunFlag.Units        = 'Hardware';
AO.ID.RunFlag.HWUnits      = '';
AO.ID.RunFlag.PhysicsUnits = '';

AO.ID.UserGap.MemberOf = {'PlotFamily';};
AO.ID.UserGap.Mode = 'Simulator';
AO.ID.UserGap.DataType = 'Scalar';
AO.ID.UserGap.ChannelNames = getname_als('UserGap', AO.ID.DeviceList, 1);
AO.ID.UserGap.HW2PhysicsParams = 1;
AO.ID.UserGap.Physics2HWParams = 1;
AO.ID.UserGap.Units        = 'Hardware';
AO.ID.UserGap.HWUnits = 'mm';
AO.ID.UserGap.PhysicsUnits = 'mm';

AO.ID.GapEnableControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.ID.GapEnableControl.Mode = 'Simulator';
AO.ID.GapEnableControl.DataType = 'Scalar';
AO.ID.GapEnableControl.ChannelNames = getname_als('GapEnableBC', AO.ID.DeviceList, 3);
AO.ID.GapEnableControl.HW2PhysicsParams = 1;
AO.ID.GapEnableControl.Physics2HWParams = 1;
AO.ID.GapEnableControl.Units        = 'Hardware';
AO.ID.GapEnableControl.HWUnits      = '';
AO.ID.GapEnableControl.PhysicsUnits = '';

AO.ID.GapEnable.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.ID.GapEnable.Mode = 'Simulator';
AO.ID.GapEnable.DataType = 'Scalar';
AO.ID.GapEnable.ChannelNames = getname_als('GapEnable', AO.ID.DeviceList, 2);
AO.ID.GapEnable.HW2PhysicsParams = 1;
AO.ID.GapEnable.Physics2HWParams = 1;
AO.ID.GapEnable.Units        = 'Hardware';
AO.ID.GapEnable.HWUnits      = '';
AO.ID.GapEnable.PhysicsUnits = '';

AO.ID.FFEnableControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.ID.FFEnableControl.Mode = 'Simulator';
AO.ID.FFEnableControl.DataType = 'Scalar';
AO.ID.FFEnableControl.ChannelNames = getname_als('FFEnable', AO.ID.DeviceList, 3);
AO.ID.FFEnableControl.HW2PhysicsParams = 1;
AO.ID.FFEnableControl.Physics2HWParams = 1;
AO.ID.FFEnableControl.Units        = 'Hardware';
AO.ID.FFEnableControl.HWUnits      = '';
AO.ID.FFEnableControl.PhysicsUnits = '';

AO.ID.FFEnable.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.ID.FFEnable.Mode = 'Simulator';
AO.ID.FFEnable.DataType = 'Scalar';
AO.ID.FFEnable.ChannelNames = getname_als('FFEnable', AO.ID.DeviceList, 2);
AO.ID.FFEnable.HW2PhysicsParams = 1;
AO.ID.FFEnable.Physics2HWParams = 1;
AO.ID.FFEnable.Units        = 'Hardware';
AO.ID.FFEnable.HWUnits      = '';
AO.ID.FFEnable.PhysicsUnits = '';

AO.ID.FFReadTable.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.ID.FFReadTable.Mode = 'Simulator';
AO.ID.FFReadTable.DataType = 'Scalar';
AO.ID.FFReadTable.ChannelNames = [
    'sr04u:FFRead:bo '
    'sr04u2:FFRead:bo'
    'sr05w:FFRead:bo '
    'sr06u:FFRead:bo '
    'sr06u2:FFRead:bo'
    'sr07u1:FFRead:bo'
    'sr07u2:FFRead:bo'
    'sr08u:FFRead:bo '
    'sr09u:FFRead:bo '
    'sr10u:FFRead:bo '
    'sr11u1:FFRead:bo'
    'sr11u2:FFRead:bo'
    'sr12u:FFRead:bo '];
AO.ID.FFReadTable.HW2PhysicsParams = 1;
AO.ID.FFReadTable.Physics2HWParams = 1;
AO.ID.FFReadTable.Units        = 'Hardware';
AO.ID.FFReadTable.HWUnits      = '';
AO.ID.FFReadTable.PhysicsUnits = '';

AO.ID.FFTableHeader.MemberOf = {'PlotFamily'; 'Monitor';};
AO.ID.FFTableHeader.Mode = 'Simulator';
AO.ID.FFTableHeader.DataType = 'Scalar';
AO.ID.FFTableHeader.ChannelNames = [
    'sr04:FFTblHdr  '
    'sr04u2:FFTblHdr'
    'sr05:FFTblHdr  '
    'sr06:FFTblHdr  '
    'sr06u2:FFTblHdr'
    'sr07u1:FFTblHdr'
    'sr07u2:FFTblHdr'
    'sr08u:FFTblHdr '
    'sr09u:FFTblHdr '
    'sr10u:FFTblHdr '
    'sr11u1:FFTblHdr'
    'sr11u2:FFTblHdr'
    'sr12u:FFTblHdr '    ];
AO.ID.FFTableHeader.HW2PhysicsParams = 1;
AO.ID.FFTableHeader.Physics2HWParams = 1;
AO.ID.FFTableHeader.Units        = '';
AO.ID.FFTableHeader.HWUnits      = '';
AO.ID.FFTableHeader.PhysicsUnits = '';


AO.ID.Home.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.ID.Home.Mode = 'Simulator';
AO.ID.Home.DataType = 'Scalar';
AO.ID.Home.ChannelNames = [
    'sr04u:Vgap_mtr_done    '
    'sr04u2:Vgap_mtr_done   '
    'SR05W___GDS1HS_BM03    '
    'srioc06u03:UnduDrv_hchk'
    'sr06u2:Vgap_mtr_done   '
    'sr07u1:Vgap_mtr_done   '
    'sr07u2:Vgap_mtr_done   '
    '                       '
    '                       '
    '                       '
    'sr11u1:Vgap_mtr_done   '
    'sr11u2:Vgap_mtr_done   '
    '                       '
    ];
AO.ID.Home.HW2PhysicsParams = 1;
AO.ID.Home.Physics2HWParams = 1;
AO.ID.Home.Units        = '';
AO.ID.Home.HWUnits      = '';
AO.ID.Home.PhysicsUnits = '';

AO.ID.MoveCount.MemberOf = {'PlotFamily'; 'Monitor';};
AO.ID.MoveCount.Mode = 'Simulator';
AO.ID.MoveCount.DataType = 'Scalar';
AO.ID.MoveCount.ChannelNames = getname_als('MoveCount', AO.ID.DeviceList, 2);
AO.ID.MoveCount.HW2PhysicsParams = 1;
AO.ID.MoveCount.Physics2HWParams = 1;
AO.ID.MoveCount.Units        = 'Hardware';
AO.ID.MoveCount.HWUnits      = '';
AO.ID.MoveCount.PhysicsUnits = '';

AO.ID.Amp.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.ID.Amp.Mode = 'Simulator';
AO.ID.Amp.DataType = 'Scalar';
AO.ID.Amp.ChannelNames = getname_als('Amp', AO.ID.DeviceList);
AO.ID.Amp.HW2PhysicsParams = 1;
AO.ID.Amp.Physics2HWParams = 1;
AO.ID.Amp.Units        = 'Hardware';
AO.ID.Amp.HWUnits      = '';
AO.ID.Amp.PhysicsUnits = '';

AO.ID.AmpReset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.ID.AmpReset.Mode = 'Simulator';
AO.ID.AmpReset.DataType = 'Scalar';
AO.ID.AmpReset.ChannelNames = getname_als('AmpReset', AO.ID.DeviceList);
AO.ID.AmpReset.HW2PhysicsParams = 1;
AO.ID.AmpReset.Physics2HWParams = 1;
AO.ID.AmpReset.Units        = 'Hardware';
AO.ID.AmpReset.HWUnits      = '';
AO.ID.AmpReset.PhysicsUnits = '';



AO.EPU.FamilyName = 'EPU';
AO.EPU.MemberOf   = {'EPU'};
AO.EPU.DeviceList = [
    4 1	    %IDJ
    4 2     %MERLIN (if you remove, adjust the .Position)
    6 2     %IDQ
    7 1     % COSMIC
    7 2     %IDK
    11 1    %IDL
    11 2    %IDN
    ];
AO.EPU.ElementList = local_dev2elem('EPU', AO.EPU.DeviceList);
AO.EPU.Status = ones(size(AO.EPU.DeviceList,1),1);

if NoMerlin
    i = findrowindex([4 2], AO.EPU.DeviceList);
    AO.EPU.Status(i) = 0;
end
if NoEPU62
    i = findrowindex([6 2], AO.EPU.DeviceList);
    AO.EPU.Status(i) = 0;
end
if NoEPU71
    i = findrowindex([7 1], AO.EPU.DeviceList);
    AO.EPU.Status(i) = 0;
end
if NoEPU72
    i = findrowindex([7 2], AO.EPU.DeviceList);
    AO.EPU.Status(i) = 0;
end
if NoEPU112
    i = findrowindex([11 2], AO.EPU.DeviceList);
    AO.EPU.Status(i) = 0;
end

AO.EPU.Monitor.MemberOf = {'PlotFamily'; 'Monitor'; 'Save';};
AO.EPU.Monitor.Mode = 'Simulator';
AO.EPU.Monitor.DataType = 'Scalar';
AO.EPU.Monitor.ChannelNames = getname_als(AO.EPU.FamilyName, AO.EPU.DeviceList, 0);
AO.EPU.Monitor.HW2PhysicsParams = 1;
AO.EPU.Monitor.Physics2HWParams = 1;
AO.EPU.Monitor.Units        = 'Hardware';
AO.EPU.Monitor.HWUnits      = 'mm';
AO.EPU.Monitor.PhysicsUnits = '';

AO.EPU.Setpoint.MemberOf = {'PlotFamily'; 'Setpoint';};
AO.EPU.Setpoint.Mode = 'Simulator';
AO.EPU.Setpoint.DataType = 'Scalar';
AO.EPU.Setpoint.ChannelNames = getname_als(AO.EPU.FamilyName, AO.EPU.DeviceList, 1);
AO.EPU.Setpoint.HW2PhysicsParams = 1;
AO.EPU.Setpoint.Physics2HWParams = 1;
AO.EPU.Setpoint.Units        = 'Hardware';
AO.EPU.Setpoint.HWUnits      = 'mm';
AO.EPU.Setpoint.PhysicsUnits = 'mm';

AO.EPU.OffsetA.MemberOf = {'PlotFamily'; 'Monitor';};
AO.EPU.OffsetA.Mode = 'Simulator';
AO.EPU.OffsetA.DataType = 'Scalar';
AO.EPU.OffsetA.ChannelNames = getname_als('EPUOffsetA', AO.EPU.DeviceList, 1);
AO.EPU.OffsetA.HW2PhysicsParams = 1;
AO.EPU.OffsetA.Physics2HWParams = 1;
AO.EPU.OffsetA.Units        = 'Hardware';
AO.EPU.OffsetA.HWUnits      = 'mm';
AO.EPU.OffsetA.PhysicsUnits = 'mm';

AO.EPU.OffsetAControl.MemberOf = {'PlotFamily';};
AO.EPU.OffsetAControl.Mode = 'Simulator';
AO.EPU.OffsetAControl.DataType = 'Scalar';
AO.EPU.OffsetAControl.ChannelNames = getname_als('EPUOffsetASP', AO.EPU.DeviceList, 1);
AO.EPU.OffsetAControl.HW2PhysicsParams = 1;
AO.EPU.OffsetAControl.Physics2HWParams = 1;
AO.EPU.OffsetAControl.Units        = 'Hardware';
AO.EPU.OffsetAControl.HWUnits      = 'mm';
AO.EPU.OffsetAControl.PhysicsUnits = 'mm';

AO.EPU.OffsetB.MemberOf = {'PlotFamily'; 'Monitor';};
AO.EPU.OffsetB.Mode = 'Simulator';
AO.EPU.OffsetB.DataType = 'Scalar';
AO.EPU.OffsetB.ChannelNames = getname_als('EPUOffsetB', AO.EPU.DeviceList, 1);
AO.EPU.OffsetB.HW2PhysicsParams = 1;
AO.EPU.OffsetB.Physics2HWParams = 1;
AO.EPU.OffsetB.Units        = 'Hardware';
AO.EPU.OffsetB.HWUnits      = 'mm';
AO.EPU.OffsetB.PhysicsUnits = 'mm';

AO.EPU.OffsetBControl.MemberOf = {'PlotFamily';};
AO.EPU.OffsetBControl.Mode = 'Simulator';
AO.EPU.OffsetBControl.DataType = 'Scalar';
AO.EPU.OffsetBControl.ChannelNames = getname_als('EPUOffsetBSP', AO.EPU.DeviceList, 1);
AO.EPU.OffsetBControl.HW2PhysicsParams = 1;
AO.EPU.OffsetBControl.Physics2HWParams = 1;
AO.EPU.OffsetBControl.Units        = 'Hardware';
AO.EPU.OffsetBControl.HWUnits      = 'mm';
AO.EPU.OffsetBControl.PhysicsUnits = 'mm';

AO.EPU.ZMode.MemberOf = {'PlotFamily';};
AO.EPU.ZMode.Mode = 'Simulator';
AO.EPU.ZMode.DataType = 'Scalar';
AO.EPU.ZMode.ChannelNames = getname_als('EPUZMode', AO.EPU.DeviceList, 1);
AO.EPU.ZMode.HW2PhysicsParams = 1;
AO.EPU.ZMode.Physics2HWParams = 1;
AO.EPU.ZMode.Units        = 'Hardware';
AO.EPU.ZMode.HWUnits      = 'mm';
AO.EPU.ZMode.PhysicsUnits = 'mm';

AO.EPU.RunFlag.MemberOf = {'PlotFamily'; 'Boolean Monitor'; 'RunFlag';};
AO.EPU.RunFlag.Mode = 'Simulator';
AO.EPU.RunFlag.DataType = 'Scalar';
AO.EPU.RunFlag.ChannelNames = getname_als('EPUrunflag', AO.EPU.DeviceList, 2);
AO.EPU.RunFlag.HW2PhysicsParams = 1;
AO.EPU.RunFlag.Physics2HWParams = 1;
AO.EPU.RunFlag.Units        = 'Hardware';
AO.EPU.RunFlag.HWUnits      = '';
AO.EPU.RunFlag.PhysicsUnits = '';

AO.EPU.Velocity.MemberOf = {'PlotFamily'; 'Monitor';};
AO.EPU.Velocity.Mode = 'Simulator';
AO.EPU.Velocity.DataType = 'Scalar';
AO.EPU.Velocity.ChannelNames = getname_als('EPUvel', AO.EPU.DeviceList, 0);
AO.EPU.Velocity.HW2PhysicsParams = 1;
AO.EPU.Velocity.Physics2HWParams = 1;
AO.EPU.Velocity.Units        = 'Hardware';
AO.EPU.Velocity.HWUnits      = 'mm/s';
AO.EPU.Velocity.PhysicsUnits = 'mm/s';

AO.EPU.VelocityControl.MemberOf = {'PlotFamily';};
AO.EPU.VelocityControl.Mode = 'Simulator';
AO.EPU.VelocityControl.DataType = 'Scalar';
AO.EPU.VelocityControl.ChannelNames = getname_als('EPUvelcontrol', AO.EPU.DeviceList, 1);
AO.EPU.VelocityControl.HW2PhysicsParams = 1;
AO.EPU.VelocityControl.Physics2HWParams = 1;
AO.EPU.VelocityControl.Units        = 'Hardware';
AO.EPU.VelocityControl.HWUnits      = 'mm/s';
AO.EPU.VelocityControl.PhysicsUnits = 'mm/s';

AO.EPU.MoveCount.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.EPU.MoveCount.Mode = 'Simulator';
AO.EPU.MoveCount.DataType = 'Scalar';
AO.EPU.MoveCount.ChannelNames = getname_als('EPUmovecount', AO.EPU.DeviceList, 2);
AO.EPU.MoveCount.HW2PhysicsParams = 1;
AO.EPU.MoveCount.Physics2HWParams = 1;
AO.EPU.MoveCount.Units        = 'Hardware';
AO.EPU.MoveCount.HWUnits      = '';
AO.EPU.MoveCount.PhysicsUnits = '';

% AO.EPU.UserGap.MemberOf = {'PlotFamily';};
% AO.EPU.UserGap.Mode = 'Simulator';
% AO.EPU.UserGap.DataType = 'Scalar';
% AO.EPU.UserGap.ChannelNames = getname_als('EPUUserGap', AO.EPU.DeviceList, 1);
% AO.EPU.UserGap.HW2PhysicsParams = 1;
% AO.EPU.UserGap.Physics2HWParams = 1;
% AO.EPU.UserGap.Units        = 'Hardware';
% AO.EPU.UserGap.HWUnits      = 'mm';
% AO.EPU.UserGap.PhysicsUnits = 'mm';

AO.EPU.UserGap.MemberOf = {'PlotFamily';};
AO.EPU.UserGap.Mode = 'Simulator';
AO.EPU.UserGap.DataType = 'Scalar';
AO.EPU.UserGap.ChannelNames = getname_als('EPUUserGapZ', AO.EPU.DeviceList, 1);
AO.EPU.UserGap.HW2PhysicsParams = 1;
AO.EPU.UserGap.Physics2HWParams = 1;
AO.EPU.UserGap.Units        = 'Hardware';
AO.EPU.UserGap.HWUnits      = 'mm';
AO.EPU.UserGap.PhysicsUnits = 'mm';

AO.EPU.FFTableHeader.MemberOf = {'PlotFamily'; 'Monitor';};
AO.EPU.FFTableHeader.Mode = 'Simulator';
AO.EPU.FFTableHeader.DataType = 'Scalar';
AO.EPU.FFTableHeader.ChannelNames = [
    'sr04:FFTblHdr_h  '
    'sr04u2:FFTblHdr_h'
    'sr06u2:FFTblHdr_h'
    'sr07u1:FFTblHdr_h'
    'sr07u2:FFTblHdr_h'
    'sr11u1:FFTblHdr_h'
    'sr11u2:FFTblHdr_h'
    ];
AO.EPU.FFTableHeader.HW2PhysicsParams = 1;
AO.EPU.FFTableHeader.Physics2HWParams = 1;
AO.EPU.FFTableHeader.Units        = '';
AO.EPU.FFTableHeader.HWUnits      = '';
AO.EPU.FFTableHeader.PhysicsUnits = '';

AO.EPU.Home.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.EPU.Home.Mode = 'Simulator';
AO.EPU.Home.DataType = 'Scalar';
AO.EPU.Home.ChannelNames = [
    'sr04u:Hor_mtr_done '
    'sr04u2:Hor_mtr_done'
    'sr06u2:Hor_mtr_done'
    'sr07u1:Hor_mtr_done'
    'sr07u2:Hor_mtr_done'
    'sr11u1:Hor_mtr_done'
    'sr11u2:Hor_mtr_done'
    ];
AO.EPU.Home.HW2PhysicsParams = 1;
AO.EPU.Home.Physics2HWParams = 1;
AO.EPU.Home.Units        = '';
AO.EPU.Home.HWUnits      = '';
AO.EPU.Home.PhysicsUnits = '';

AO.EPU.Amp.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.EPU.Amp.Mode = 'Simulator';
AO.EPU.Amp.DataType = 'Scalar';
AO.EPU.Amp.ChannelNames = getname_als('EPUAmp', AO.EPU.DeviceList);
AO.EPU.Amp.HW2PhysicsParams = 1;
AO.EPU.Amp.Physics2HWParams = 1;
AO.EPU.Amp.Units        = 'Hardware';
AO.EPU.Amp.HWUnits      = '';
AO.EPU.Amp.PhysicsUnits = '';

AO.EPU.AmpReset.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.EPU.AmpReset.Mode = 'Simulator';
AO.EPU.AmpReset.DataType = 'Scalar';
AO.EPU.AmpReset.ChannelNames = getname_als('EPUAmpReset', AO.EPU.DeviceList);
AO.EPU.AmpReset.HW2PhysicsParams = 1;
AO.EPU.AmpReset.Physics2HWParams = 1;
AO.EPU.AmpReset.Units        = 'Hardware';
AO.EPU.AmpReset.HWUnits      = '';
AO.EPU.AmpReset.PhysicsUnits = '';



AO.SQEPU.FamilyName = 'SQEPU';
AO.SQEPU.MemberOf   = {'SKEWQUAD'; 'Magnet'};
AO.SQEPU.DeviceList = [
    4 1;
    4 2;
    6 2;
    7 1;
    7 2;
    11 1;
    11 2];
AO.SQEPU.ElementList = local_dev2elem('SQEPU', AO.SQEPU.DeviceList);
AO.SQEPU.Status = ones(size(AO.SQEPU.DeviceList,1),1);

AO.SQEPU.BaseName = {
    'SR04U:Q1'
    'SR04U:Q2'
    'SR06U:Q2'
    'SR07U:Q1'
    'SR07U:Q2'
    'SR11U:Q1'
    'SR11U:Q2'
    };

AO.SQEPU.DeviceType = {
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
    'Caen SY3634'
};


AO.SQEPU.Monitor.MemberOf = {'PlotFamily'; 'Magnet'; 'Monitor'; 'Save';};
AO.SQEPU.Monitor.Mode = 'Simulator';
AO.SQEPU.Monitor.DataType = 'Scalar';
AO.SQEPU.Monitor.ChannelNames = getname_als(AO.SQEPU.FamilyName, AO.SQEPU.DeviceList, 0);
AO.SQEPU.Monitor.HW2PhysicsFcn = @amp2k;
AO.SQEPU.Monitor.Physics2HWFcn = @k2amp;
%AO.SQEPU.Monitor.HW2PhysicsParams = SQEPUfac;
%AO.SQEPU.Monitor.Physics2HWParams = 1./SQEPUfac;
AO.SQEPU.Monitor.Units        = 'Hardware';
AO.SQEPU.Monitor.HWUnits      = 'Ampere';
AO.SQEPU.Monitor.PhysicsUnits = '1/Meter^2';

AO.SQEPU.Setpoint.MemberOf = {'PlotFamily'; 'Magnet'; 'Setpoint'; 'Save';};
AO.SQEPU.Setpoint.Mode = 'Simulator';
AO.SQEPU.Setpoint.DataType = 'Scalar';
AO.SQEPU.Setpoint.ChannelNames = getname_als(AO.SQEPU.FamilyName, AO.SQEPU.DeviceList, 1);
AO.SQEPU.Setpoint.HW2PhysicsFcn = @amp2k;
AO.SQEPU.Setpoint.Physics2HWFcn = @k2amp;
%AO.SQEPU.Setpoint.HW2PhysicsParams = SQEPUfac;
%AO.SQEPU.Setpoint.Physics2HWParams = 1./SQEPUfac;
AO.SQEPU.Setpoint.Units        = 'Hardware';
AO.SQEPU.Setpoint.HWUnits      = 'Ampere';
AO.SQEPU.Setpoint.PhysicsUnits = '1/Meter^2';

AO.SQEPU.FF.MemberOf = {'PlotFamily'; 'Magnet'; 'FF'; 'Save';};
AO.SQEPU.FF.Mode = 'Simulator';
AO.SQEPU.FF.DataType = 'Scalar';
AO.SQEPU.FF.ChannelNames = getname_als('SQEPUFF', AO.SQEPU.DeviceList, 1);
AO.SQEPU.FF.HW2PhysicsFcn = @amp2k;
AO.SQEPU.FF.Physics2HWFcn = @k2amp;
AO.SQEPU.FF.Units        = 'Hardware';
AO.SQEPU.FF.HWUnits      = 'Ampere';
AO.SQEPU.FF.PhysicsUnits = '1/Meter^2';

AO.SQEPU.FFMultiplier.MemberOf = {'PlotFamily'; 'Magnet'; 'FFMultiplier'; 'Save';};
AO.SQEPU.FFMultiplier.Mode = 'Simulator';
AO.SQEPU.FFMultiplier.DataType = 'Scalar';
AO.SQEPU.FFMultiplier.ChannelNames = getname_als('SQEPUFFMultiplier', AO.SQEPU.DeviceList, 1);
AO.SQEPU.FFMultiplier.HW2PhysicsFcn = @amp2k;
AO.SQEPU.FFMultiplier.Physics2HWFcn = @k2amp;
AO.SQEPU.FFMultiplier.Units        = 'Hardware';
AO.SQEPU.FFMultiplier.HWUnits      = 'Ampere';
AO.SQEPU.FFMultiplier.PhysicsUnits = '1/Meter^2';

AO.SQEPU.Sum.MemberOf = {'PlotFamily'; 'Magnet'; 'Sum'; 'Save';};
AO.SQEPU.Sum.Mode = 'Simulator';
AO.SQEPU.Sum.DataType = 'Scalar';
AO.SQEPU.Sum.ChannelNames = getname_als('SQEPUFFSum', AO.SQEPU.DeviceList, 1);
AO.SQEPU.Sum.HW2PhysicsFcn = @amp2k;
AO.SQEPU.Sum.Physics2HWFcn = @k2amp;
AO.SQEPU.Sum.Units        = 'Hardware';
AO.SQEPU.Sum.HWUnits      = 'Ampere';
AO.SQEPU.Sum.PhysicsUnits = '1/Meter^2';

AO.SQEPU.RampRate.MemberOf = {'PlotFamily'; };
AO.SQEPU.RampRate.Mode = 'Simulator';
AO.SQEPU.RampRate.DataType = 'Scalar';
AO.SQEPU.RampRate.ChannelNames = getname_als('SQEPUramprate', AO.SQEPU.DeviceList, 1);
AO.SQEPU.RampRate.HW2PhysicsParams = 1;
AO.SQEPU.RampRate.Physics2HWParams = 1;
AO.SQEPU.RampRate.Units        = 'Hardware';
AO.SQEPU.RampRate.HWUnits      = 'Ampere/Second';
AO.SQEPU.RampRate.PhysicsUnits = 'Ampere/Second';

AO.SQEPU.TimeConstant.MemberOf = {'PlotFamily'; };
AO.SQEPU.TimeConstant.Mode = 'Simulator';
AO.SQEPU.TimeConstant.DataType = 'Scalar';
AO.SQEPU.TimeConstant.ChannelNames = getname_als('SQEPUtimeconstant', AO.SQEPU.DeviceList, 1);
AO.SQEPU.TimeConstant.HW2PhysicsParams = 1;
AO.SQEPU.TimeConstant.Physics2HWParams = 1;
AO.SQEPU.TimeConstant.Units        = 'Hardware';
AO.SQEPU.TimeConstant.HWUnits      = 'Second';
AO.SQEPU.TimeConstant.PhysicsUnits = 'Second';

AO.SQEPU.DAC.MemberOf = {'PlotFamily';};
AO.SQEPU.DAC.Mode = 'Simulator';
AO.SQEPU.DAC.DataType = 'Scalar';
AO.SQEPU.DAC.ChannelNames = getname_als('SQEPUdac', AO.SQEPU.DeviceList, 1);
AO.SQEPU.DAC.HW2PhysicsParams = 1;
AO.SQEPU.DAC.Physics2HWParams = 1;
AO.SQEPU.DAC.Units        = 'Hardware';
AO.SQEPU.DAC.HWUnits      = 'Ampere';
AO.SQEPU.DAC.PhysicsUnits = 'Ampere';

AO.SQEPU.On.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SQEPU.On.Mode = 'Simulator';
AO.SQEPU.On.DataType = 'Scalar';
AO.SQEPU.On.ChannelNames = getname_als('SQEPUon', AO.SQEPU.DeviceList, 0);
AO.SQEPU.On.HW2PhysicsParams = 1;
AO.SQEPU.On.Physics2HWParams = 1;
AO.SQEPU.On.Units        = 'Hardware';
AO.SQEPU.On.HWUnits      = '';
AO.SQEPU.On.PhysicsUnits = '';

AO.SQEPU.OnControl.MemberOf = {'PlotFamily'; 'Boolean Control';};
AO.SQEPU.OnControl.Mode = 'Simulator';
AO.SQEPU.OnControl.DataType = 'Scalar';
AO.SQEPU.OnControl.ChannelNames = getname_als('SQEPUon', AO.SQEPU.DeviceList, 1);
AO.SQEPU.OnControl.HW2PhysicsParams = 1;
AO.SQEPU.OnControl.Physics2HWParams = 1;
AO.SQEPU.OnControl.Units        = 'Hardware';
AO.SQEPU.OnControl.HWUnits      = '';
AO.SQEPU.OnControl.PhysicsUnits = '';

% AO.SQEPU.Reset.MemberOf = {'PlotFamily'; 'Boolean Control';};
% AO.SQEPU.Reset.Mode = 'Simulator';
% AO.SQEPU.Reset.DataType = 'Scalar';
% AO.SQEPU.Reset.ChannelNames = getname_als('SQEPUreset', AO.SQEPU.DeviceList, 1);
% AO.SQEPU.Reset.HW2PhysicsParams = 1;
% AO.SQEPU.Reset.Physics2HWParams = 1;
% AO.SQEPU.Reset.Units        = 'Hardware';
% AO.SQEPU.Reset.HWUnits      = '';
% AO.SQEPU.Reset.PhysicsUnits = '';

AO.SQEPU.Ready.MemberOf = {'PlotFamily'; 'Boolean Monitor';};
AO.SQEPU.Ready.Mode = 'Simulator';
AO.SQEPU.Ready.DataType = 'Scalar';
AO.SQEPU.Ready.ChannelNames = getname_als('SQEPUready', AO.SQEPU.DeviceList, 0);
AO.SQEPU.Ready.HW2PhysicsParams = 1;
AO.SQEPU.Ready.Physics2HWParams = 1;
AO.SQEPU.Ready.Units        = 'Hardware';
AO.SQEPU.Ready.HWUnits      = '';
AO.SQEPU.Ready.PhysicsUnits = '';

AO.SQEPU.Offset = zeros(size(AO.SQEPU.DeviceList,1),1);


%%%%%%%%%%%%
% Scrapers %
%%%%%%%%%%%%

% Scraper names from Rick Steele
% 1. DeviceList
% 2. T/B/R/L
% 3. positive limit
% 4. negative limit
% 5. home_status
% 6. moving status
% 7. readback value
% 8. home command
% 9. move to position command


% Other fields: .ACCL, .REP (encoder), .STOP,

TopNames    = getnames_scrapers('SR','top');
BottomNames = getnames_scrapers('SR','bottom');
RightNames  = getnames_scrapers('SR','right');

AO.TOPSCRAPER.FamilyName = 'TOPSCRAPER';
AO.TOPSCRAPER.MemberOf   = {'Scraper'; 'Top';};
AO.TOPSCRAPER.DeviceList = [1 1;2 1;2 6;3 1;12 6];
AO.TOPSCRAPER.ElementList = [1 2 3 4 5]';
AO.TOPSCRAPER.Status = ones(size(AO.TOPSCRAPER.DeviceList,1),1);
AO.TOPSCRAPER.Position = [];
AO.TOPSCRAPER.CommonNames = [
    'JH(1,1) '
    'JH(2,1) '
    'JH(2,6) '
    'SR3T    '
    'JH(12,6)'
    ];

AO.TOPSCRAPER.Monitor.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Monitor'; 'Save';};
AO.TOPSCRAPER.Monitor.Mode = 'Simulator';
AO.TOPSCRAPER.Monitor.DataType = 'Scalar';
%AO.TOPSCRAPER.Monitor.ChannelNames = getname_als(AO.TOPSCRAPER.FamilyName, AO.TOPSCRAPER.DeviceList, 0);
AO.TOPSCRAPER.Monitor.ChannelNames = deblank(TopNames{7});
AO.TOPSCRAPER.Monitor.HW2PhysicsParams = 1;
AO.TOPSCRAPER.Monitor.Physics2HWParams = 1;
AO.TOPSCRAPER.Monitor.Units        = 'Hardware';
AO.TOPSCRAPER.Monitor.HWUnits      = 'mm';
AO.TOPSCRAPER.Monitor.PhysicsUnits = 'mm';

AO.TOPSCRAPER.Setpoint.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Setpoint'; 'Save/Restore';};
AO.TOPSCRAPER.Setpoint.Mode = 'Simulator';
AO.TOPSCRAPER.Setpoint.DataType = 'Scalar';
%AO.TOPSCRAPER.Setpoint.ChannelNames = getname_als(AO.TOPSCRAPER.FamilyName, AO.TOPSCRAPER.DeviceList, 1);
AO.TOPSCRAPER.Setpoint.ChannelNames = deblank(TopNames{9});
AO.TOPSCRAPER.Setpoint.HW2PhysicsParams = 1;
AO.TOPSCRAPER.Setpoint.Physics2HWParams = 1;
AO.TOPSCRAPER.Setpoint.Units        = 'Hardware';
AO.TOPSCRAPER.Setpoint.HWUnits      = 'mm';
AO.TOPSCRAPER.Setpoint.PhysicsUnits = 'mm';
AO.TOPSCRAPER.Setpoint.Range        = [local_minsp(AO.TOPSCRAPER.FamilyName,AO.TOPSCRAPER.DeviceList) local_maxsp(AO.TOPSCRAPER.FamilyName,AO.TOPSCRAPER.DeviceList)];
AO.TOPSCRAPER.Setpoint.Tolerance    = gettol(AO.TOPSCRAPER.FamilyName) * ones(length(AO.TOPSCRAPER.ElementList),1);

AO.TOPSCRAPER.Velocity.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Monitor'; 'Velocity';};
AO.TOPSCRAPER.Velocity.Mode = 'Simulator';
AO.TOPSCRAPER.Velocity.DataType = 'Scalar';
AO.TOPSCRAPER.Velocity.ChannelNames = strcat(deblank(TopNames{9}), '.VELO');
AO.TOPSCRAPER.Velocity.HW2PhysicsParams = 1;
AO.TOPSCRAPER.Velocity.Physics2HWParams = 1;
AO.TOPSCRAPER.Velocity.Units        = 'Hardware';
AO.TOPSCRAPER.Velocity.HWUnits      = 'mm/sec';
AO.TOPSCRAPER.Velocity.PhysicsUnits = 'mm/sec';

AO.TOPSCRAPER.RunFlag.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Boolean Monitor'; 'RunFlag';};
AO.TOPSCRAPER.RunFlag.Mode = 'Simulator';
AO.TOPSCRAPER.RunFlag.DataType = 'Scalar';
AO.TOPSCRAPER.RunFlag.ChannelNames = deblank(TopNames{6});
AO.TOPSCRAPER.RunFlag.HW2PhysicsParams = 1;
AO.TOPSCRAPER.RunFlag.Physics2HWParams = 1;
AO.TOPSCRAPER.RunFlag.Units        = 'Hardware';
AO.TOPSCRAPER.RunFlag.HWUnits      = '';
AO.TOPSCRAPER.RunFlag.PhysicsUnits = '';

AO.TOPSCRAPER.HomeControl.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Boolean Control';};
AO.TOPSCRAPER.HomeControl.Mode = 'Simulator';
AO.TOPSCRAPER.HomeControl.DataType = 'Scalar';
AO.TOPSCRAPER.HomeControl.ChannelNames = deblank(TopNames{8});
AO.TOPSCRAPER.HomeControl.HW2PhysicsParams = 1;
AO.TOPSCRAPER.HomeControl.Physics2HWParams = 1;
AO.TOPSCRAPER.HomeControl.Units        = 'Hardware';
AO.TOPSCRAPER.HomeControl.HWUnits      = '';
AO.TOPSCRAPER.HomeControl.PhysicsUnits = '';
AO.TOPSCRAPER.HomeControl.Range = [0 1];
AO.TOPSCRAPER.HomeControl.Tolerance = 0;

AO.TOPSCRAPER.Home.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Boolean Monitor';};
AO.TOPSCRAPER.Home.Mode = 'Simulator';
AO.TOPSCRAPER.Home.DataType = 'Scalar';
AO.TOPSCRAPER.Home.ChannelNames = deblank(TopNames{5});
AO.TOPSCRAPER.Home.HW2PhysicsParams = 1;
AO.TOPSCRAPER.Home.Physics2HWParams = 1;
AO.TOPSCRAPER.Home.Units        = 'Hardware';
AO.TOPSCRAPER.Home.HWUnits      = '';
AO.TOPSCRAPER.Home.PhysicsUnits = '';

AO.TOPSCRAPER.PositiveLimit.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Boolean Monitor';};
AO.TOPSCRAPER.PositiveLimit.Mode = 'Simulator';
AO.TOPSCRAPER.PositiveLimit.DataType = 'Scalar';
AO.TOPSCRAPER.PositiveLimit.ChannelNames = deblank(TopNames{3});
AO.TOPSCRAPER.PositiveLimit.HW2PhysicsParams = 1;
AO.TOPSCRAPER.PositiveLimit.Physics2HWParams = 1;
AO.TOPSCRAPER.PositiveLimit.Units        = 'Hardware';
AO.TOPSCRAPER.PositiveLimit.HWUnits      = '';
AO.TOPSCRAPER.PositiveLimit.PhysicsUnits = '';

AO.TOPSCRAPER.NegativeLimit.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Boolean Monitor';};
AO.TOPSCRAPER.NegativeLimit.Mode = 'Simulator';
AO.TOPSCRAPER.NegativeLimit.DataType = 'Scalar';
AO.TOPSCRAPER.NegativeLimit.ChannelNames = deblank(TopNames{4});
AO.TOPSCRAPER.NegativeLimit.HW2PhysicsParams = 1;
AO.TOPSCRAPER.NegativeLimit.Physics2HWParams = 1;
AO.TOPSCRAPER.NegativeLimit.Units        = 'Hardware';
AO.TOPSCRAPER.NegativeLimit.HWUnits      = '';
AO.TOPSCRAPER.NegativeLimit.PhysicsUnits = '';


AO.BOTTOMSCRAPER.FamilyName = 'BOTTOMSCRAPER';
AO.BOTTOMSCRAPER.MemberOf   = {'Scraper'; 'Bottom';};
AO.BOTTOMSCRAPER.DeviceList = [1 1;2 1;3 1];
AO.BOTTOMSCRAPER.ElementList = [1 2 3]';
AO.BOTTOMSCRAPER.Status = ones(size(AO.BOTTOMSCRAPER.DeviceList,1),1);
AO.BOTTOMSCRAPER.Position = [];
AO.BOTTOMSCRAPER.CommonNames = [
    'JH(1,1)'
    'JH(2,1)'
    'SR3B   '
    ];

AO.BOTTOMSCRAPER.Monitor.MemberOf = {'Scraper'; 'Bottom'; 'PlotFamily'; 'Monitor'};
AO.BOTTOMSCRAPER.Monitor.Mode = 'Simulator';
AO.BOTTOMSCRAPER.Monitor.DataType = 'Scalar';
%AO.BOTTOMSCRAPER.Monitor.ChannelNames = getname_als(AO.BOTTOMSCRAPER.FamilyName, AO.BOTTOMSCRAPER.DeviceList, 0);
AO.BOTTOMSCRAPER.Monitor.ChannelNames = deblank(BottomNames{7});
AO.BOTTOMSCRAPER.Monitor.HW2PhysicsParams = 1;
AO.BOTTOMSCRAPER.Monitor.Physics2HWParams = 1;
AO.BOTTOMSCRAPER.Monitor.Units        = 'Hardware';
AO.BOTTOMSCRAPER.Monitor.HWUnits      = 'mm';
AO.BOTTOMSCRAPER.Monitor.PhysicsUnits = 'mm';

AO.BOTTOMSCRAPER.Setpoint.MemberOf = {'Scraper'; 'Bottom'; 'PlotFamily'; 'Setpoint'; 'Save/Restore'};
AO.BOTTOMSCRAPER.Setpoint.Mode = 'Simulator';
AO.BOTTOMSCRAPER.Setpoint.DataType = 'Scalar';
%AO.BOTTOMSCRAPER.Setpoint.ChannelNames = getname_als(AO.BOTTOMSCRAPER.FamilyName, AO.BOTTOMSCRAPER.DeviceList, 1);
AO.BOTTOMSCRAPER.Setpoint.ChannelNames = deblank(BottomNames{9});
AO.BOTTOMSCRAPER.Setpoint.HW2PhysicsParams = 1;
AO.BOTTOMSCRAPER.Setpoint.Physics2HWParams = 1;
AO.BOTTOMSCRAPER.Setpoint.Units        = 'Hardware';
AO.BOTTOMSCRAPER.Setpoint.HWUnits      = 'mm';
AO.BOTTOMSCRAPER.Setpoint.PhysicsUnits = 'mm';
AO.BOTTOMSCRAPER.Setpoint.Range        = [local_minsp(AO.BOTTOMSCRAPER.FamilyName,AO.BOTTOMSCRAPER.DeviceList) local_maxsp(AO.BOTTOMSCRAPER.FamilyName,AO.BOTTOMSCRAPER.DeviceList)];
AO.BOTTOMSCRAPER.Setpoint.Tolerance    = gettol(AO.BOTTOMSCRAPER.FamilyName) * ones(length(AO.BOTTOMSCRAPER.ElementList),1);

AO.BOTTOMSCRAPER.Velocity.MemberOf = {'Scraper'; 'Top'; 'PlotFamily'; 'Monitor'; 'Velocity';};
AO.BOTTOMSCRAPER.Velocity.Mode = 'Simulator';
AO.BOTTOMSCRAPER.Velocity.DataType = 'Scalar';
AO.BOTTOMSCRAPER.Velocity.ChannelNames = strcat(deblank(BottomNames{9}), '.VELO');
AO.BOTTOMSCRAPER.Velocity.HW2PhysicsParams = 1;
AO.BOTTOMSCRAPER.Velocity.Physics2HWParams = 1;
AO.BOTTOMSCRAPER.Velocity.Units        = 'Hardware';
AO.BOTTOMSCRAPER.Velocity.HWUnits      = 'mm/sec';
AO.BOTTOMSCRAPER.Velocity.PhysicsUnits = 'mm/sec';

AO.BOTTOMSCRAPER.RunFlag.MemberOf = {'Scraper'; 'Bottom'; 'PlotFamily'; 'Boolean Monitor'; 'RunFlag';};
AO.BOTTOMSCRAPER.RunFlag.Mode = 'Simulator';
AO.BOTTOMSCRAPER.RunFlag.DataType = 'Scalar';
AO.BOTTOMSCRAPER.RunFlag.ChannelNames = deblank(BottomNames{6});
AO.BOTTOMSCRAPER.RunFlag.HW2PhysicsParams = 1;
AO.BOTTOMSCRAPER.RunFlag.Physics2HWParams = 1;
AO.BOTTOMSCRAPER.RunFlag.Units        = 'Hardware';
AO.BOTTOMSCRAPER.RunFlag.HWUnits      = '';
AO.BOTTOMSCRAPER.RunFlag.PhysicsUnits = '';

AO.BOTTOMSCRAPER.HomeControl.MemberOf = {'Scraper'; 'Bottom'; 'PlotFamily'; 'Boolean Control';};
AO.BOTTOMSCRAPER.HomeControl.Mode = 'Simulator';
AO.BOTTOMSCRAPER.HomeControl.DataType = 'Scalar';
AO.BOTTOMSCRAPER.HomeControl.ChannelNames = deblank(BottomNames{8});
AO.BOTTOMSCRAPER.HomeControl.HW2PhysicsParams = 1;
AO.BOTTOMSCRAPER.HomeControl.Physics2HWParams = 1;
AO.BOTTOMSCRAPER.HomeControl.Units        = 'Hardware';
AO.BOTTOMSCRAPER.HomeControl.HWUnits      = '';
AO.BOTTOMSCRAPER.HomeControl.PhysicsUnits = '';
AO.BOTTOMSCRAPER.HomeControl.Range = [0 1];
AO.BOTTOMSCRAPER.HomeControl.Tolerance = 0;

AO.BOTTOMSCRAPER.Home.MemberOf = {'Scraper'; 'Bottom'; 'PlotFamily'; 'Boolean Monitor';};
AO.BOTTOMSCRAPER.Home.Mode = 'Simulator';
AO.BOTTOMSCRAPER.Home.DataType = 'Scalar';
AO.BOTTOMSCRAPER.Home.ChannelNames = deblank(BottomNames{5});
AO.BOTTOMSCRAPER.Home.HW2PhysicsParams = 1;
AO.BOTTOMSCRAPER.Home.Physics2HWParams = 1;
AO.BOTTOMSCRAPER.Home.Units        = 'Hardware';
AO.BOTTOMSCRAPER.Home.HWUnits      = '';
AO.BOTTOMSCRAPER.Home.PhysicsUnits = '';

AO.BOTTOMSCRAPER.PositiveLimit.MemberOf = {'Scraper'; 'Bottom'; 'PlotFamily'; 'Boolean Monitor';};
AO.BOTTOMSCRAPER.PositiveLimit.Mode = 'Simulator';
AO.BOTTOMSCRAPER.PositiveLimit.DataType = 'Scalar';
AO.BOTTOMSCRAPER.PositiveLimit.ChannelNames = deblank(BottomNames{3});
AO.BOTTOMSCRAPER.PositiveLimit.HW2PhysicsParams = 1;
AO.BOTTOMSCRAPER.PositiveLimit.Physics2HWParams = 1;
AO.BOTTOMSCRAPER.PositiveLimit.Units        = 'Hardware';
AO.BOTTOMSCRAPER.PositiveLimit.HWUnits      = '';
AO.BOTTOMSCRAPER.PositiveLimit.PhysicsUnits = '';

AO.BOTTOMSCRAPER.NegativeLimit.MemberOf = {'Scraper'; 'Bottom'; 'PlotFamily'; 'Boolean Monitor';};
AO.BOTTOMSCRAPER.NegativeLimit.Mode = 'Simulator';
AO.BOTTOMSCRAPER.NegativeLimit.DataType = 'Scalar';
AO.BOTTOMSCRAPER.NegativeLimit.ChannelNames = deblank(BottomNames{4});
AO.BOTTOMSCRAPER.NegativeLimit.HW2PhysicsParams = 1;
AO.BOTTOMSCRAPER.NegativeLimit.Physics2HWParams = 1;
AO.BOTTOMSCRAPER.NegativeLimit.Units        = 'Hardware';
AO.BOTTOMSCRAPER.NegativeLimit.HWUnits      = '';
AO.BOTTOMSCRAPER.NegativeLimit.PhysicsUnits = '';


AO.INSIDESCRAPER.FamilyName = 'INSIDESCRAPER';
AO.INSIDESCRAPER.MemberOf   = {'Scraper'; 'Right';};
AO.INSIDESCRAPER.DeviceList = [3 1];
AO.INSIDESCRAPER.ElementList = 1;
AO.INSIDESCRAPER.Status = 0 * ones(size(AO.INSIDESCRAPER.DeviceList,1),1);  % Horizontal scraper is broken !!!!!
AO.INSIDESCRAPER.Position = [];                                             % Removed from Save/Restore !!!!
AO.INSIDESCRAPER.CommonNames = 'SR3R';

AO.INSIDESCRAPER.Monitor.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Monitor'};
AO.INSIDESCRAPER.Monitor.Mode = 'Simulator';
AO.INSIDESCRAPER.Monitor.DataType = 'Scalar';
%AO.INSIDESCRAPER.Monitor.ChannelNames = getname_als(AO.INSIDESCRAPER.FamilyName, AO.INSIDESCRAPER.DeviceList, 0);
AO.INSIDESCRAPER.Monitor.ChannelNames = deblank(RightNames{7});
AO.INSIDESCRAPER.Monitor.HW2PhysicsParams = 1;
AO.INSIDESCRAPER.Monitor.Physics2HWParams = 1;
AO.INSIDESCRAPER.Monitor.Units        = 'Hardware';
AO.INSIDESCRAPER.Monitor.HWUnits      = 'mm';
AO.INSIDESCRAPER.Monitor.PhysicsUnits = 'mm';

AO.INSIDESCRAPER.Setpoint.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Setpoint';};  % Removed from 'Save/Restore'
AO.INSIDESCRAPER.Setpoint.Mode = 'Simulator';
AO.INSIDESCRAPER.Setpoint.DataType = 'Scalar';
%AO.INSIDESCRAPER.Setpoint.ChannelNames = getname_als(AO.INSIDESCRAPER.FamilyName, AO.INSIDESCRAPER.DeviceList, 1);
AO.INSIDESCRAPER.Setpoint.ChannelNames = deblank(RightNames{9});
AO.INSIDESCRAPER.Setpoint.HW2PhysicsParams = 1;
AO.INSIDESCRAPER.Setpoint.Physics2HWParams = 1;
AO.INSIDESCRAPER.Setpoint.Units        = 'Hardware';
AO.INSIDESCRAPER.Setpoint.HWUnits      = 'mm';
AO.INSIDESCRAPER.Setpoint.PhysicsUnits = 'mm';
AO.INSIDESCRAPER.Setpoint.Range        = [local_minsp(AO.INSIDESCRAPER.FamilyName,AO.INSIDESCRAPER.DeviceList) local_maxsp(AO.INSIDESCRAPER.FamilyName, AO.INSIDESCRAPER.DeviceList)];
AO.INSIDESCRAPER.Setpoint.Tolerance    = gettol(AO.INSIDESCRAPER.FamilyName) * ones(length(AO.INSIDESCRAPER.ElementList),1);

AO.INSIDESCRAPER.Velocity.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Monitor'; 'Velocity';};
AO.INSIDESCRAPER.Velocity.Mode = 'Simulator';
AO.INSIDESCRAPER.Velocity.DataType = 'Scalar';
AO.INSIDESCRAPER.Velocity.ChannelNames = strcat(deblank(RightNames{9}), '.VELO');
AO.INSIDESCRAPER.Velocity.HW2PhysicsParams = 1;
AO.INSIDESCRAPER.Velocity.Physics2HWParams = 1;
AO.INSIDESCRAPER.Velocity.Units        = 'Hardware';
AO.INSIDESCRAPER.Velocity.HWUnits      = 'mm/sec';
AO.INSIDESCRAPER.Velocity.PhysicsUnits = 'mm/sec';

AO.INSIDESCRAPER.RunFlag.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Monitor'; 'RunFlag';};
AO.INSIDESCRAPER.RunFlag.Mode = 'Simulator';
AO.INSIDESCRAPER.RunFlag.DataType = 'Scalar';
AO.INSIDESCRAPER.RunFlag.ChannelNames = deblank(RightNames{6});
AO.INSIDESCRAPER.RunFlag.HW2PhysicsParams = 1;
AO.INSIDESCRAPER.RunFlag.Physics2HWParams = 1;
AO.INSIDESCRAPER.RunFlag.Units        = 'Hardware';
AO.INSIDESCRAPER.RunFlag.HWUnits      = '';
AO.INSIDESCRAPER.RunFlag.PhysicsUnits = '';

AO.INSIDESCRAPER.HomeControl.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Control';};
AO.INSIDESCRAPER.HomeControl.Mode = 'Simulator';
AO.INSIDESCRAPER.HomeControl.DataType = 'Scalar';
AO.INSIDESCRAPER.HomeControl.ChannelNames = deblank(RightNames{8});
AO.INSIDESCRAPER.HomeControl.HW2PhysicsParams = 1;
AO.INSIDESCRAPER.HomeControl.Physics2HWParams = 1;
AO.INSIDESCRAPER.HomeControl.Units        = 'Hardware';
AO.INSIDESCRAPER.HomeControl.HWUnits      = '';
AO.INSIDESCRAPER.HomeControl.PhysicsUnits = '';
AO.INSIDESCRAPER.HomeControl.Range = [0 1];
AO.INSIDESCRAPER.HomeControl.Tolerance = 0;

AO.INSIDESCRAPER.Home.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Monitor';};
AO.INSIDESCRAPER.Home.Mode = 'Simulator';
AO.INSIDESCRAPER.Home.DataType = 'Scalar';
AO.INSIDESCRAPER.Home.ChannelNames = deblank(RightNames{5});
AO.INSIDESCRAPER.Home.HW2PhysicsParams = 1;
AO.INSIDESCRAPER.Home.Physics2HWParams = 1;
AO.INSIDESCRAPER.Home.Units        = 'Hardware';
AO.INSIDESCRAPER.Home.HWUnits      = '';
AO.INSIDESCRAPER.Home.PhysicsUnits = '';

AO.INSIDESCRAPER.PositiveLimit.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Monitor';};
AO.INSIDESCRAPER.PositiveLimit.Mode = 'Simulator';
AO.INSIDESCRAPER.PositiveLimit.DataType = 'Scalar';
AO.INSIDESCRAPER.PositiveLimit.ChannelNames = deblank(RightNames{3});
AO.INSIDESCRAPER.PositiveLimit.HW2PhysicsParams = 1;
AO.INSIDESCRAPER.PositiveLimit.Physics2HWParams = 1;
AO.INSIDESCRAPER.PositiveLimit.Units        = 'Hardware';
AO.INSIDESCRAPER.PositiveLimit.HWUnits      = '';
AO.INSIDESCRAPER.PositiveLimit.PhysicsUnits = '';

AO.INSIDESCRAPER.NegativeLimit.MemberOf = {'Scraper'; 'Right'; 'PlotFamily'; 'Boolean Monitor';};
AO.INSIDESCRAPER.NegativeLimit.Mode = 'Simulator';
AO.INSIDESCRAPER.NegativeLimit.DataType = 'Scalar';
AO.INSIDESCRAPER.NegativeLimit.ChannelNames = deblank(RightNames{4});
AO.INSIDESCRAPER.NegativeLimit.HW2PhysicsParams = 1;
AO.INSIDESCRAPER.NegativeLimit.Physics2HWParams = 1;
AO.INSIDESCRAPER.NegativeLimit.Units        = 'Hardware';
AO.INSIDESCRAPER.NegativeLimit.HWUnits      = '';
AO.INSIDESCRAPER.NegativeLimit.PhysicsUnits = '';


%%%%%%
% RF %
%%%%%%
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;

AO.RF.Monitor.MemberOf   = {'PlotFamily'; 'RF'; 'Monitor'};
AO.RF.Monitor.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = 'SR01C___FREQB__AM00';  %  SR03S___RFFREQ_AM00RF' - Use a real monitor but resolution is worse than noise and offset
%AO.RF.Monitor.ChannelNames = 'MOCounter:FREQUENCY';  % 2017-01-04 -> installed a new Keysight counter in LI09 (units Hz), use a special function to getrf_als which uses MHz
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units        = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.MemberOf   = {'Save'; 'RF'; 'Setpoint'};
AO.RF.Setpoint.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.ChannelNames = 'EG______HQMOFM_AC01';      %  User operation (small changes, ~5K) [Volts]
%AO.RF.Setpoint.ChannelNames = 'SR03S___RFFREQ_AC00RF';   %  ESG1000 - Remote synthesizer [MHz]
%AO.RF.Setpoint.ChannelNames = 'SR01C___FREQB__AM00';     %  HP [MHz]
AO.RF.Setpoint.HW2PhysicsParams = 1e6;
AO.RF.Setpoint.Physics2HWParams = 1/1e6;
AO.RF.Setpoint.Units        = 'Hardware';
AO.RF.Setpoint.HWUnits      = 'MHz';
AO.RF.Setpoint.PhysicsUnits = 'Hz';
AO.RF.Setpoint.Range = [498.5 500.5];
AO.RF.Setpoint.Tolerance = 1;
AO.RF.Setpoint.SpecialFunctionSet = @setrf_als;
AO.RF.Setpoint.SpecialFunctionGet = @getrf_als;

AO.RF.CavityTemperature1.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.CavityTemperature1.DataType = 'Scalar';
AO.RF.CavityTemperature1.ChannelNames = 'SR03S___C1TEMP_AM00';
AO.RF.CavityTemperature1.HW2PhysicsParams = 1;
AO.RF.CavityTemperature1.Physics2HWParams = 1;
AO.RF.CavityTemperature1.Units        = 'Hardware';
AO.RF.CavityTemperature1.HWUnits      = 'C';
AO.RF.CavityTemperature1.PhysicsUnits = 'C';

AO.RF.CavityTemperature1Control.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.CavityTemperature1Control.DataType = 'Scalar';
AO.RF.CavityTemperature1Control.ChannelNames = 'SR03S___C1TEMP_AC00';
AO.RF.CavityTemperature1Control.HW2PhysicsParams = 1;
AO.RF.CavityTemperature1Control.Physics2HWParams = 1;
AO.RF.CavityTemperature1Control.Units        = 'Hardware';
AO.RF.CavityTemperature1Control.HWUnits      = 'C';
AO.RF.CavityTemperature1Control.PhysicsUnits = 'C';

AO.RF.CavityTemperature2.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.CavityTemperature2.DataType = 'Scalar';
AO.RF.CavityTemperature2.ChannelNames = 'SR03S___C2TEMP_AM00';
AO.RF.CavityTemperature2.HW2PhysicsParams = 1;
AO.RF.CavityTemperature2.Physics2HWParams = 1;
AO.RF.CavityTemperature2.Units        = 'Hardware';
AO.RF.CavityTemperature2.HWUnits      = 'C';
AO.RF.CavityTemperature2.PhysicsUnits = 'C';

AO.RF.CavityTemperature2Control.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.CavityTemperature2Control.DataType = 'Scalar';
AO.RF.CavityTemperature2Control.ChannelNames = 'SR03S___C2TEMP_AC00';
AO.RF.CavityTemperature2Control.HW2PhysicsParams = 1;
AO.RF.CavityTemperature2Control.Physics2HWParams = 1;
AO.RF.CavityTemperature2Control.Units        = 'Hardware';
AO.RF.CavityTemperature2Control.HWUnits      = 'C';
AO.RF.CavityTemperature2Control.PhysicsUnits = 'C';

AO.RF.Power.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.Power.DataType = 'Scalar';
AO.RF.Power.ChannelNames = 'SR03S___RFAMP__AM01';
AO.RF.Power.HW2PhysicsParams = 1;
AO.RF.Power.Physics2HWParams = 1;
AO.RF.Power.Units        = 'Hardware';
AO.RF.Power.HWUnits      = 'MV';
AO.RF.Power.PhysicsUnits = 'MV';

AO.RF.PowerControl.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.RF.PowerControl.DataType = 'Scalar';
AO.RF.PowerControl.ChannelNames = 'SR03S___RFAMP__AC01';
AO.RF.PowerControl.HW2PhysicsParams = 1;
AO.RF.PowerControl.Physics2HWParams = 1;
AO.RF.PowerControl.Units        = 'Hardware';
AO.RF.PowerControl.HWUnits      = '';
AO.RF.PowerControl.PhysicsUnits = '';

% SR03S___RFPHSE_AC00
% SR03S___RFPHSE_AM00
% SR03S___RFPHLP_AC03
% SR03S___RFPHASAAM00
% SR03S___RFPHASBAM01


%%%%%%%%
% Tune %
%%%%%%%%
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf   = {'TUNE'};
AO.TUNE.Status = [1;1;0];
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];

AO.TUNE.Monitor.MemberOf   = {'TUNE'; 'Monitor'};
AO.TUNE.Monitor.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.TUNE.Monitor.DataType = 'Scalar';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units        = 'Hardware';
AO.TUNE.Monitor.HWUnits      = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_als';


%%%%%%%%
% DCCT %
%%%%%%%%
AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {'DCCT'; 'Beam Current';};
AO.DCCT.Status = 1;
AO.DCCT.DeviceList = [1 1];
AO.DCCT.ElementList = 1;

AO.DCCT.Monitor.MemberOf   = {'DCCT'; 'Beam Current'; 'Monitor'};
AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = 'cmm:beam_current';      % Fast but "noisy"
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units        = 'Hardware';
AO.DCCT.Monitor.HWUnits      = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';

AO.DCCT.LowPass.MemberOf   = {'DCCT'; 'Beam Current'; 'LowPass'};
AO.DCCT.LowPass.Mode = 'Simulator';
AO.DCCT.LowPass.DataType = 'Scalar';
AO.DCCT.LowPass.ChannelNames = 'SR05W___DCCT2__AM01';  % Fast but "noisy"
AO.DCCT.LowPass.SpecialFunctionGet = 'getdcct_als';    % 'SR05W___DCCT2__AM01' (from ___DCCTLP) - slow!
AO.DCCT.LowPass.HW2PhysicsParams = 1;
AO.DCCT.LowPass.Physics2HWParams = 1;
AO.DCCT.LowPass.Units        = 'Hardware';
AO.DCCT.LowPass.HWUnits      = 'mAmps';
AO.DCCT.LowPass.PhysicsUnits = 'mAmps';



%%%%%%%%%%%%%%
% Ion Gauges %
%%%%%%%%%%%%%%
AO.IonGauge.FamilyName = 'IonGauge';
AO.IonGauge.MemberOf   = {'IonGauge'; 'Pressure';};
AO.IonGauge.DeviceList = [
    1 1
    1 2
    1 3
    2 1
    2 2
    3 1
    3 2
    3 3
    4 1
    4 2
    4 3
    5 1
    5 2
    6 1
    6 2
    6 3
    7 1
    7 2
    8 1
    8 2
    9 1
    9 2
    10 1
    10 2
    11 1
    11 2
    11 3
    12 1
    12 2];
AO.IonGauge.ElementList = (1:size(AO.IonGauge.DeviceList,1))';
AO.IonGauge.Status = 1;

AO.IonGauge.Monitor.MemberOf = {'PlotFamily'; };
AO.IonGauge.Monitor.Mode = 'Simulator';
AO.IonGauge.Monitor.DataType = 'Scalar';
AO.IonGauge.Monitor.ChannelNames = [
    'SR01S___IG1____AM00'
    'SR01S___IG2____AM00'
    'SR01C___IG2____AM00'
    'SR02S___IG1____AM00'
    'SR02C___IG2____AM00'
    'SR03S___IG1____AM01'
    'SR03S___IG3____AM05'
    'SR03C___IG2____AM00'
    'SR04U___IG1____AM00'
    'SR04U___IG2____AM00'
    'SR04C___IG2____AM00'
    'SR05W___IG1____AM00'
    'SR05C___IG2____AM00'
    'SR06U___IG1____AM00'
    'SR06U___IG2____AM00'
    'SR06C___IG2____AM00'
    'SR07U___IG1____AM00'
    'SR07C___IG2____AM00'
    'SR08U___IG1____AM00'
    'SR08C___IG2____AM00'
    'SR09U___IG1____AM00'
    'SR09C___IG2____AM00'
    'SR10U___IG1____AM00'
    'SR10C___IG2____AM00'
    'SR11U___IG1____AM00'
    'SR11U___IG2____AM00'
    'SR11C___IG2____AM00'
    'SR12U___IG1____AM00'   % Change from AM02 to AM00 on 2017-06-04
    'SR12C___IG2____AM00'];
AO.IonGauge.Monitor.HW2PhysicsParams = 1;
AO.IonGauge.Monitor.Physics2HWParams = 1;
AO.IonGauge.Monitor.Units        = 'Hardware';
AO.IonGauge.Monitor.HWUnits      = 'Torr';
AO.IonGauge.Monitor.PhysicsUnits = 'Torr';

AO.IonPump.FamilyName = 'IonPump';
AO.IonPump.MemberOf   = {'IonPump';'Pressure'; 'PlotFamily'};
AO.IonPump.DeviceList = [];
AO.IonPump.ElementList = [];
AO.IonPump.Status = 1;

AO.IonPump.Monitor.MemberOf = {'PlotFamily'; };
AO.IonPump.Monitor.Mode = 'Simulator';
AO.IonPump.Monitor.DataType = 'Scalar';
n = 0;
for i=1:12
    for j = 1:6
        if i < 10
            string=['SR0',num2str(i),'C___IP',num2str(j),'____AM00'];
        else
            string=['SR',num2str(i),'C___IP',num2str(j),'____AM00'];
        end
        n = n + 1;
        AO.IonPump.DeviceList(n,:) = [i j];
        AO.IonPump.Monitor.ChannelNames(n,:) = string;
    end
end
AO.IonPump.ElementList = (1:size(AO.IonPump.DeviceList,1))';
AO.IonPump.Monitor.HW2PhysicsParams = 1;
AO.IonPump.Monitor.Physics2HWParams = 1;
AO.IonPump.Monitor.Units        = 'Hardware';
AO.IonPump.Monitor.HWUnits      = 'Torr';
AO.IonPump.Monitor.PhysicsUnits = 'Torr';


%%%%%%%%
% pBPM %
%%%%%%%%
% setpv('SR07C___PBPM2Y1AM00','SCAN','Passive') to disable record processing
% setpv('SR07C___PBPM2Y1AM00','SCAN','.1 second') or 9 to enable record processing
AO.pBPM.FamilyName = 'pBPM';
AO.pBPM.MemberOf   = {'pBPM'; 'Vertical';};
AO.pBPM.DeviceList = [7 2];
AO.pBPM.ElementList = 21;
AO.pBPM.Status = ones(size(AO.pBPM.DeviceList,1),1);

AO.pBPM.Monitor.MemberOf = {'PlotFamily'; 'pBPM'; 'Vertical'; 'measbpmresp'; 'Monitor';};
AO.pBPM.Monitor.Mode = 'Simulator';
AO.pBPM.Monitor.DataType = 'Scalar';
AO.pBPM.Monitor.ChannelNames = 'SR07C___PBPM2Y_AM00';
AO.pBPM.Monitor.HW2PhysicsParams = 1;
AO.pBPM.Monitor.Physics2HWParams = 1;
AO.pBPM.Monitor.Units        = 'Hardware';
AO.pBPM.Monitor.HWUnits      = 'mm';
AO.pBPM.Monitor.PhysicsUnits = 'mm';

AO.pBPM.Y1.Mode = 'Simulator';
AO.pBPM.Y1.DataType = 'Scalar';
AO.pBPM.Y1.ChannelNames = 'SR07C___PBPM2Y1AM00';
AO.pBPM.Y1.HW2PhysicsParams = 1;
AO.pBPM.Y1.Physics2HWParams = 1;
AO.pBPM.Y1.Units        = 'Hardware';
AO.pBPM.Y1.HWUnits      = 'mm';
AO.pBPM.Y1.PhysicsUnits = 'mm';

AO.pBPM.Y2.Mode = 'Simulator';
AO.pBPM.Y2.DataType = 'Scalar';
AO.pBPM.Y2.ChannelNames = 'SR07C___PBPM2Y2AM00';
AO.pBPM.Y2.HW2PhysicsParams = 1;
AO.pBPM.Y2.Physics2HWParams = 1;
AO.pBPM.Y2.Units        = 'Hardware';
AO.pBPM.Y2.HWUnits      = 'mm';
AO.pBPM.Y2.PhysicsUnits = 'mm';

% AO.pBPM.Gain.Mode = 'Simulator';
% AO.pBPM.Gain.DataType = 'Scalar';
% AO.pBPM.Gain.ChannelNames = 'Physics7';
% AO.pBPM.Gain.HW2PhysicsParams = 1;
% AO.pBPM.Gain.Physics2HWParams = 1;
% AO.pBPM.Gain.Units        = 'Hardware';
% AO.pBPM.Gain.HWUnits      = 'mm';
% AO.pBPM.Gain.PhysicsUnits = 'mm';

AO.pBPM.TopInside.Mode = 'Simulator';
AO.pBPM.TopInside.DataType = 'Scalar';
AO.pBPM.TopInside.ChannelNames = 'SR07C___PBPM2A_AM00';
AO.pBPM.TopInside.HW2PhysicsParams = 1;
AO.pBPM.TopInside.Physics2HWParams = 1;
AO.pBPM.TopInside.Units        = 'Hardware';
AO.pBPM.TopInside.HWUnits      = 'mm';
AO.pBPM.TopInside.PhysicsUnits = 'mm';

AO.pBPM.BottomInside.Mode = 'Simulator';
AO.pBPM.BottomInside.DataType = 'Scalar';
AO.pBPM.BottomInside.ChannelNames = 'SR07C___PBPM2C_AM00';
AO.pBPM.BottomInside.HW2PhysicsParams = 1;
AO.pBPM.BottomInside.Physics2HWParams = 1;
AO.pBPM.BottomInside.Units        = 'Hardware';
AO.pBPM.BottomInside.HWUnits      = 'mm';
AO.pBPM.BottomInside.PhysicsUnits = 'mm';

AO.pBPM.TopOutside.Mode = 'Simulator';
AO.pBPM.TopOutside.DataType = 'Scalar';
AO.pBPM.TopOutside.ChannelNames = 'SR07C___PBPM2B_AM00';
AO.pBPM.TopOutside.HW2PhysicsParams = 1;
AO.pBPM.TopOutside.Physics2HWParams = 1;
AO.pBPM.TopOutside.Units        = 'Hardware';
AO.pBPM.TopOutside.HWUnits      = 'mm';
AO.pBPM.TopOutside.PhysicsUnits = 'mm';

AO.pBPM.BottomOutside.Mode = 'Simulator';
AO.pBPM.BottomOutside.DataType = 'Scalar';
AO.pBPM.BottomOutside.ChannelNames = 'SR07C___PBPM2D_AM00';
AO.pBPM.BottomOutside.HW2PhysicsParams = 1;
AO.pBPM.BottomOutside.Physics2HWParams = 1;
AO.pBPM.BottomOutside.Units        = 'Hardware';
AO.pBPM.BottomOutside.HWUnits      = 'mm';
AO.pBPM.BottomOutside.PhysicsUnits = 'mm';

AO.pBPM.Wave1.Mode = 'Simulator';
AO.pBPM.Wave1.DataType = 'Scalar';
AO.pBPM.Wave1.ChannelNames = 'SR07C___PBPM2Y_WF00';
AO.pBPM.Wave1.HW2PhysicsParams = 1;
AO.pBPM.Wave1.Physics2HWParams = 1;
AO.pBPM.Wave1.Units        = 'Hardware';
AO.pBPM.Wave1.HWUnits      = 'mm';
AO.pBPM.Wave1.PhysicsUnits = 'mm';

AO.pBPM.Wave2.Mode = 'Simulator';
AO.pBPM.Wave2.DataType = 'Scalar';
AO.pBPM.Wave2.ChannelNames = 'SR07C___PBPM2Y_WF01';
AO.pBPM.Wave2.HW2PhysicsParams = 1;
AO.pBPM.Wave2.Physics2HWParams = 1;
AO.pBPM.Wave2.Units        = 'Hardware';
AO.pBPM.Wave2.HWUnits      = 'mm';
AO.pBPM.Wave2.PhysicsUnits = 'mm';

% Every 0.9217 seconds a new waveform will be ready (1024/1111)
AO.pBPM.ActiveWave.Mode = 'Simulator';
AO.pBPM.ActiveWave.DataType = 'Scalar';
AO.pBPM.ActiveWave.ChannelNames = 'SR07C___PBPM2Y_BM00';
AO.pBPM.ActiveWave.HW2PhysicsParams = 1;
AO.pBPM.ActiveWave.Physics2HWParams = 1;
AO.pBPM.ActiveWave.Units        = 'Hardware';
AO.pBPM.ActiveWave.HWUnits      = 'mm';
AO.pBPM.ActiveWave.PhysicsUnits = 'mm';


%%%%%%%
% TFB %
%%%%%%%
AO.TFB.FamilyName = 'TFB';
AO.TFB.MemberOf   = {'TFB';};
AO.TFB.DeviceList = [3 1;3 2;3 3;3 4;3 5;3 6;3 7;3 8;];
AO.TFB.ElementList = (1:size(AO.TFB.DeviceList,1))';
AO.TFB.Status = ones(size(AO.TFB.DeviceList,1),1);
AO.TFB.CommonNames = [
    'X1-Bias '
    'Y1-Bias '
    'X2-Bias '
    'Y2-Bias '
    'X1-ATTN '
    'X2-ATTN '
    'X1-DELAY'
    'X2-DELAY'
    ];

AO.TFB.Monitor.MemberOf = {'Monitor'};
AO.TFB.Monitor.Mode = 'Simulator';
AO.TFB.Monitor.DataType = 'Scalar';
AO.TFB.Monitor.ChannelNames = [
    'tbds:x1bias:Mon      '
    'tbds:y1bias:Mon      '
    'tbds:x2bias:Mon      '
    'tbds:y2bias:Mon      '
    'tbds:X:Atten:Merge   '
    'tbds:Y:Atten:Merge   '
    'tbds:cpdl_x_delay:Mon'
    'tbds:cpdl_y_delay:Mon'];
AO.TFB.Monitor.HW2PhysicsParams = 1;
AO.TFB.Monitor.Physics2HWParams = 1;
AO.TFB.Monitor.Units        = 'Hardware';
AO.TFB.Monitor.HWUnits      = '';
AO.TFB.Monitor.PhysicsUnits = '';

AO.TFB.Setpoint.MemberOf = {'Setpoint'};
AO.TFB.Setpoint.Mode = 'Simulator';
AO.TFB.Setpoint.DataType = 'Scalar';
AO.TFB.Setpoint.ChannelNames = [
    'tbds:x1bias:Ctrl      '
    'tbds:y1bias:Ctrl      '
    'tbds:x2bias:Ctrl      '
    'tbds:y2bias:Ctrl      '
    'tbds:X:Atten:Parse.A  '
    'tbds:Y:Atten:Parse.A  '
    'tbds:cpdl_x_delay:Ctrl'
    'tbds:cpdl_y_delay:Ctrl'];
AO.TFB.Setpoint.HW2PhysicsParams = 1;
AO.TFB.Setpoint.Physics2HWParams = 1;
AO.TFB.Setpoint.Units        = 'Hardware';
AO.TFB.Setpoint.HWUnits      = '';
AO.TFB.Setpoint.PhysicsUnits = '';
AO.TFB.Setpoint.Range = [
    -100 100
    -100 100
    -100 100
    -100 100
    0 50
    0 50
    0 100e-9
    0 100e-9
    ];        % I'm really not sure about these (GJP)

AO.TFB.OnControl.MemberOf = {'TFB'; 'Boolean Control';};
AO.TFB.OnControl.Mode = 'Simulator';
AO.TFB.OnControl.DataType = 'Scalar';
AO.TFB.OnControl.ChannelNames = [
    'tbds:X:LoopRem:Ctrl'
    'tbds:Y:LoopRem:Ctrl'
    '                   '
    '                   '
    '                   '
    '                   '
    '                   '
    '                   '
    ];
AO.TFB.OnControl.HW2PhysicsParams = 1;
AO.TFB.OnControl.Physics2HWParams = 1;
AO.TFB.OnControl.Units        = 'Hardware';
AO.TFB.OnControl.HWUnits      = '';
AO.TFB.OnControl.PhysicsUnits = '';
AO.TFB.OnControl.Range = [0 1];



%%%%%%%
% THC %
%%%%%%%
AO.THC.FamilyName = 'THC';
AO.THC.MemberOf   = {'THC'};
AO.THC.Status = [1; 1; 1];
AO.THC.DeviceList = [2 1;2 2; 2 3];
AO.THC.ElementList = [1; 2; 3];

AO.THC.Monitor.MemberOf   = {'THC'; 'Monitor'};
AO.THC.Monitor.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.THC.Monitor.DataType = 'Scalar';
AO.THC.Monitor.ChannelNames = [
    'SR02C___C1MPOS_AM00'
    'SR02C___C2MPOS_AM00'
    'SR02C___C3MPOS_AM00'
    ];
AO.THC.Monitor.HW2PhysicsParams = 1;
AO.THC.Monitor.Physics2HWParams = 1;
AO.THC.Monitor.Units        = 'Hardware';
AO.THC.Monitor.HWUnits       = 'KWatts';
AO.THC.Monitor.PhysicsUnits  = 'KWatts';

AO.THC.Setpoint.MemberOf   = {'THC'; 'Setpoint'};
AO.THC.Setpoint.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.THC.Setpoint.DataType = 'Scalar';
AO.THC.Setpoint.ChannelNames = [
    'SR02C___C1MPOS_AC00'
    'SR02C___C2MPOS_AC00'
    'SR02C___C3MPOS_AC00'
    ];
AO.THC.Setpoint.HW2PhysicsParams = 1;
AO.THC.Setpoint.Physics2HWParams = 1;
AO.THC.Setpoint.Units        = 'Hardware';
AO.THC.Setpoint.HWUnits      = 'KWatts';
AO.THC.Setpoint.PhysicsUnits = 'KWatts';
AO.THC.Setpoint.Range = [0 10];
AO.THC.Setpoint.Tolerance = .3;

AO.THC.Error.MemberOf   = {'THC'; 'Error'};
AO.THC.Error.Mode = 'Simulator';     % 'Online' 'Simulator', 'Manual' or 'Special'
AO.THC.Error.DataType = 'Scalar';
AO.THC.Error.ChannelNames = [
    'SR02C___C1MERR_AC00'
    'SR02C___C2MERR_AC00'
    'SR02C___C3MERR_AC00'
    ];
AO.THC.Error.HW2PhysicsParams = 1;
AO.THC.Error.Physics2HWParams = 1;
AO.THC.Error.Units        = 'Hardware';
AO.THC.Error.HWUnits      = 'KWatts';
AO.THC.Error.PhysicsUnits = 'KWatts';
AO.THC.Error.Range = [0 10];
AO.THC.Error.Tolerance = .3;

% Cavity1MainTunerLoopBCChannel = "SR02C___C1MLOP_BC00";
% Cavity2MainTunerLoopBCChannel = "SR02C___C2MLOP_BC00";
% Cavity3MainTunerLoopBCChannel = "SR02C___C3MLOP_BC00";



%%%%%%%%%%%%%%%
% Fast Kicker %
%%%%%%%%%%%%%%%
AO.Kicker.FamilyName = 'Kicker';
AO.Kicker.MemberOf   = {'Kicker';};
AO.Kicker.DeviceList = [2 1];
AO.Kicker.ElementList = 1;
AO.Kicker.Status = ones(size(AO.Kicker.DeviceList,1),1);

AO.Kicker.Monitor.MemberOf = {'Monitor'};
AO.Kicker.Monitor.Mode = 'Simulator';
AO.Kicker.Monitor.DataType = 'Scalar';
AO.Kicker.Monitor.ChannelNames = 'SR02S___CK_AMP_AM00';
AO.Kicker.Monitor.HW2PhysicsParams = 55e-6 / 750;  % 750 volts -> 55 urad (meassured)
AO.Kicker.Monitor.Physics2HWParams = 750 / 55e-6;  % 750 volts -> 55 urad (meassured)
AO.Kicker.Monitor.Units        = 'Hardware';
AO.Kicker.Monitor.HWUnits      = 'Volts';
AO.Kicker.Monitor.PhysicsUnits = 'Radians';

AO.Kicker.Setpoint.MemberOf = {'Setpoint'};
AO.Kicker.Setpoint.Mode = 'Simulator';
AO.Kicker.Setpoint.DataType = 'Scalar';
AO.Kicker.Setpoint.ChannelNames = 'SR02S___CK_AMP_AC00';
AO.Kicker.Setpoint.HW2PhysicsParams = 55e-6 / 750;  % 750 volts -> 55 urad (meassured)
AO.Kicker.Setpoint.Physics2HWParams = 750 / 55e-6;  % 750 volts -> 55 urad (meassured)
AO.Kicker.Setpoint.Units        = 'Hardware';
AO.Kicker.Setpoint.HWUnits      = 'Volts';
AO.Kicker.Setpoint.PhysicsUnits = 'Radians';
AO.Kicker.Setpoint.Range = [0 1000];

AO.Kicker.Ready.MemberOf = {'Kicker'; 'Boolean Monitor';};
AO.Kicker.Ready.Mode = 'Simulator';
AO.Kicker.Ready.DataType = 'Scalar';
AO.Kicker.Ready.ChannelNames = 'SR02S___CK_RDY_BM00';
AO.Kicker.Ready.HW2PhysicsParams = 1;
AO.Kicker.Ready.Physics2HWParams = 1;
AO.Kicker.Ready.Units        = 'Hardware';
AO.Kicker.Ready.HWUnits      = '';
AO.Kicker.Ready.PhysicsUnits = '';

% Should make this a special function that checks if the kicker turned on properly???
AO.Kicker.OnControl.MemberOf = {'Kicker';  'Boolean Control';};
AO.Kicker.OnControl.Mode = 'Simulator';
AO.Kicker.OnControl.DataType = 'Scalar';
AO.Kicker.OnControl.ChannelNames = 'SR02S___CK_ON__BC00';
AO.Kicker.OnControl.HW2PhysicsParams = 1;
AO.Kicker.OnControl.Physics2HWParams = 1;
AO.Kicker.OnControl.Units        = 'Hardware';
AO.Kicker.OnControl.HWUnits      = '';
AO.Kicker.OnControl.PhysicsUnits = '';

AO.Kicker.Interlock.MemberOf = {'Kicker'; 'Boolean Monitor';};
AO.Kicker.Interlock.Mode = 'Simulator';
AO.Kicker.Interlock.DataType = 'Scalar';
AO.Kicker.Interlock.ChannelNames = 'SR02S___CKINTLKBM00';
AO.Kicker.Interlock.HW2PhysicsParams = 1;
AO.Kicker.Interlock.Physics2HWParams = 1;
AO.Kicker.Interlock.Units        = 'Hardware';
AO.Kicker.Interlock.HWUnits      = '';
AO.Kicker.Interlock.PhysicsUnits = '';

AO.Kicker.OverTemperature.MemberOf = {'Kicker'; 'Boolean Monitor';};
AO.Kicker.OverTemperature.Mode = 'Simulator';
AO.Kicker.OverTemperature.DataType = 'Scalar';
AO.Kicker.OverTemperature.ChannelNames = 'SR02S___CKWATERBM00';
AO.Kicker.OverTemperature.HW2PhysicsParams = 1;
AO.Kicker.OverTemperature.Physics2HWParams = 1;
AO.Kicker.OverTemperature.Units        = 'Hardware';
AO.Kicker.OverTemperature.HWUnits      = '';
AO.Kicker.OverTemperature.PhysicsUnits = '';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEV - This is a soft family for energy ramping %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.GeV.FamilyName = 'GeV';
AO.GeV.MemberOf = {};
AO.GeV.Status = 1;
AO.GeV.DeviceList = [1 1];
AO.GeV.ElementList = 1;

AO.GeV.Monitor.MemberOf = {'GeV'};
AO.GeV.Monitor.Mode = 'Simulator';
AO.GeV.Monitor.DataType = 'Scalar';
AO.GeV.Monitor.SpecialFunctionGet = 'getenergy_als';  %'bend2gev';
AO.GeV.Monitor.HW2PhysicsParams = 1;
AO.GeV.Monitor.Physics2HWParams = 1;
AO.GeV.Monitor.Units        = 'Hardware';
AO.GeV.Monitor.HWUnits      = 'GeV';
AO.GeV.Monitor.PhysicsUnits = 'GeV';

AO.GeV.Setpoint.MemberOf = {'GeV'};
AO.GeV.Setpoint.Mode = 'Simulator';
AO.GeV.Setpoint.DataType = 'Scalar';
AO.GeV.Setpoint.HW2PhysicsParams = 1;
AO.GeV.Setpoint.Physics2HWParams = 1;
AO.GeV.Setpoint.Units        = 'Hardware';
AO.GeV.Setpoint.HWUnits      = 'GeV';
AO.GeV.Setpoint.PhysicsUnits = 'GeV';
AO.GeV.Setpoint.SpecialFunctionGet = @getenergy_als;
AO.GeV.Setpoint.SpecialFunctionSet = @setenergy_als;


%%%%%%%%%%%%%%%%%%%%
% Old BPM Families %
%%%%%%%%%%%%%%%%%%%%
AO.BPM96x.FamilyName = 'BPM96x';
AO.BPM96x.MemberOf   = {};
AO.BPM96x.DeviceList = BPMlist;
AO.BPM96x.ElementList = local_dev2elem('BPM96x', AO.BPM96x.DeviceList);
AO.BPM96x.Status = 1;

AO.BPM96x.Monitor.MemberOf = {};
AO.BPM96x.Monitor.Mode = 'Simulator';
AO.BPM96x.Monitor.DataType = 'Scalar';
AO.BPM96x.Monitor.ChannelNames = getname_als(AO.BPM96x.FamilyName, AO.BPM96x.DeviceList, 0);
AO.BPM96x.Monitor.HW2PhysicsParams = 1e-3;
AO.BPM96x.Monitor.Physics2HWParams = 1000;
AO.BPM96x.Monitor.Units        = 'Hardware';
AO.BPM96x.Monitor.HWUnits      = 'mm';
AO.BPM96x.Monitor.PhysicsUnits = 'Meter';

AO.BPM96y.FamilyName = 'BPM96y';
AO.BPM96y.MemberOf   = {};
AO.BPM96y.DeviceList = BPMlist;
AO.BPM96y.ElementList = local_dev2elem('BPM96y', AO.BPM96y.DeviceList);
AO.BPM96y.Status = 1;

AO.BPM96y.Monitor.MemberOf = {};
AO.BPM96y.Monitor.Mode = 'Simulator';
AO.BPM96y.Monitor.DataType = 'Scalar';
AO.BPM96y.Monitor.ChannelNames = getname_als(AO.BPM96y.FamilyName, AO.BPM96y.DeviceList, 0);
AO.BPM96y.Monitor.HW2PhysicsParams = 1e-3;
AO.BPM96y.Monitor.Physics2HWParams = 1000;
AO.BPM96y.Monitor.Units        = 'Hardware';
AO.BPM96y.Monitor.HWUnits          = 'mm';
AO.BPM96y.Monitor.PhysicsUnits     = 'Meter';


AO.IDBPMx.FamilyName = 'IDBPMx';
AO.IDBPMx.MemberOf   = {'IDBPM';};
AO.IDBPMx.DeviceList = [
    1 1;    1 2
    2 1;    2 2
    3 1;    3 2
    4 1;    4 3;    4 4;    4 2
    5 1;    5 2
    6 1;    6 3;    6 4;    6 2
    7 1;    7 3;    7 4;    7 2
    8 1;    8 2
    9 1;    9 2
    10 1;  10 2
    11 1;  11 3;   11 4;   11 2
    12 1;  12 2];
AO.IDBPMx.ElementList = local_dev2elem('IDBPMx', AO.IDBPMx.DeviceList);
AO.IDBPMx.Status = 1;

AO.IDBPMx.Monitor.MemberOf = {};
AO.IDBPMx.Monitor.Mode = 'Simulator';
AO.IDBPMx.Monitor.DataType = 'Scalar';
AO.IDBPMx.Monitor.ChannelNames = getname_als(AO.IDBPMx.FamilyName, AO.IDBPMx.DeviceList, 0);
AO.IDBPMx.Monitor.Units        = 'Hardware';
AO.IDBPMx.Monitor.HWUnits          = 'mm';
AO.IDBPMx.Monitor.PhysicsUnits     = 'Meter';
AO.IDBPMx.Monitor.HW2PhysicsParams = 1e-3;
AO.IDBPMx.Monitor.Physics2HWParams = 1000;

AO.IDBPMy.FamilyName = 'IDBPMy';
AO.IDBPMy.MemberOf   = {'IDBPM';};
AO.IDBPMy.DeviceList = AO.IDBPMx.DeviceList;
AO.IDBPMy.ElementList = local_dev2elem('IDBPMy', AO.IDBPMy.DeviceList);
AO.IDBPMy.Status = 1;

AO.IDBPMy.Monitor.MemberOf = {};
AO.IDBPMy.Monitor.Mode = 'Simulator';
AO.IDBPMy.Monitor.DataType = 'Scalar';
AO.IDBPMy.Monitor.ChannelNames = getname_als(AO.IDBPMy.FamilyName, AO.IDBPMy.DeviceList, 0);
AO.IDBPMy.Monitor.Units        = 'Hardware';
AO.IDBPMy.Monitor.HWUnits          = 'mm';
AO.IDBPMy.Monitor.PhysicsUnits     = 'Meter';
AO.IDBPMy.Monitor.HW2PhysicsParams = 1e-3;
AO.IDBPMy.Monitor.Physics2HWParams = 1000;

AO.BBPMx.MemberOf   = {'BBPM';};
AO.BBPMx.DeviceList = [
    1 4;   1 5;
    2 4;   2 5;
    3 4;   3 5;
    4 4;   4 5;
    5 4;   5 5;
    6 4;   6 5;
    7 4;   7 5;
    8 4;   8 5;
    9 4;   9 5;
    10 4; 10 5;
    11 4; 11 5;
    12 4; 12 5];
AO.BBPMx.ElementList = local_dev2elem('BBPMx', AO.BBPMx.DeviceList);
AO.BBPMx.Status = 1;

AO.BBPMx.FamilyName = 'BBPMx';
AO.BBPMx.Monitor.MemberOf = {};
AO.BBPMx.Monitor.Mode = 'Simulator';
AO.BBPMx.Monitor.DataType = 'Scalar';
AO.BBPMx.Monitor.ChannelNames = getname_als(AO.BBPMx.FamilyName, AO.BBPMx.DeviceList, 0);
AO.BBPMx.Monitor.Units        = 'Hardware';
AO.BBPMx.Monitor.HWUnits          = 'mm';
AO.BBPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BBPMx.Monitor.HW2PhysicsParams = 1e-3;
AO.BBPMx.Monitor.Physics2HWParams = 1000;

AO.BBPMy.FamilyName = 'BBPMy';
AO.BBPMy.MemberOf   = {'BBPM';};
AO.BBPMy.DeviceList = AO.BBPMx.DeviceList;
AO.BBPMy.ElementList = local_dev2elem('BBPMy', AO.BBPMy.DeviceList);
AO.BBPMy.Status = 1;

AO.BBPMy.Monitor.MemberOf = {};
AO.BBPMy.Monitor.Mode = 'Simulator';
AO.BBPMy.Monitor.DataType = 'Scalar';
AO.BBPMy.Monitor.ChannelNames = getname_als(AO.BBPMy.FamilyName, AO.BBPMy.DeviceList, 0);
AO.BBPMy.Monitor.HW2PhysicsParams = 1e-3;
AO.BBPMy.Monitor.Physics2HWParams = 1000;
AO.BBPMy.Monitor.Units        = 'Hardware';
AO.BBPMy.Monitor.HWUnits          = 'mm';
AO.BBPMy.Monitor.PhysicsUnits     = 'Meter';


% Save the AO so that family2dev will work
setao(AO);



%%%%%%%%%%%%%
% Get Range %
%%%%%%%%%%%%%
AO.HCM.Setpoint.Range = [local_minsp(AO.HCM.FamilyName, AO.HCM.DeviceList) local_maxsp(AO.HCM.FamilyName, AO.HCM.DeviceList)];
AO.HCM.OnControl.Range    = [0 1];
AO.HCM.Reset.Range        = [0 1];
AO.HCM.RampRate.Range     = [0 10000];
AO.HCM.FFMultiplier.Range = [0 1];
AO.HCM.TimeConstant.Range = [0 10000];

AO.VCM.Setpoint.Range = [local_minsp(AO.VCM.FamilyName, AO.VCM.DeviceList) local_maxsp(AO.VCM.FamilyName, AO.VCM.DeviceList)];
AO.VCM.OnControl.Range    = [0 1];
AO.VCM.Reset.Range        = [0 1];
AO.VCM.RampRate.Range     = [0 10000];
AO.VCM.FFMultiplier.Range = [0 1];
AO.VCM.TimeConstant.Range = [0 10000];

AO.HCM.OnControl.Range    = [0 1];
AO.HCM.Reset.Range        = [0 1];
AO.HCM.RampRate.Range     = [0 10000];
AO.HCM.FFMultiplier.Range = [0 1];
AO.HCM.TimeConstant.Range = [0 10000];

AO.VCMCHICANE.Setpoint.Range  = [local_minsp(AO.VCMCHICANE.FamilyName,  AO.VCMCHICANE.DeviceList)  local_maxsp(AO.VCMCHICANE.FamilyName, AO.VCMCHICANE.DeviceList)];
AO.HCMCHICANE.Setpoint.Range  = [local_minsp(AO.HCMCHICANE.FamilyName,  AO.HCMCHICANE.DeviceList)  local_maxsp(AO.HCMCHICANE.FamilyName, AO.HCMCHICANE.DeviceList)];
AO.HCMCHICANEM.Setpoint.Range = [local_minsp(AO.HCMCHICANEM.FamilyName, AO.HCMCHICANEM.DeviceList) local_maxsp(AO.HCMCHICANEM.FamilyName, AO.HCMCHICANEM.DeviceList)];

AO.QF.Setpoint.Range = [local_minsp(AO.QF.FamilyName) local_maxsp(AO.QF.FamilyName)];
AO.QF.OnControl.Range    = [0 1];
AO.QF.Reset.Range        = [0 1];
AO.QF.RampRate.Range     = [0 10000];
AO.QF.FFMultiplier.Range = [0 1];
AO.QF.TimeConstant.Range = [0 10000];

AO.QD.Setpoint.Range = [local_minsp(AO.QD.FamilyName) local_maxsp(AO.QD.FamilyName)];
AO.QD.OnControl.Range    = [0 1];
AO.QD.Reset.Range        = [0 1];
AO.QD.RampRate.Range     = [0 10000];
AO.QD.FFMultiplier.Range = [0 1];
AO.QD.TimeConstant.Range = [0 10000];

AO.SF.Setpoint.Range = [local_minsp(AO.SF.FamilyName) local_maxsp(AO.SF.FamilyName)];
AO.SF.OnControl.Range    = [0 1];
AO.SF.Reset.Range        = [0 1];
AO.SF.RampRate.Range     = [0 10000];
AO.SF.TimeConstant.Range = [0 10000];

AO.SD.Setpoint.Range = [local_minsp(AO.SD.FamilyName) local_maxsp(AO.SD.FamilyName)];
AO.SD.OnControl.Range    = [0 1];
AO.SD.Reset.Range        = [0 1];
AO.SD.RampRate.Range     = [0 10000];
AO.SD.TimeConstant.Range = [0 10000];

AO.SHF.Setpoint.Range = [
    100   100
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    90    90
    100   100];
AO.SHF.OnControl.Range    = [0 1];
AO.SHF.Reset.Range        = [0 1];
AO.SHF.RampRate.Range     = [0 10000];

AO.SHD.Setpoint.Range     = [0 105];
AO.SHD.OnControl.Range    = [0 1];
AO.SHD.Reset.Range        = [0 1];
AO.SHD.RampRate.Range     = [0 10000];

AO.QFA.Setpoint.Range = [local_minsp(AO.QFA.FamilyName) local_maxsp(AO.QFA.FamilyName)];
AO.QFA.OnControl.Range    = [0 1];
AO.QFA.Reset.Range        = [0 1];
AO.QFA.RampRate.Range     = [0 10000];
AO.QFA.TimeConstant.Range = [0 10000];

AO.QDA.Setpoint.Range = [local_minsp(AO.QDA.FamilyName) local_maxsp(AO.QDA.FamilyName)];
AO.QDA.OnControl.Range    = [0 1];
AO.QDA.Reset.Range        = [0 1];
AO.QDA.RampRate.Range     = [0 10000];
AO.QDA.TimeConstant.Range = [0 10000];

AO.SQSF.Setpoint.Range = [local_minsp(AO.SQSF.FamilyName, AO.SQSF.DeviceList) local_maxsp(AO.SQSF.FamilyName, AO.SQSF.DeviceList)];
AO.SQSF.OnControl.Range    = [0 1];
AO.SQSF.Reset.Range        = [0 1];
AO.SQSF.RampRate.Range     = [0 10000];
AO.SQSF.TimeConstant.Range = [0 10000];

AO.SQSD.Setpoint.Range = [local_minsp(AO.SQSD.FamilyName, AO.SQSD.DeviceList) local_maxsp(AO.SQSD.FamilyName, AO.SQSD.DeviceList)];
AO.SQSD.OnControl.Range    = [0 1];
AO.SQSD.Reset.Range        = [0 1];
AO.SQSD.RampRate.Range     = [0 10000];
AO.SQSD.TimeConstant.Range = [0 10000];

AO.BSC.Setpoint.Range = [local_minsp(AO.BSC.FamilyName) local_maxsp(AO.BSC.FamilyName)];
AO.BEND.Setpoint.Range = [local_minsp(AO.BEND.FamilyName) local_maxsp(AO.BEND.FamilyName)];
AO.BEND.OnControl.Range    = [0 1];
AO.BEND.Reset.Range        = [0 1];
AO.BEND.RampRate.Range     = [0 10000];
AO.BEND.TimeConstant.Range = [0 10000];

AO.VCBSC.Setpoint.Range = [local_minsp(AO.VCBSC.FamilyName) local_maxsp(AO.VCBSC.FamilyName)];
AO.VCBSC.OnControl.Range    = [0 1];
AO.VCBSC.Reset.Range        = [0 1];
AO.VCBSC.RampRate.Range     = [0 10000];
AO.VCBSC.TimeConstant.Range = [0 10000];

AO.ID.Setpoint.Range = [local_minsp(AO.ID.FamilyName) local_maxsp(AO.ID.FamilyName)];
AO.ID.FFEnableControl.Range    = [0 1];
AO.ID.GapEnableControl.Range   = [0 1];
AO.ID.VelocityProfile.Range    = [0 1];
AO.ID.VelocityControl.Range    = [0 3.33];

AO.EPU.Setpoint.Range = [local_minsp(AO.EPU.FamilyName) local_maxsp(AO.EPU.FamilyName)];
%AO.EPU.OffsetAControl.Range = [local_minsp(AO.EPU.FamilyName) local_maxsp(AO.EPU.FamilyName)];
% ETC.

AO.SQEPU.Setpoint.Range = [local_minsp(AO.SQEPU.FamilyName) local_maxsp(AO.SQEPU.FamilyName)];
AO.SQEPU.OnControl.Range    = [0 1];
AO.SQEPU.Reset.Range        = [0 1];
AO.SQEPU.RampRate.Range     = [0 10000];
AO.SQEPU.TimeConstant.Range = [0 10000];

% AO.EPU.OffsetAControl.Range = [local_minsp(AO.EPU.FamilyName) local_maxsp(AO.EPU.FamilyName)];
% AO.EPU.OffsetBControl.Range = [local_minsp(AO.EPU.FamilyName) local_maxsp(AO.EPU.FamilyName)];


%%%%%%%%%%%%%
% Tolerance %
%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance = gettol(AO.HCM.FamilyName) * ones(length(AO.HCM.ElementList),1);
i = findrowindex([3 10;5 10;10 10], AO.HCM.DeviceList);
AO.HCM.Setpoint.Tolerance(i) = .3;

AO.VCM.Setpoint.Tolerance = gettol(AO.VCM.FamilyName) * ones(length(AO.VCM.ElementList),1);
i = findrowindex([3 10;5 10;10 10], AO.VCM.DeviceList);
AO.VCM.Setpoint.Tolerance(i) = .3;

AO.HCMCHICANE.Setpoint.Tolerance = gettol(AO.HCMCHICANE.FamilyName) * ones(length(AO.HCMCHICANE.ElementList),1);
AO.VCMCHICANE.Setpoint.Tolerance = gettol(AO.VCMCHICANE.FamilyName) * ones(length(AO.VCMCHICANE.ElementList),1);
AO.HCMCHICANEM.Setpoint.Tolerance = gettol(AO.HCMCHICANEM.FamilyName) * ones(length(AO.HCMCHICANEM.ElementList),1);
AO.QF.Setpoint.Tolerance = gettol(AO.QF.FamilyName) * ones(length(AO.QF.ElementList),1);
AO.QD.Setpoint.Tolerance = gettol(AO.QD.FamilyName) * ones(length(AO.QD.ElementList),1);
AO.SF.Setpoint.Tolerance = gettol(AO.SF.FamilyName) * ones(length(AO.SF.ElementList),1);
AO.SD.Setpoint.Tolerance = gettol(AO.SD.FamilyName) * ones(length(AO.SD.ElementList),1);
AO.SHF.Setpoint.Tolerance = gettol(AO.SHF.FamilyName) * ones(length(AO.SHF.ElementList),1);
AO.SHD.Setpoint.Tolerance = gettol(AO.SHD.FamilyName) * ones(length(AO.SHD.ElementList),1);
AO.SQSHF.Setpoint.Tolerance = gettol(AO.SQSHF.FamilyName) * ones(length(AO.SQSHF.ElementList),1);
%AO.QFA.Setpoint.Tolerance = gettol(AO.QFA.FamilyName) * ones(length(AO.QFA.ElementList),1);
AO.QFA.Setpoint.Tolerance = gettol(AO.QFA.FamilyName);
AO.QDA.Setpoint.Tolerance = gettol(AO.QDA.FamilyName) * ones(length(AO.QDA.ElementList),1);
AO.SQSF.Setpoint.Tolerance = gettol(AO.SQSF.FamilyName) * ones(length(AO.SQSF.ElementList),1);
AO.SQSD.Setpoint.Tolerance = gettol(AO.SQSD.FamilyName) * ones(length(AO.SQSD.ElementList),1);
AO.BEND.Setpoint.Tolerance = gettol(AO.BEND.FamilyName) * ones(length(AO.BEND.ElementList),1);
AO.BSC.Setpoint.Tolerance = gettol(AO.BSC.FamilyName) * ones(length(AO.BSC.ElementList),1);
AO.VCBSC.Setpoint.Tolerance = gettol(AO.VCBSC.FamilyName) * ones(length(AO.VCBSC.ElementList),1);
AO.ID.Setpoint.Tolerance = gettol(AO.ID.FamilyName) * ones(length(AO.ID.ElementList),1);
AO.EPU.Setpoint.Tolerance = gettol(AO.EPU.FamilyName) * ones(length(AO.EPU.ElementList),1);
AO.SQEPU.Setpoint.Tolerance = gettol(AO.SQEPU.FamilyName) * ones(length(AO.SQEPU.ElementList),1);


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


% Special vertical orbit family to remove the effect of the cam-kicker
% AO.BPMyCam.DeviceList = AO.BPMy.DeviceList;
% AO.BPMyCam.ElementList = AO.BPMy.ElementList;
% AO.BPMyCam.Status = AO.BPMy.Status;
% AO.BPMyCam.Position = AO.BPMy.Position;
% AO.BPMyCam.Golden = AO.BPMy.Golden;
% %AO.BPMyCam.AT = AO.BPMy.AT;
% AO.BPMyCam.Offset = AO.BPMy.Offset;
% AO.BPMyCam.Gain = AO.BPMy.Gain;
% AO.BPMyCam.Roll = AO.BPMy.Roll;
% AO.BPMyCam.Crunch = AO.BPMy.Crunch;
% AO.BPMyCam.Monitor = AO.BPMy.Monitor;
% AO.BPMyCam.Monitor.MemberOf = {'PlotFamily'; 'Vertical'; 'Monitor';};
% AO.BPMyCam.Monitor.SpecialFunctionGet = @getykickremoved;


% Set response matrix kick size in hardware units
%AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', .15e-3 / 3, AO.HCM.DeviceList);
%AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', .15e-3 / 3, AO.VCM.DeviceList);

% 'NoEnergyScaling' because I don't want to force a BEND magnet read at this point
AO.HCM.Setpoint.DeltaRespMat = mm2amp('HCM', .5, AO.HCM.DeviceList, 'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat = mm2amp('VCM', .5, AO.VCM.DeviceList, 'NoEnergyScaling');

% % Reduce the chicane correctors
% i = findrowindex([3 10;5 10;10 10],AO.HCM.DeviceList);
% AO.HCM.Setpoint.DeltaRespMat(i) = .6 * AO.HCM.Setpoint.DeltaRespMat(i);
%
% i = findrowindex([3 10;5 10;10 10],AO.VCM.DeviceList);
% AO.VCM.Setpoint.DeltaRespMat(i) = .6 * AO.VCM.Setpoint.DeltaRespMat(i);

% Chicane trims (Note: min/max is only 20 amps!)
i = findrowindex([3 10;5 10;6 10;10 10], AO.HCM.DeviceList);
AO.HCM.Setpoint.DeltaRespMat(i) = 12;  % (or +-6)
i = findrowindex([3 10;5 10;6 10;10 10], AO.VCM.DeviceList);
AO.VCM.Setpoint.DeltaRespMat(i) = 12;  % (or +-6)


AO.HCMCHICANE.Setpoint.DeltaRespMat = 10 * ones(size(AO.HCMCHICANE.DeviceList,1),1);
AO.VCMCHICANE.Setpoint.DeltaRespMat = 10 * ones(size(AO.VCMCHICANE.DeviceList,1),1);

AO.QF.Setpoint.DeltaRespMat = .15;
AO.QD.Setpoint.DeltaRespMat = .1;

AO.SF.Setpoint.DeltaRespMat = 5;  % 10
AO.SD.Setpoint.DeltaRespMat = 5;  % 10;

AO.SQSF.Setpoint.DeltaRespMat = 2;
AO.SQSD.Setpoint.DeltaRespMat = 2;
AO.SQEPU.Setpoint.DeltaRespMat = 2;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get S-positions not see in updateatindex [meters] %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.BPM96x.Position = [
    3.2897    4.4513    6.0658    7.5886    8.8114   10.3342   11.8848   13.1103   19.6897   20.8513   22.4658   23.9886   25.2114 ...
    26.7342   28.2848   29.5103   36.0897   37.2513   38.8658   40.3886   41.6114   43.1342   44.6848   45.9103   52.4897   53.6513 ...
    55.2658   56.7888   58.0130   59.5360   61.0866   62.3121   68.8915   70.0531   71.6676   73.1904   74.4132   75.9360   77.4866 ...
    78.7121   85.2915   86.4531   88.0676   89.5904   90.8132   92.3360   93.8866   95.1121  101.6915  102.8531  104.4676  105.9904 ...
    107.2132  108.7360  110.2866  111.5121  118.0915  119.2531  120.8676  122.3906  123.6148  125.1378  126.6884  127.9139  134.4933 ...
    135.6549  137.2694  138.7922  140.0150  141.5378  143.0884  144.3139  150.8933  152.0549  153.6694  155.1922  156.4150  157.9378 ...
    159.4884  160.7139  167.2933  168.4549  170.0694  171.5922  172.8150  174.3378  175.8884  177.1139  183.6933  184.8549  186.4694 ...
    187.9924  189.2166  190.7396  192.2902  193.5157]';
AO.BPM96y.Position = AO.BPM96x.Position;

AO.BPM96x.AT.ATType = 'X';
AO.BPM96y.AT.ATType = 'Y';

for i = 1:length(AO.BPM96x.Position)
    [tmp,j] = min((AO.BPM96x.Position(i) - AO.BPMx.Position).^2);
    AO.BPM96x.AT.ATIndex(i,1) = AO.BPMx.AT.ATIndex(j);
    AO.BPM96y.AT.ATIndex(i,1) = AO.BPMy.AT.ATIndex(j);
end

% BPM
i = findrowindex(AO.BPM.DeviceList, AO.BPMx.DeviceList);
AO.BPM.Position = AO.BPMx.Position(i);

% IDBPMs  needs work???
Dev = getbpmlist('1 10 11 12');
Dev = [1 2;Dev;];
Dev = [Dev(1:3,:); [2 9;3 2]; Dev(3:end,:)];
i = findrowindex(Dev,AO.BPMx.DeviceList);
AO.IDBPMx.Position = AO.BPMx.Position(i);
AO.IDBPMy.Position = AO.BPMy.Position(i);

Dev = getbpmlist('5 6');
i = findrowindex(Dev,AO.BPMx.DeviceList);
AO.BBPMx.Position = AO.BPMx.Position(i);
AO.BBPMy.Position = AO.BPMy.Position(i);


% ID positions
% This probably needs refinement
L = getfamilydata('Circumference');
AO.ID.Position = (AO.ID.DeviceList(:,1)-1) * L/12;

% EPU positions
AO.EPU.Position(1,1) = getspos('BPMx',[ 3 10]) + (2.34504-.095)/2;  % [4 1]
AO.EPU.Position(2,1) = getspos('BPMx',[ 3 12]) + (2.29056-.095)/2;  % [4 2]  % Change Merlin, change INDEXs below!!
AO.EPU.Position(3,1) = getspos('BPMx',[ 5 12]) + (2.29056-.095)/2;  % [6 2]
AO.EPU.Position(4,1) = getspos('BPMx',[ 6 12]) + (2.34504-.103)/2;  % [7 1]
AO.EPU.Position(5,1) = getspos('BPMx',[ 6 10]) + (2.29056-.095)/2;  % [7 2]
AO.EPU.Position(6,1) = getspos('BPMx',[10 10]) + (2.34504-.103)/2;  % [11 1]
AO.EPU.Position(7,1) = getspos('BPMx',[10 12]) + (2.34504-.103)/2;  % [11 2]

% SQEPU positions
AO.SQEPU.Position(1,1) = getspos('BPMx',[ 3 10]) + (2.34504-.103)/2;  % [ 4 1] ???
AO.SQEPU.Position(2,1) = getspos('BPMx',[ 3 12]) + (2.34504-.103)/2;  % [ 4 2] ???
AO.SQEPU.Position(3,1) = getspos('BPMx',[ 5 12]) + (2.34504-.103)/2;  % [ 6 2]
AO.SQEPU.Position(4,1) = getspos('BPMx',[ 6 12]) + (2.34504-.103)/2;  % [ 7 2]
AO.SQEPU.Position(5,1) = getspos('BPMx',[10 10]) + (2.34504-.103)/2;  % [11 1]
AO.SQEPU.Position(6,1) = getspos('BPMx',[10 12]) + (2.34504-.103)/2;  % [11 2]

% SCRAPER positions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THESE ARE VERY ROUGH GUESSES AT THE MOMENT %      Tom change this one ----------------------------------------------------------------------------------v
AO.TOPSCRAPER.Position    = [getspos('BPMx',[1 3])+0.1; getspos('BPMx',[2 3])+0.1; getspos('BPMx',[2 8])+0.1; getspos('BPMx',[3 2])-0.2; getspos('BPMx',[12 6])+0.1;];
AO.BOTTOMSCRAPER.Position = [getspos('BPMx',[1 3])+0.1; getspos('BPMx',[2 3])+0.1; getspos('BPMx',[3 2])-0.2];
AO.INSIDESCRAPER.Position =  getspos('BPMx',[3 2])-0.2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update IDs that are EPUs
i = findrowindex(AO.EPU.DeviceList, AO.ID.DeviceList);
AO.ID.Position(i) = AO.EPU.Position;

% Sector 6 ID
i = findrowindex([6 1], AO.ID.DeviceList);
AO.ID.Position(i,1) = getspos('BPMx',[5 10]) + (2.34504-.103)/2;  % [6 1]
AO.ID.Position(i,1) = getspos('BPMx',[5 12]) + (2.29056-.103)/2;  % [6 2]


AO.IonGauge.Position = L * (AO.IonGauge.ElementList) / AO.IonGauge.ElementList(end);
AO.IonPump.Position  = L * (AO.IonPump.ElementList) / AO.IonPump.ElementList(end);

AO.GeV.Position = 0;
AO.DCCT.Position = 0;
AO.TUNE.Position = 0;
AO.pBPM.Position = 103.5;


%AO.SQSHF.Position = [0:23]*L/24; % ???


setao(AO);


%%%%%%%%%%%%%%%%
% Common Names %
%%%%%%%%%%%%%%%%

% Generate the common names before the swap
%Family = {'BPMx','BPMy','HCM','VCM','QF','QD','QFA','QDA','SQSF','SQSD','SF','SD','BEND','ID','EPU'};
%Family = {'HCM','VCM','QF','QD','QFA','QDA','SQSF','SQSD','SF','SD'};
Family = {'HCM','VCM'};
for i = 1:length(Family)
    % Remove the  '_'
    A = AO.(Family{i}).Monitor.ChannelNames(:,1:8);
    A(A=='_') = ' ';
    A = deblank(A);
    
    B = AO.(Family{i}).Monitor.ChannelNames(:,9:15);
    B(B=='_') = ' ';
    B = deblank(B);
    AO.(Family{i}).CommonNames = strcat(AO.(Family{i}).Monitor.ChannelNames(:,1:5), '^', B);
    
    AO.(Family{i}).CommonNames(AO.(Family{i}).CommonNames=='^') = ' ';
end

% Family = {'BEND'};
% % Remove the  '_'
% A = AO.BEND.Monitor.ChannelNames(:,1:8);
% A(A=='_') = ' ';
% A = deblank(A);
%
% B = AO.BEND.Monitor.ChannelNames(:,9:11);
% B(B=='_') = ' ';
% B = deblank(B);
% AO.BEND.CommonNames = strcat(AO.BEND.Monitor.ChannelNames(:,1:5), '^', B);
%
% AO.BEND.CommonNames(AO.BEND.CommonNames=='^') = ' ';

setao(AO);



% Power supply swaps
Family1     = {      'SQSF',           'SQSD'};
DeviceList1 = {[5 1; 5 2; 6 1; 7 1], [5 1; 5 2]};

Family2     = {       'HCM',           'HCM'};
DeviceList2 = {[5 4; 5 5; 6 4; 7 4], [5 3; 5 6]};


for i = 1:length(Family1)
    for j = 1:size(DeviceList1{i},1)
        
        k = findrowindex(DeviceList1{i}(j,:), AO.(Family1{i}).DeviceList);
        l = findrowindex(DeviceList2{i}(j,:), AO.(Family2{i}).DeviceList);
        
        % BaseName
        Name1 = AO.(Family1{i}).BaseName{k};
        Name2 = AO.(Family2{i}).BaseName{l};
        AO.(Family1{i}).BaseName{k,1} = Name2;
        AO.(Family2{i}).BaseName{l,1} = Name1;
        
        % DeviceType
        Name1 = AO.(Family1{i}).DeviceType{k};
        Name2 = AO.(Family2{i}).DeviceType{l};
        AO.(Family1{i}).DeviceType{k,1} = Name2;
        AO.(Family2{i}).DeviceType{l,1} = Name1;
        
        % Setpoint
        Name1 = AO.(Family1{i}).Setpoint.ChannelNames(k,:);
        Name2 = AO.(Family2{i}).Setpoint.ChannelNames(l,:);
        AO.(Family1{i}).Setpoint.ChannelNames(k,:) = Name2;
        AO.(Family2{i}).Setpoint.ChannelNames(l,:) = Name1;
        
        % Monitor
        Name1 = AO.(Family1{i}).Monitor.ChannelNames(k,:);
        Name2 = AO.(Family2{i}).Monitor.ChannelNames(l,:);
        AO.(Family1{i}).Monitor.ChannelNames(k,:) = Name2;
        AO.(Family2{i}).Monitor.ChannelNames(l,:) = Name1;
        
        % OnControl
        Name1 = AO.(Family1{i}).OnControl.ChannelNames(k,:);
        Name2 = AO.(Family2{i}).OnControl.ChannelNames(l,:);
        AO.(Family1{i}).OnControl.ChannelNames(k,:) = Name2;
        AO.(Family2{i}).OnControl.ChannelNames(l,:) = Name1;
        
        % On
        Name1 = AO.(Family1{i}).On.ChannelNames(k,:);
        Name2 = AO.(Family2{i}).On.ChannelNames(l,:);
        AO.(Family1{i}).On.ChannelNames(k,:) = Name2;
        AO.(Family2{i}).On.ChannelNames(l,:) = Name1;
        
        % RampRate
        Name1 = AO.(Family1{i}).RampRate.ChannelNames(k,:);
        Name2 = AO.(Family2{i}).RampRate.ChannelNames(l,:);
        AO.(Family1{i}).RampRate.ChannelNames(k,:) = Name2;
        AO.(Family2{i}).RampRate.ChannelNames(l,:) = Name1;
        
        % TimeConstant
        Name1 = AO.(Family1{i}).TimeConstant.ChannelNames(k,:);
        Name2 = AO.(Family2{i}).TimeConstant.ChannelNames(l,:);
        AO.(Family1{i}).TimeConstant.ChannelNames(k,:) = Name2;
        AO.(Family2{i}).TimeConstant.ChannelNames(l,:) = Name1;
        
%         % DAC
%         Name1 = AO.(Family1{i}).DAC.ChannelNames(k,:);
%         Name2 = AO.(Family2{i}).DAC.ChannelNames(l,:);
%         AO.(Family1{i}).DAC.ChannelNames(k,:) = Name2;
%         AO.(Family2{i}).DAC.ChannelNames(l,:) = Name1;
        
        %         % Reset (skew quads do not resets)
        %         Name1 = AO.(Family1{i}).Reset.ChannelNames(k,:);
        %         Name2 = AO.(Family2{i}).Reset.ChannelNames(l,:);
        %         AO.(Family1{i}).Reset.ChannelNames(k,:) = Name2;
        %         AO.(Family2{i}).Reset.ChannelNames(l,:) = Name1;
        
        % Ready
        Name1 = AO.(Family1{i}).Ready.ChannelNames(k,:);
        Name2 = AO.(Family2{i}).Ready.ChannelNames(l,:);
        AO.(Family1{i}).Ready.ChannelNames(k,:) = Name2;
        AO.(Family2{i}).Ready.ChannelNames(l,:) = Name1;
        
        % Reset
        Name1 = AO.(Family1{i}).Reset.ChannelNames(k,:);
        Name2 = AO.(Family2{i}).Reset.ChannelNames(l,:);
        AO.(Family1{i}).Reset.ChannelNames(k,:) = Name2;
        AO.(Family2{i}).Reset.ChannelNames(l,:) = Name1;
        
        % Tolerance
        Value1 = AO.(Family1{i}).Setpoint.Tolerance(k,:);
        Value2 = AO.(Family2{i}).Setpoint.Tolerance(l,:);
        AO.(Family1{i}).Setpoint.Tolerance(k,:) = Value2;
        AO.(Family2{i}).Setpoint.Tolerance(l,:) = Value1;
        
        % Range
        Value1 = AO.(Family1{i}).Setpoint.Range(k,:);
        Value2 = AO.(Family2{i}).Setpoint.Range(l,:);
        AO.(Family1{i}).Setpoint.Range(k,:) = Value2;
        AO.(Family2{i}).Setpoint.Range(l,:) = Value1;
        
    end
end


% Turn off (Status=0) the HCMs that do not have power supplies
DeviceList2 = {[5 4; 6 4]};
i = findrowindex(DeviceList2{1}, AO.HCM.DeviceList);
AO.HCM.Status(i) = 0;

setao(AO);



% % Response matrix kick size must be in hardware units.
% % Since they were set in physics units, they must be converted.
% % Note #1: The AO must be setup for the BEND family for physics2hw to work
% % Note #2: This is being done in simulate mode so that the BEND will not be
% %          accessed to get the energy.  This can be problem when the BEND is
% %          not online or not at the proper setpoint
% ModeBEND = getmode('BEND', 'Setpoint');
% setfamilydata('Simulator', 'BEND', 'Monitor', 'Mode');
% setfamilydata('Simulator', 'BEND', 'Setpoint', 'Mode');
% AO = getao;
% AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', AO.HCM.Setpoint.DeltaRespMat, AO.HCM.DeviceList);
% AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', AO.VCM.Setpoint.DeltaRespMat, AO.VCM.DeviceList);
% AO.VCM.Setpoint.PhotResp     = physics2hw('VCM','Setpoint', AO.VCM.Setpoint.PhotResp,     AO.VCM.DeviceList);
% AO.QF.Setpoint.DeltaRespMat  = physics2hw('QF', 'Setpoint', AO.QF.Setpoint.DeltaRespMat,  AO.QF.DeviceList);
% AO.QD.Setpoint.DeltaRespMat  = physics2hw('QD', 'Setpoint', AO.QD.Setpoint.DeltaRespMat,  AO.QD.DeviceList);
% AO.QFC.Setpoint.DeltaRespMat = physics2hw('QFC','Setpoint', AO.QFC.Setpoint.DeltaRespMat, AO.QFC.DeviceList);
% AO.QFX.Setpoint.DeltaRespMat = physics2hw('QFX','Setpoint', AO.QFX.Setpoint.DeltaRespMat, AO.QFX.DeviceList);
% AO.QFY.Setpoint.DeltaRespMat = physics2hw('QFY','Setpoint', AO.QFY.Setpoint.DeltaRespMat, AO.QFY.DeviceList);
% AO.QFZ.Setpoint.DeltaRespMat = physics2hw('QFZ','Setpoint', AO.QFZ.Setpoint.DeltaRespMat, AO.QFZ.DeviceList);
% AO.QDX.Setpoint.DeltaRespMat = physics2hw('QDX','Setpoint', AO.QDX.Setpoint.DeltaRespMat, AO.QDX.DeviceList);
% AO.QDY.Setpoint.DeltaRespMat = physics2hw('QDY','Setpoint', AO.QDY.Setpoint.DeltaRespMat, AO.QDY.DeviceList);
% AO.QDZ.Setpoint.DeltaRespMat = physics2hw('QDZ','Setpoint', AO.QDZ.Setpoint.DeltaRespMat, AO.QDZ.DeviceList);
% AO.SF.Setpoint.DeltaRespMat  = physics2hw('SF', 'Setpoint', AO.SF.Setpoint.DeltaRespMat,  AO.SF.DeviceList);
% AO.SD.Setpoint.DeltaRespMat  = physics2hw('SD', 'Setpoint', AO.SD.Setpoint.DeltaRespMat,  AO.SD.DeviceList);
% AO.SFM.Setpoint.DeltaRespMat = physics2hw('SFM','Setpoint', AO.SFM.Setpoint.DeltaRespMat, AO.SFM.DeviceList);
% AO.SDM.Setpoint.DeltaRespMat = physics2hw('SDM','Setpoint', AO.SDM.Setpoint.DeltaRespMat, AO.SDM.DeviceList);
% AO.SkewQuad.Setpoint.DeltaRespMat = physics2hw('SkewQuad', 'Setpoint', AO.SkewQuad.Setpoint.DeltaRespMat, AO.SkewQuad.DeviceList);
% setao(AO);  % setfamilydata works on the saved AO
% setfamilydata(ModeBEND, 'BEND', 'Monitor', 'Mode');
% setfamilydata(ModeBEND, 'BEND', 'Setpoint', 'Mode');
% setao(AO);






function [Elem, Err] = local_dev2elem(Family, DevList)
%  [ElementList, Error] = dev2elem('Family', [Sector Device#]);
%
%  This function convects between the two methods of representing
%  the same device in the ring.  The "Device" method is a two column
%  matrix with the first being sector number and the seconds being
%  the device number in the sector.  The "Element" method is a one column
%  matrix with each entry being the element number starting at sector 1.
%
%  Families: BEND, QFA, SF, SD, HCM, VCM, SQSF, SQSD, BPMx, or BPMy
%

%  If Element list is empty, the entire family list will be returned.
%
%  The following are equivalent devices for VCMs:
%                     | 1  2 |                    |  2 |
%                     | 1  3 |                    |  3 |
%  [Sector Device#] = | 2  1 |       [Element#] = |  9 |
%                     | 2  2 |                    | 10 |
%                     | 3  4 |                    | 20 |
%
%  On error ElementList is 1, error is 1.
%

Err = 0;
Elem = [];

if nargin == 0
    error('DEV2ELEM:  one input required.');
end
if nargin == 1
    DevList = getlist(Family);
    if isempty(DevList)
        return;
    end
end
if isempty(DevList)
    DevList = getlist(Family);
    if isempty(DevList)
        return;
    end
end


for i = 1:size(DevList,1)
    if strcmp(Family,'BPM96x')
        Elem(i,1) = 8*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'BPM96y')
        Elem(i,1) = 8*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'IDBPMx')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'IDBPMy')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'HCM')
        Elem(i,1) = 10*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'VCM')
        Elem(i,1) = 10*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'HCMCHICANE')
        Elem(i,1) = 3*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'VCMCHICANE')
        Elem(i,1) = 3*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'QF')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'QD')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'QDA')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'SF')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'SD')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'SQSF')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'SQSD')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'QFA')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'BEND')
        Elem(i,1) = 3*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'ID') || strcmp(Family,'IDvel') || strcmp(Family,'IDrunflag') || strcmp(Family,'EPU') || strcmp(Family,'SQEPU')
        %Elem(i,1) = DevList(i,1);
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    elseif strcmp(Family,'QFAS')
        Elem(i,1) = 2*(DevList(i,1)-1) + DevList(i,2);
    else
        Elem = DevList(:,1);
        Err = 1;
        %disp(['  DEV2ELEM WARNING: ', Family,' not a known family name.']);
    end
end


function [Dev, Err] = local_elem2dev(Family, Elem)
%  [Sector Device#, Error] = dev2elem('Family', Element#);
%
%  This function convects between the two methods of representing
%  the same device in the ring.  The "Device" method is a two column
%  matrix with the first being sector number and the seconds being
%  the device number in the sector.  The "Element" method is a one column
%  matrix with each entry being the element number starting at sector 1.
%
%  Families: BEND, QFA, SF, SD, HCM, VCM, SQSF, SQSD, BPMx, or BPMy
%
%  If Element list is empty, the entire family list will be returned.
%
%  The following are equivalent devices for VCMs:
%                     | 1  2 |                    |  2 |
%                     | 1  3 |                    |  3 |
%  [Sector Device#] = | 2  1 |       [Element#] = |  9 |
%                     | 2  2 |                    | 10 |
%                     | 3  4 |                    | 20 |
%
%  On error [Sector Device#] is 1, error is 1.
%

Err = 0;
Dev = [];

if nargin == 0
    error('DEV2ELEM:  one input required.');
end
if nargin == 1
    Elem = dev2elem(Family);
    if isempty(Elem)
        return;
    end
end
if isempty(Elem)
    Elem = dev2elem(Family);
    if isempty(Elem)
        return;
    end
end


for i = 1:size(Elem,1)
    if strcmp(Family,'BPM96x') || strcmp(Family,'BPM96y')
        Dev(i,:) = 1+[fix((Elem(i)-1)/8)  rem(Elem(i)-1,8)];
    elseif strcmp(Family,'IDBPMx') || strcmp(Family,'IDBPMy')
        Dev(i,:) = 1+[fix((Elem(i)-1)/2)  rem(Elem(i)-1,2)];
    elseif strcmp(Family,'BBPMx') || strcmp(Family,'BBPMy')
        Dev(i,:) = 1+[fix((Elem(i)-1)/10)  rem(Elem(i)-1,10)];
    elseif strcmp(Family,'HCM')
        Dev(i,:) = 1+[fix((Elem(i)-1)/10)  rem(Elem(i)-1,10)];
    elseif strcmp(Family,'VCM')
        Dev(i,:) = 1+[fix((Elem(i)-1)/8)  rem(Elem(i)-1,8)];
    elseif strcmp(Family,'HCMCHICANE')
        Dev(i,:) = 1+[fix((Elem(i)-1)/3)  rem(Elem(i)-1,3)];
    elseif strcmp(Family,'VCMCHICANE')
        Dev(i,:) = 1+[fix((Elem(i)-1)/3)  rem(Elem(i)-1,3)];
    elseif strcmp(Family,'QF') || strcmp(Family,'QD') || strcmp(Family,'QDA')
        Dev(i,:) = 1+[fix((Elem(i)-1)/2)  rem(Elem(i)-1,2)];
    elseif strcmp(Family,'SF') || strcmp(Family,'SD')
        Dev(i,:) = 1+[fix((Elem(i)-1)/2)  rem(Elem(i)-1,2)];
    elseif strcmp(Family,'SQSF') || strcmp(Family,'SQSD')
        Dev(i,:) = 1+[fix((Elem(i)-1)/2)  rem(Elem(i)-1,2)];
    elseif strcmp(Family,'QFA')
        Dev(i,:) = 1+[fix((Elem(i)-1)/2)  rem(Elem(i)-1,2)];
    elseif strcmp(Family,'BEND')
        Dev(i,:) = 1+[fix((Elem(i)-1)/3)  rem(Elem(i)-1,3)];
    elseif strcmp(Family,'ID') || strcmp(Family,'IDvel') || strcmp(Family,'IDrunflag') || strcmp(Family,'EPU') || strcmp(Family,'SQEPU')
        Dev(i,:) = [Elem(i) 1];
    elseif strcmp(Family,'QFAS')
        Dev(i,:) = 1+[fix((Elem(i)-1)/2)  rem(Elem(i)-1,2)];
    else
        Dev = [1 Elem];
        Err = 1;
        %disp(['  ELEM2DEV WARNING: ', Family,' not a known family name.']);
    end
end



function [Amps] = local_minsp(Family, List)
% function local_minsp = local_minsp(Family, List {entire list});
%
%   Inputs:  Family must be a string of capitols (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is minimum strength for that family


% Input checking
if nargin < 1 || nargin > 2
    error('local_minsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family, 0);
end


if isempty(List)
    error('local_minsp: List is empty');
elseif (size(List,2) == 1)
    CMelem = List;
    List = elem2dev(Family, CMelem);
elseif (size(List,2) == 2)
    % OK
else
    error('local_minsp: List must be 1 or 2 columns only');
end

for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        if (List(i,:)==[1 1])
            error('local_minsp: Sector1, HCM1 is missing.');
        elseif (List(i,2)==1 || List(i,2)==2 || List(i,2)==7 || List(i,2)==8)
            Amps(i,1) = -35;  % was -40;
        elseif (List(i,2)==3 || List(i,2)==6)
            Amps(i,1) = -17;
        elseif (List(i,2)==4 || List(i,2)==5)
            Amps(i,1) = -17;
        elseif (List(i,2)==10)
            Amps(i,1) = -19.98;
        else
            error('local_minsp: bad horizontal corrector number.');
        end
    elseif strcmp(Family,'VCM')
        if (List(i,:)==[1 1])
            error('local_minsp: Sector1, VCM1 is missing.');
        elseif (List(i,2)==1 || List(i,2)==2 || List(i,2)==7 || List(i,2)==8)
            Amps(i,1) = -36;
        elseif (List(i,2)==3 || List(i,2)==6)
            error('local_minsp: There are no SD vertical corrector magnetics.');
        elseif  (List(i,2)==4 || List(i,2)==5)
            Amps(i,1) = -14.5;
        elseif (List(i,2)==10)
            Amps(i,1) = -19.98;
        else
            error('local_minsp: bad vertical corrector number.');
        end
    elseif strcmp(Family,'HCMCHICANEM')
        Amps(i,1) = 0;
    elseif strcmp(Family,'HCMCHICANE')
        if (List(i,2)==1 || List(i,2)==3)
            Amps(i,1) = -80;
        else
            Amps(i,1) = -19.98;
        end
    elseif strcmp(Family,'VCMCHICANE')
        if (List(i,2)==1 || List(i,2)==3)
            Amps(i,1) = -80;
        else
            Amps(i,1) = -19.98;
        end
    elseif strcmp(Family,'QF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QDA')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SD')
        
        Amps(i,1) = 0;
    elseif strcmp(Family,'SQSF')
        Amps(i,1) = -19.99;
    elseif strcmp(Family,'SQSD')
        Amps(i,1) = -19.99;
    elseif strcmp(Family,'QFA')
        Amps(i,1) = 0;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 0;
    elseif strcmp(Family,'BSC')
        Amps(i,1) = 0;
    elseif strcmp(Family,'VCBSC')
        Amps(i,1) = -inf;
    elseif strcmp(Family,'QFAS')
        Amps(i,1) = 0;
    elseif strcmp(Family,'ID')
        if all(List(i,:)==[4 1])
            Amps(i,1) = 14.1; % 14;
        elseif all(List(i,:)==[4 2])
%            Amps(i,1) = 14.9;
            Amps(i,1) = 15.18;
        elseif all(List(i,:)==[5 1])
            Amps(i,1) = 13.23;
        elseif all(List(i,:)==[6 1])
            Amps(i,1) = 6.5;
        elseif all(List(i,:)==[6 2])
%            Amps(i,1) = 12.57;
%            Amps(i,1) = 12.79; %during 1/26/16 FF measurements was hitting limit at 13.032mm
            Amps(i,1) = 13.1;
        elseif all(List(i,:)==[7 1])
            Amps(i,1) = 14; %min gap limit as of 3/30/17 due to rad safety restrictions %14; % will be lower, later, but for now this is what Chuck say s- 2017-03-03
        elseif all(List(i,:)==[7 2])
            Amps(i,1) = 15; %this is just a rough guess as of 3-4-14, T.Scarvie
        elseif all(List(i,:)==[8 1])
            Amps(i,1) = 14;
        elseif all(List(i,:)==[9 1])
            Amps(i,1) = 23;
        elseif all(List(i,:)==[10 1])
            Amps(i,1) = 23.1;
        elseif all(List(i,:)==[11 1])
            Amps(i,1) = 14.85;  % we have a dynamic limit of 14.85 for B=-A, 16 for A=B
        elseif all(List(i,:)==[11 2])
            Amps(i,1) = 14.05;  % 13.8;
        elseif all(List(i,:)==[12 1])
            Amps(i,1) = 24.31; % 25;
        else
            error('local_minsp: Insertion device missing in that sector.');
        end
    elseif strcmp(Family,'EPU')
        if all(List(i,:)==[4 2])
            Amps(i,1) = -45;
        elseif all(List(i,:)==[6 2])
            Amps(i,1) = -17.5;
        elseif all(List(i,:)==[7 1])
            Amps(i,1) = -19.0;
        elseif all(List(i,:)==[7 2])
            Amps(i,1) = -35.0;
        else
            Amps(i,1) = -25;
        end
    elseif strcmp(Family,'SQEPU')
        Amps(i,1) = -20;
    elseif strcmp(Family,'IDvel')
        Amps(i,1) = 0;
    elseif strcmp(Family,'TOPSCRAPER')
        if all(List(i,:)==[3 1])
            Amps(i,1) = 0;
        else
            Amps(i,1) = 0;
        end
    elseif strcmp(Family,'BOTTOMSCRAPER')
        if all(List(i,:)==[3 1])
            Amps(i,1) = 0;
        else
            Amps(i,1) = 0;
        end
    elseif strcmp(Family,'INSIDESCRAPER')
        if all(List(i,:)==[3 1])
            Amps(i,1) = 0;
        else
            Amps(i,1) = 0;
        end
    else
        fprintf('   Min setpoint unknown for %s family, hence set to -Inf.\n', Family);
        Amps(i,1) = -Inf;
    end
end


function [Amps] = local_maxsp(Family, List)
% function Amps = local_maxsp(Family, List {entire list});
%
%   Inputs:  Family must be a string of capitols (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is maximum strength for that family


% Input checking
if nargin < 1 || nargin > 2
    error('local_maxsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family, 0);
end


if isempty(List)
    error('local_maxsp: List is empty');
elseif (size(List,2) == 1)
    CMelem = List;
    List = elem2dev(Family, CMelem);
elseif (size(List,2) == 2)
    % OK
else
    error('local_maxsp: List must be 1 or 2 columns only');
end



for i = 1:size(List,1)
    if strcmp(Family,'HCM')
        if (List(i,:)==[1 1])
            error('local_maxsp: Sector1, HCM1 is missing.');
        elseif (List(i,2)==1 || List(i,2)==2 || List(i,2)==7 || List(i,2)==8)
            Amps(i,1) = 35;  % was 40;
        elseif (List(i,2)==3 || List(i,2)==6)
            Amps(i,1) = 17;
        elseif (List(i,2)==4 || List(i,2)==5)
            Amps(i,1) = 17;
        elseif (List(i,2)==10)
            Amps(i,1) = 20;
        else
            error('local_maxsp: bad horizontal corrector number.');
        end
    elseif strcmp(Family,'VCM')
        if (List(i,:)==[1 1])
            error('local_maxsp: Sector1, VCM1 is missing.');
        elseif (List(i,2)==1 || List(i,2)==2 || List(i,2)==7 || List(i,2)==8)
            Amps(i,1) = 36;
        elseif (List(i,2)==3 || List(i,2)==6)
            error('local_maxsp: There are no SD vertical corrector magnetics.');
        elseif  (List(i,2)==4 || List(i,2)==5)
            Amps(i,1) = 14.5;
        elseif (List(i,2)==10)
            Amps(i,1) = 19.98;
        else
            error('local_maxsp: bad vertical corrector number.');
        end
    elseif strcmp(Family,'HCMCHICANEM')
        Amps(i,1) = 360;
    elseif strcmp(Family,'HCMCHICANE')
        if (List(i,2)==1 || List(i,2)==3)
            Amps(i,1) = 80;
        else
            Amps(i,1) = 19.98;
        end
    elseif strcmp(Family,'VCMCHICANE')
        if (List(i,2)==1 || List(i,2)==3)
            Amps(i,1) = 80;
        else
            Amps(i,1) = 19.98;
        end
    elseif strcmp(Family,'QF')
        Amps(i,1) = 120;  % was 130;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 120;  % was 130;
    elseif strcmp(Family,'QDA')
        Amps(i,1) = 130;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 378;  % was 376, 400
    elseif strcmp(Family,'SD')
        Amps(i,1) = 378;
    elseif strcmp(Family,'SQSF')
        Amps(i,1) = 19.99;
    elseif strcmp(Family,'SQSD')
        Amps(i,1) = 19.99;
    elseif strcmp(Family,'QFA')
        Amps(i,1) = 600;
    elseif strcmp(Family,'BEND')
        if all(List(i,:)==[4 2]) || all(List(i,:)==[8 2]) || all(List(i,:)==[12 2])
            Amps(i,1) = 350;
        else
            Amps(i,1) = 1000;
        end
    elseif strcmp(Family,'BSC')
        Amps(i,1) = 350;
    elseif strcmp(Family,'VCBSC')
        Amps(i,1) = inf;
    elseif strcmp(Family,'QFAS')
        Amps(i,1) = 1000;
    elseif strcmp(Family,'ID')
        if all(List(i,:)==[6 1])
            Amps(i,1) = 38;
        elseif all(List(i,:)==[4 1])
            Amps(i,1) = 210;
        elseif all(List(i,:)==[4 2])
            Amps(i,1) = 205;
        elseif all(List(i,:)==[6 2])
            Amps(i,1) = 200;
        elseif all(List(i,:)==[7 1])
            Amps(i,1) = 195;
        elseif all(List(i,:)==[7 2])
            Amps(i,1) = 200;
        else
            Amps(i,1) = 210;
        end
    elseif strcmp(Family,'IDvel') && all(List(i,:)==[6 1])
        Amps(i,1) = 1;
    elseif strcmp(Family,'IDvel')
        Amps(i,1) = 3.33;
    elseif strcmp(Family,'EPU')
        if all(List(i,:)==[4 2])
            Amps(i,1) = 45;
        elseif all(List(i,:)==[6 2])
            Amps(i,1) = 17.5;
        elseif all(List(i,:)==[7 1])
            Amps(i,1) = 19.0;
        elseif all(List(i,:)==[7 2])
            Amps(i,1) = 35.0;
        else
            Amps(i,1) = 25;
        end
    elseif strcmp(Family,'SQEPU')
        Amps(i,1) = 20;
    elseif strcmp(Family,'TOPSCRAPER')
        if all(List(i,:)==[3 1])
            Amps(i,1) = 25;
        elseif all(List(i,:)==[1 1])
            Amps(i,1) = 4.91;
        elseif all(List(i,:)==[2 1])
            Amps(i,1) = 5.64;
        elseif all(List(i,:)==[2 6])
            Amps(i,1) = 8.575;
        elseif all(List(i,:)==[12 6])
            Amps(i,1) = 4.91;
        else
            Amps(i,1) = 0;
        end
    elseif strcmp(Family,'BOTTOMSCRAPER')
        if all(List(i,:)==[3 1])
            Amps(i,1) = 25;
        elseif all(List(i,:)==[1 1])
            Amps(i,1) = 6.42;
        elseif all(List(i,:)==[2 1])
            Amps(i,1) = 5.69;
        elseif all(List(i,:)==[2 1])
            Amps(i,1) = 5.69;
        else
            Amps(i,1) = 0;
        end
    elseif strcmp(Family,'INSIDESCRAPER')
        if all(List(i,:)==[3 1])
            Amps(i,1) = 70;
        else
            Amps(i,1) = 0;
        end
    else
        fprintf('   Max setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = Inf;
    end
end


function tol = gettol(Family)
%  tol = gettol(Family)
%  Tolerance on the SP-AM for that family

if strcmp(Family,'HCM')
    tol = 0.28; %was .1 - changed for SR05C_SQSF2 on 11-26-07
elseif strcmp(Family,'VCM')
%    tol = 0.2;  % Was .2
    tol = 0.6;  % Was .2
elseif strcmp(Family,'QF')
    tol = 0.2;  % Was .55, .4, QF(12,1) problem GJP
elseif strcmp(Family,'QD')
    tol = 0.2; % Was 0.25;
elseif strcmp(Family,'SQSF')
    tol = 0.25;
elseif strcmp(Family,'SQSD')
    tol = 0.25;
elseif strcmp(Family,'SF')
    tol = 1.0;
    % tol = 15.0;
    %fprintf('   SF Tolerance raised to 15 amps due to monitor problems (change line alsinit/gettol when fixed).\n');
elseif strcmp(Family,'SD')
    tol = 1.0;
elseif strcmp(Family,'SHF')
    tol = 0.3;
elseif strcmp(Family,'SHD')
    tol = 0.3;
elseif strcmp(Family,'SQSHF')
    tol = 0.2;
elseif strcmp(Family,'QFA')
    %tol = 1.0;
    % Moved up the tolerance on QFA(4) due to many alarms [GJP]
    tol = [
        1     1
        2     1
        3     1
        4     1
        5     1
        6     1
        7     1.3
        8     1.3
        9     1
        10     1
        11     1
        12     1
        13     1
        14     1
        15     1
        16     1
        17     1
        18     1
        19     1
        20     1
        21     1
        22     1
        23     1
        24     1
        ];
        tol = tol(:,2);
elseif strcmp(Family,'QDA')
    tol = 0.25;
elseif strcmp(Family,'BEND')
    tol = .8;  % Was 1.5
elseif strcmp(Family,'BSC')
    tol = .25; % Was 1.0
elseif strcmp(Family,'VCBSC')
    tol = .25;
elseif strcmp(Family,'HCMCHICANE')
    tol = 0.6;  % Raised for .25 to .6 due to cycling problem
elseif strcmp(Family,'VCMCHICANE')
    tol = 0.1;
elseif strcmp(Family,'HCMCHICANEM')
    tol = 0.015;
elseif strcmp(Family,'ID')
    tol = 0.003;
elseif strcmp(Family,'EPU')
    tol = 0.003;
elseif strcmp(Family,'SQEPU')
    tol = 0.25;
elseif strcmp(Family,'TOPSCRAPER')
    tol = 20;
elseif strcmp(Family,'BOTTOMSCRAPER')
    tol = 20;
elseif strcmp(Family,'INSIDESCRAPER')
    tol = 20;
else
    fprintf('   Tolerance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end


function [Gain, Offset] = QFQDMonitorGainOffset
% use calcgainoffset to find these values
Gain = [
    0.9994    0.9996
    0.9991    0.9995
    0.9983    1.0003
    0.9992    0.9997
    0.9992    0.9999
    0.9988    1.0000
    1.0012    1.0005
    1.0012    1.0003
    0.9998    0.9992
    0.9998    0.9993
    0.9968    1.0004
    1.0008    1.0003
    0.9998    0.9995
    0.9995    0.9994
    0.9981    0.9988
    0.9985    0.9983
    1.0014    0.9995
    1.0012    0.9993
    0.9990    0.9991
    0.9992    0.9990
    1.0012    0.9995
    1.0011    0.9987
    1.0003    0.9990
    1.0002    0.9990];

% Gain =[
%     0.9989    0.9994
%     0.9989    0.9993
%     1.0015    0.9990
%     1.0007    0.9989
%     0.9994    0.9995
%     0.9989    0.9995
%     1.0009    1.0002
%     1.0008    0.9999
%     0.9993    0.9991
%     0.9995    0.9992
%     1.0008    1.0002
%     1.0008    1.0001
%     0.9995    0.9991
%     0.9992    0.9998
%     0.9998    0.9990
%     0.9995    0.9992
%     1.0010    0.9992
%     1.0010    0.9992
%     0.9985    0.9989
%     0.9987    0.9992
%     0.9994    0.9991
%     0.9991    0.9991
%     0.9942    1.0004
%     0.9996    1.0008];

Offset = zeros(24,2);




function [Gain, Offset] = BENDMonitorGainOffset
Gain = [
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    1.0006
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    1.0005
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    0.9991
    1.0007
    0.9991];
Offset = zeros(36,1);

function [Gain, Offset] = QFAMonitorGainOffset
Gain = [
    1.0016
    1.0016
    1.0016
    1.0016
    1.0016
    1.0016
    1.0000
    1.0000
    1.0016
    1.0016
    1.0016
    1.0016
    1.0016
    1.0016
    0.9994
    0.9994
    1.0016
    1.0016
    1.0016
    1.0016
    1.0016
    1.0016
    0.9988
    0.9988];
Offset = zeros(24,1);


