function spsinit(OperationalMode)
%SPSINIT - MML setup file for the Siam Photon Source (SPS)


if nargin < 1
    % Default operational mode: User Mode
    OperationalMode = 1;
end


% Clear previous AcceleratorObjects
setao([]);   
setad([]);   


% Build the various device lists
OnePerSectorList=[];
TwoPerSectorList=[];
ThreePerSectorList=[];
FourPerSectorList=[];
FivePerSectorList=[];
for Sector =1:4
    OnePerSectorList = [OnePerSectorList;
        Sector 1;];
    TwoPerSectorList = [TwoPerSectorList;
        Sector 1;
        Sector 2;];
    ThreePerSectorList = [ThreePerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;];
    FourPerSectorList = [FourPerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;];
    FivePerSectorList = [FivePerSectorList;
        Sector 1;
        Sector 2;
        Sector 3;
        Sector 4;
        Sector 5;];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build Family Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% BPM
AO.BPMx.FamilyName = 'BPMx';
AO.BPMx.MemberOf   = {'PlotFamily'; 'BPM';'BPMx';};
AO.BPMx.DeviceList = FivePerSectorList;
AO.BPMx.DeviceList = [[1 6]; [1 7]; AO.BPMx.DeviceList(1:15,:); [3 6]; AO.BPMx.DeviceList(16:end,:); [4 6]];  % Add 4 BPMs of downstream and upstream IDs
AO.BPMx.ElementList = (1:size(AO.BPMx.DeviceList,1))';
AO.BPMx.Status      = ones(size(AO.BPMx.DeviceList,1),1);

AO.BPMx.Monitor.Mode = 'Simulator';
AO.BPMx.Monitor.DataType = 'Scalar';
AO.BPMx.Monitor.ChannelNames = getname_sps('BPMx', 'Monitor', AO.BPMx.DeviceList);
AO.BPMx.Monitor.Units = 'Hardware';
AO.BPMx.Monitor.HWUnits          = 'mm';
AO.BPMx.Monitor.PhysicsUnits     = 'Meter';
AO.BPMx.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMx.Monitor.Physics2HWParams = 1e+3;

AO.BPMy.FamilyName = 'BPMy';
AO.BPMy.MemberOf   = {'PlotFamily'; 'BPM';'BPMy';};
AO.BPMy.DeviceList = AO.BPMx.DeviceList;
AO.BPMy.ElementList = AO.BPMx.ElementList;
AO.BPMy.Status = AO.BPMx.Status;

AO.BPMy.Monitor.Mode = 'Simulator';
AO.BPMy.Monitor.DataType = 'Scalar';
AO.BPMy.Monitor.ChannelNames = getname_sps('BPMy', 'Monitor', AO.BPMy.DeviceList);
AO.BPMy.Monitor.Units = 'Hardware';
AO.BPMy.Monitor.HWUnits          = 'mm';
AO.BPMy.Monitor.PhysicsUnits     = 'Meter';
AO.BPMy.Monitor.HW2PhysicsParams = 1e-3;
AO.BPMy.Monitor.Physics2HWParams = 1e+3;


% HCM Correctors
AO.HCM.FamilyName = 'HCM';
AO.HCM.MemberOf   = {'PlotFamily'; 'COR'; 'HCM'; 'Magnet'};
AO.HCM.DeviceList = FourPerSectorList;
AO.HCM.ElementList = (1:size(FourPerSectorList,1))';
AO.HCM.Status = ones(size(FourPerSectorList,1),1);

AO.HCM.Monitor.MemberOf = {'COR'; 'HCM'; 'Magnet'; 'Monitor'};
AO.HCM.Monitor.Mode = 'Simulator';
AO.HCM.Monitor.DataType = 'Scalar';
AO.HCM.Monitor.ChannelNames = getname_sps('HCM', 'Monitor', AO.HCM.DeviceList);
AO.HCM.Monitor.HW2PhysicsParams = -9.9254e-5;
AO.HCM.Monitor.Physics2HWParams = 1./AO.HCM.Monitor.HW2PhysicsParams;
%AO.HCM.Monitor.HW2PhysicsFcn = @sps2at;
%AO.HCM.Monitor.Physics2HWFcn = @at2sps;
AO.HCM.Monitor.HWUnits      = 'Ampere';
AO.HCM.Monitor.PhysicsUnits = 'Radian';
AO.HCM.Monitor.Units = 'Hardware';

AO.HCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'HCM'; 'Magnet'; 'Setpoint'};
AO.HCM.Setpoint.Mode = 'Simulator';
AO.HCM.Setpoint.DataType = 'Scalar';
AO.HCM.Setpoint.ChannelNames = getname_sps('HCM', 'Setpoint', AO.HCM.DeviceList);
AO.HCM.Setpoint.HW2PhysicsParams = AO.HCM.Monitor.HW2PhysicsParams;
AO.HCM.Setpoint.Physics2HWParams = AO.HCM.Monitor.Physics2HWParams;
%AO.HCM.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.HCM.Setpoint.Physics2HWFcn = @at2sps;
AO.HCM.Setpoint.HWUnits      = 'Ampere';
AO.HCM.Setpoint.PhysicsUnits = 'Radian';
AO.HCM.Setpoint.Units = 'Hardware';


% VCM Correctors
AO.VCM.FamilyName = 'VCM';
AO.VCM.MemberOf   = {'PlotFamily'; 'COR'; 'VCM'; 'Magnet'};
AO.VCM.DeviceList = ThreePerSectorList;
AO.VCM.ElementList = (1:size(ThreePerSectorList,1))';
AO.VCM.Status = ones(size(ThreePerSectorList,1),1);

AO.VCM.Monitor.MemberOf = {'COR'; 'VCM'; 'Magnet'; 'Monitor'};
AO.VCM.Monitor.Mode = 'Simulator';
AO.VCM.Monitor.DataType = 'Scalar';
AO.VCM.Monitor.ChannelNames = getname_sps('VCM', 'Monitor', AO.VCM.DeviceList);
AO.VCM.Monitor.HW2PhysicsParams = [9.2252e-5 8.9440e-5 9.2252e-5 9.2252e-5 8.9440e-5 9.2252e-5 9.2252e-5 8.9440e-5 9.2252e-5 9.2252e-5 8.9440e-5 9.2252e-5]';
AO.VCM.Monitor.Physics2HWParams = 1./AO.VCM.Monitor.HW2PhysicsParams;
%AO.VCM.Monitor.HW2PhysicsFcn = @sps2at;
%AO.VCM.Monitor.Physics2HWFcn = @at2sps;
AO.VCM.Monitor.HWUnits      = 'Ampere';
AO.VCM.Monitor.PhysicsUnits = 'Radian';
AO.VCM.Monitor.Units = 'Hardware';

AO.VCM.Setpoint.MemberOf = {'MachineConfig'; 'COR'; 'VCM'; 'Magnet'; 'Setpoint'};
AO.VCM.Setpoint.Mode = 'Simulator';
AO.VCM.Setpoint.DataType = 'Scalar';
AO.VCM.Setpoint.ChannelNames = getname_sps('VCM', 'Setpoint', AO.VCM.DeviceList);
AO.VCM.Setpoint.HW2PhysicsParams = AO.VCM.Monitor.HW2PhysicsParams;
AO.VCM.Setpoint.Physics2HWParams = AO.VCM.Monitor.Physics2HWParams;
%AO.VCM.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.VCM.Setpoint.Physics2HWFcn = @at2sps;
AO.VCM.Setpoint.HWUnits      = 'Ampere';
AO.VCM.Setpoint.PhysicsUnits = 'Radian';
AO.VCM.Setpoint.Units = 'Hardware';


% QF1 Main Power Suppy
AO.QF.FamilyName = 'QF';
AO.QF.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF'; 'QUAD'; 'Magnet'};
AO.QF.DeviceList = TwoPerSectorList;
iRemove = unique([1 6 7 8]);
AO.QF.DeviceList(iRemove,:) = [];
AO.QF.ElementList = (1:size(AO.QF.DeviceList,1))';
AO.QF.Status = ones(size(AO.QF.DeviceList,1),1);

AO.QF.Monitor.Mode = 'Simulator';
AO.QF.Monitor.DataType = 'Scalar';
AO.QF.Monitor.ChannelNames = getname_sps('QF', 'Monitor', AO.QF.DeviceList);
AO.QF.Monitor.HW2PhysicsFcn = @amp2k;
AO.QF.Monitor.Physics2HWFcn = @k2amp;
AO.QF.Monitor.HW2PhysicsParams = {[-9.209146E-09 3.764377E-06 2.645068E-02 1.550687E-02]};%% Changed G-I curve 6.4301191e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QF.Monitor.Physics2HWParams = {[-9.209146E-09 3.764377E-06 2.645068E-02 1.550687E-02]};%% Change 1 ./ AO.QF.Monitor.HW2PhysicsParams;
AO.QF.Monitor.Units = 'Hardware';
AO.QF.Monitor.HWUnits      = 'Ampere';
AO.QF.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF.Setpoint.MemberOf = {'MachineConfig';};
AO.QF.Setpoint.Mode = 'Simulator';
AO.QF.Setpoint.DataType = 'Scalar';
AO.QF.Setpoint.ChannelNames = getname_sps('QF', 'Setpoint', AO.QF.DeviceList);
AO.QF.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QF.Setpoint.Physics2HWFcn = @k2amp;
AO.QF.Setpoint.HW2PhysicsParams = AO.QF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QF.Setpoint.Physics2HWParams = AO.QF.Monitor.Physics2HWParams;
%AO.QF.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF.Setpoint.Physics2HWFcn = @at2sps;
AO.QF.Setpoint.Units = 'Hardware';
AO.QF.Setpoint.HWUnits      = 'Ampere';
AO.QF.Setpoint.PhysicsUnits = '1/Meter^2';


%QF1_SWLS
AO.QF1_SWLS.FamilyName = 'QF1_SWLS';
AO.QF1_SWLS.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF1_SWLS'; 'QUAD'; 'Magnet'};
AO.QF1_SWLS.DeviceList = [[1 1]; [1 2]];
AO.QF1_SWLS.ElementList = (1:size(AO.QF1_SWLS.DeviceList,1))';
AO.QF1_SWLS.Status = ones(size(AO.QF1_SWLS.DeviceList,1),1);

AO.QF1_SWLS.Monitor.Mode = 'Simulator';
AO.QF1_SWLS.Monitor.DataType = 'Scalar';
AO.QF1_SWLS.Monitor.ChannelNames = getname_sps('QF1_SWLS', 'Monitor', AO.QF1_SWLS.DeviceList);
AO.QF1_SWLS.Monitor.HW2PhysicsFcn = @amp2k;
AO.QF1_SWLS.Monitor.Physics2HWFcn = @k2amp;
AO.QF1_SWLS.Monitor.HW2PhysicsParams = {[-9.209146E-09 3.764377E-06]};%% Changed G-I curve 6.4301191e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QF1_SWLS.Monitor.Physics2HWParams = {[-9.209146E-09 3.764377E-06]};%% Change 1 ./ AO.QF.Monitor.HW2PhysicsParams;
AO.QF1_SWLS.Monitor.Units = 'Hardware';
AO.QF1_SWLS.Monitor.HWUnits      = 'Ampere';
AO.QF1_SWLS.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF1_SWLS.Setpoint.MemberOf = {'MachineConfig';};
AO.QF1_SWLS.Setpoint.Mode = 'Simulator';
AO.QF1_SWLS.Setpoint.DataType = 'Scalar';
AO.QF1_SWLS.Setpoint.ChannelNames = getname_sps('QF1_SWLS', 'Setpoint', AO.QF1_SWLS.DeviceList);
AO.QF1_SWLS.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QF1_SWLS.Setpoint.Physics2HWFcn = @k2amp;
AO.QF1_SWLS.Setpoint.HW2PhysicsParams = AO.QF1_SWLS.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QF1_SWLS.Setpoint.Physics2HWParams = AO.QF1_SWLS.Monitor.Physics2HWParams;
%AO.QF.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF.Setpoint.Physics2HWFcn = @at2sps;
AO.QF1_SWLS.Setpoint.Units = 'Hardware';
AO.QF1_SWLS.Setpoint.HWUnits      = 'Ampere';
AO.QF1_SWLS.Setpoint.PhysicsUnits = '1/Meter^2';


%QF11_MPW
AO.QF11_MPW.FamilyName = 'QF11_MPW';
AO.QF11_MPW.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF11_MPW'; 'QUAD'; 'Magnet'};
AO.QF11_MPW.DeviceList = [[1 1]];
AO.QF11_MPW.ElementList = (1:size(AO.QF11_MPW.DeviceList,1))';
AO.QF11_MPW.Status = ones(size(AO.QF11_MPW.DeviceList,1),1);

AO.QF11_MPW.Monitor.Mode = 'Simulator';
AO.QF11_MPW.Monitor.DataType = 'Scalar';
AO.QF11_MPW.Monitor.ChannelNames = getname_sps('QF11_MPW', 'Monitor', AO.QF11_MPW.DeviceList);
AO.QF11_MPW.Monitor.HW2PhysicsFcn = @amp2k;
AO.QF11_MPW.Monitor.Physics2HWFcn = @k2amp;
AO.QF11_MPW.Monitor.HW2PhysicsParams = {[-9.209146E-09]};%% Changed G-I curve 6.4301191e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QF11_MPW.Monitor.Physics2HWParams = {[-9.209146E-09]};%% Change 1 ./ AO.QF.Monitor.HW2PhysicsParams;
AO.QF11_MPW.Monitor.Units = 'Hardware';
AO.QF11_MPW.Monitor.HWUnits      = 'Ampere';
AO.QF11_MPW.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF11_MPW.Setpoint.MemberOf = {'MachineConfig';};
AO.QF11_MPW.Setpoint.Mode = 'Simulator';
AO.QF11_MPW.Setpoint.DataType = 'Scalar';
AO.QF11_MPW.Setpoint.ChannelNames = getname_sps('QF11_MPW', 'Setpoint', AO.QF11_MPW.DeviceList);
AO.QF11_MPW.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QF11_MPW.Setpoint.Physics2HWFcn = @k2amp;
AO.QF11_MPW.Setpoint.HW2PhysicsParams = AO.QF11_MPW.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QF11_MPW.Setpoint.Physics2HWParams = AO.QF11_MPW.Monitor.Physics2HWParams;
%AO.QF.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF.Setpoint.Physics2HWFcn = @at2sps;
AO.QF11_MPW.Setpoint.Units = 'Hardware';
AO.QF11_MPW.Setpoint.HWUnits      = 'Ampere';
AO.QF11_MPW.Setpoint.PhysicsUnits = '1/Meter^2';


% QF18_MPW
AO.QF18_MPW.FamilyName = 'QF18_MPW';
AO.QF18_MPW.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QF18_MPW'; 'QUAD'; 'Magnet'};
AO.QF18_MPW.DeviceList = [[1 1]];
AO.QF18_MPW.ElementList = (1:size(AO.QF18_MPW.DeviceList,1))';
AO.QF18_MPW.Status = ones(size(AO.QF18_MPW.DeviceList,1),1);

AO.QF18_MPW.Monitor.Mode = 'Simulator';
AO.QF18_MPW.Monitor.DataType = 'Scalar';
AO.QF18_MPW.Monitor.ChannelNames = getname_sps('QF18_MPW', 'Monitor', AO.QF18_MPW.DeviceList);
AO.QF18_MPW.Monitor.HW2PhysicsFcn = @amp2k;
AO.QF18_MPW.Monitor.Physics2HWFcn = @k2amp;
AO.QF18_MPW.Monitor.HW2PhysicsParams = {[-9.209146E-09]};%% Changed G-I curve 6.4301191e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QF18_MPW.Monitor.Physics2HWParams = {[-9.209146E-09]};%% Change 1 ./ AO.QF.Monitor.HW2PhysicsParams;
AO.QF18_MPW.Monitor.Units = 'Hardware';
AO.QF18_MPW.Monitor.HWUnits      = 'Ampere';
AO.QF18_MPW.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF18_MPW.Setpoint.MemberOf = {'MachineConfig';};
AO.QF18_MPW.Setpoint.Mode = 'Simulator';
AO.QF18_MPW.Setpoint.DataType = 'Scalar';
AO.QF18_MPW.Setpoint.ChannelNames = getname_sps('QF18_MPW', 'Setpoint', AO.QF18_MPW.DeviceList);
AO.QF18_MPW.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QF18_MPW.Setpoint.Physics2HWFcn = @k2amp;
AO.QF18_MPW.Setpoint.HW2PhysicsParams = AO.QF18_MPW.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QF18_MPW.Setpoint.Physics2HWParams = AO.QF18_MPW.Monitor.Physics2HWParams;
%AO.QF.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF.Setpoint.Physics2HWFcn = @at2sps;
AO.QF18_MPW.Setpoint.Units = 'Hardware';
AO.QF18_MPW.Setpoint.HWUnits      = 'Ampere';
AO.QF18_MPW.Setpoint.PhysicsUnits = '1/Meter^2';


%QD2 Main Power Supply
AO.QD.FamilyName = 'QD';
AO.QD.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QD'; 'QUAD'; 'Magnet'};
AO.QD.DeviceList = TwoPerSectorList;
iRemove = unique([1 6 7 8]);
AO.QD.DeviceList(iRemove,:) = [];
AO.QD.ElementList = (1:size(AO.QD.DeviceList,1))';
AO.QD.Status = ones(size(AO.QD.DeviceList,1),1);

AO.QD.Monitor.Mode = 'Simulator';
AO.QD.Monitor.DataType = 'Scalar';
AO.QD.Monitor.ChannelNames = getname_sps('QD', 'Monitor', AO.QD.DeviceList);
AO.QD.Monitor.HW2PhysicsFcn = @amp2k;
AO.QD.Monitor.Physics2HWFcn = @k2amp;
AO.QD.Monitor.HW2PhysicsParams = {-1.*[-8.472620E-09 3.408007E-06 2.644766E-02 1.387919E-02]};%% Changed G-I curve-6.431778e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QD.Monitor.Physics2HWParams = {-1.*[-8.472620E-09 3.408007E-06 2.644766E-02 1.387919E-02]};%% Changed 1 ./ AO.QD.Monitor.HW2PhysicsParams;
AO.QD.Monitor.Units = 'Hardware';
AO.QD.Monitor.HWUnits      = 'Ampere';
AO.QD.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD.Setpoint.MemberOf = {'MachineConfig';};
AO.QD.Setpoint.Mode = 'Simulator';
AO.QD.Setpoint.DataType = 'Scalar';
AO.QD.Setpoint.ChannelNames = getname_sps('QD', 'Setpoint', AO.QD.DeviceList);
AO.QD.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QD.Setpoint.Physics2HWFcn = @k2amp;
AO.QD.Setpoint.HW2PhysicsParams = AO.QD.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QD.Setpoint.Physics2HWParams = AO.QD.Monitor.Physics2HWParams;
%AO.QD.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QD.Setpoint.Physics2HWFcn = @at2sps;
AO.QD.Setpoint.Units = 'Hardware';
AO.QD.Setpoint.HWUnits      = 'Ampere';
AO.QD.Setpoint.PhysicsUnits = '1/Meter^2';


% QD2_SWLS
AO.QD2_SWLS.FamilyName = 'QD2_SWLS';
AO.QD2_SWLS.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QD2_SWLS'; 'QUAD'; 'Magnet'};
AO.QD2_SWLS.DeviceList = [[1 1]; [1 2]];
AO.QD2_SWLS.ElementList = (1:size(AO.QD2_SWLS.DeviceList,1))';
AO.QD2_SWLS.Status = ones(size(AO.QD2_SWLS.DeviceList,1),1);

AO.QD2_SWLS.Monitor.Mode = 'Simulator';
AO.QD2_SWLS.Monitor.DataType = 'Scalar';
AO.QD2_SWLS.Monitor.ChannelNames = getname_sps('QD2_SWLS', 'Monitor', AO.QD2_SWLS.DeviceList);
AO.QD2_SWLS.Monitor.HW2PhysicsFcn = @amp2k;
AO.QD2_SWLS.Monitor.Physics2HWFcn = @k2amp;
AO.QD2_SWLS.Monitor.HW2PhysicsParams = {[-9.209146E-09 3.764377E-06]};%% Changed G-I curve 6.4301191e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QD2_SWLS.Monitor.Physics2HWParams = {[-9.209146E-09 3.764377E-06]};%% Change 1 ./ AO.QF.Monitor.HW2PhysicsParams;
AO.QD2_SWLS.Monitor.Units = 'Hardware';
AO.QD2_SWLS.Monitor.HWUnits      = 'Ampere';
AO.QD2_SWLS.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD2_SWLS.Setpoint.MemberOf = {'MachineConfig';};
AO.QD2_SWLS.Setpoint.Mode = 'Simulator';
AO.QD2_SWLS.Setpoint.DataType = 'Scalar';
AO.QD2_SWLS.Setpoint.ChannelNames = getname_sps('QD2_SWLS', 'Setpoint', AO.QD2_SWLS.DeviceList);
AO.QD2_SWLS.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QD2_SWLS.Setpoint.Physics2HWFcn = @k2amp;
AO.QD2_SWLS.Setpoint.HW2PhysicsParams = AO.QD2_SWLS.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QD2_SWLS.Setpoint.Physics2HWParams = AO.QD2_SWLS.Monitor.Physics2HWParams;
%AO.QF.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF.Setpoint.Physics2HWFcn = @at2sps;
AO.QD2_SWLS.Setpoint.Units = 'Hardware';
AO.QD2_SWLS.Setpoint.HWUnits      = 'Ampere';
AO.QD2_SWLS.Setpoint.PhysicsUnits = '1/Meter^2';


%QD21_MPW
AO.QD21_MPW.FamilyName = 'QD21_MPW';
AO.QD21_MPW.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QD21_MPW'; 'QUAD'; 'Magnet'};
AO.QD21_MPW.DeviceList = [[1 1]];
AO.QD21_MPW.ElementList = (1:size(AO.QD21_MPW.DeviceList,1))';
AO.QD21_MPW.Status = ones(size(AO.QD21_MPW.DeviceList,1),1);

AO.QD21_MPW.Monitor.Mode = 'Simulator';
AO.QD21_MPW.Monitor.DataType = 'Scalar';
AO.QD21_MPW.Monitor.ChannelNames = getname_sps('QD21_MPW', 'Monitor', AO.QD21_MPW.DeviceList);
AO.QD21_MPW.Monitor.HW2PhysicsFcn = @amp2k;
AO.QD21_MPW.Monitor.Physics2HWFcn = @k2amp;
AO.QD21_MPW.Monitor.HW2PhysicsParams = {[3.764377E-06]};%% Changed G-I curve 6.4301191e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QD21_MPW.Monitor.Physics2HWParams = {[3.764377E-06]};%% Change 1 ./ AO.QF.Monitor.HW2PhysicsParams;
AO.QD21_MPW.Monitor.Units = 'Hardware';
AO.QD21_MPW.Monitor.HWUnits      = 'Ampere';
AO.QD21_MPW.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD21_MPW.Setpoint.MemberOf = {'MachineConfig';};
AO.QD21_MPW.Setpoint.Mode = 'Simulator';
AO.QD21_MPW.Setpoint.DataType = 'Scalar';
AO.QD21_MPW.Setpoint.ChannelNames = getname_sps('QD21_MPW', 'Setpoint', AO.QD21_MPW.DeviceList);
AO.QD21_MPW.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QD21_MPW.Setpoint.Physics2HWFcn = @k2amp;
AO.QD21_MPW.Setpoint.HW2PhysicsParams = AO.QD21_MPW.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QD21_MPW.Setpoint.Physics2HWParams = AO.QD21_MPW.Monitor.Physics2HWParams;
%AO.QF.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF.Setpoint.Physics2HWFcn = @at2sps;
AO.QD21_MPW.Setpoint.Units = 'Hardware';
AO.QD21_MPW.Setpoint.HWUnits      = 'Ampere';
AO.QD21_MPW.Setpoint.PhysicsUnits = '1/Meter^2';


% QD28_MPW
AO.QD28_MPW.FamilyName = 'QD28_MPW';
AO.QD28_MPW.MemberOf   = {'PlotFamily'; 'Tune Corrector'; 'QD28_MPW'; 'QUAD'; 'Magnet'};
AO.QD28_MPW.DeviceList = [[1 1]];
AO.QD28_MPW.ElementList = (1:size(AO.QD28_MPW.DeviceList,1))';
AO.QD28_MPW.Status = ones(size(AO.QD28_MPW.DeviceList,1),1);

AO.QD28_MPW.Monitor.Mode = 'Simulator';
AO.QD28_MPW.Monitor.DataType = 'Scalar';
AO.QD28_MPW.Monitor.ChannelNames = getname_sps('QD28_MPW', 'Monitor', AO.QD28_MPW.DeviceList);
AO.QD28_MPW.Monitor.HW2PhysicsFcn = @amp2k;
AO.QD28_MPW.Monitor.Physics2HWFcn = @k2amp;
AO.QD28_MPW.Monitor.HW2PhysicsParams = {[3.764377E-06]};%% Changed G-I curve 6.4301191e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QD28_MPW.Monitor.Physics2HWParams = {[3.764377E-06]};%% Change 1 ./ AO.QF.Monitor.HW2PhysicsParams;
AO.QD28_MPW.Monitor.Units = 'Hardware';
AO.QD28_MPW.Monitor.HWUnits      = 'Ampere';
AO.QD28_MPW.Monitor.PhysicsUnits = '1/Meter^2';

AO.QD28_MPW.Setpoint.MemberOf = {'MachineConfig';};
AO.QD28_MPW.Setpoint.Mode = 'Simulator';
AO.QD28_MPW.Setpoint.DataType = 'Scalar';
AO.QD28_MPW.Setpoint.ChannelNames = getname_sps('QD28_MPW', 'Setpoint', AO.QD28_MPW.DeviceList);
AO.QD28_MPW.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QD28_MPW.Setpoint.Physics2HWFcn = @k2amp;
AO.QD28_MPW.Setpoint.HW2PhysicsParams = AO.QD28_MPW.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QD28_MPW.Setpoint.Physics2HWParams = AO.QD28_MPW.Monitor.Physics2HWParams;
%AO.QF.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF.Setpoint.Physics2HWFcn = @at2sps;
AO.QD28_MPW.Setpoint.Units = 'Hardware';
AO.QD28_MPW.Setpoint.HWUnits      = 'Ampere';
AO.QD28_MPW.Setpoint.PhysicsUnits = '1/Meter^2';


% QF3 Main Power supply
AO.QFA.FamilyName = 'QFA';
AO.QFA.MemberOf   = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'};
AO.QFA.DeviceList = TwoPerSectorList;
iRemove = unique([1 8]);
AO.QFA.DeviceList(iRemove,:) = [];
AO.QFA.ElementList = (1:size(AO.QFA.DeviceList,1))';
AO.QFA.Status = ones(size(AO.QFA.DeviceList,1),1);

AO.QFA.Monitor.Mode = 'Simulator';
AO.QFA.Monitor.DataType = 'Scalar';
AO.QFA.Monitor.ChannelNames = getname_sps('QFA', 'Monitor', AO.QFA.DeviceList);
AO.QFA.Monitor.HW2PhysicsFcn = @amp2k;
AO.QFA.Monitor.Physics2HWFcn = @k2amp;
AO.QFA.Monitor.HW2PhysicsParams = {[-3.957102E-08 2.017110E-05 2.372120E-02 1.493758E-01]}; %% Changed G-I curve 6.506781e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QFA.Monitor.Physics2HWParams = {[-3.957102E-08 2.017110E-05 2.372120E-02 1.493758E-01]}; %% Changed 1 ./ AO.QFA.Monitor.HW2PhysicsParams;
AO.QFA.Monitor.Units = 'Hardware';
AO.QFA.Monitor.HWUnits = 'Ampere';
AO.QFA.Monitor.PhysicsUnits = '1/Meter^2';

AO.QFA.Setpoint.MemberOf = {'MachineConfig'};
AO.QFA.Setpoint.Mode = 'Simulator';
AO.QFA.Setpoint.DataType = 'Scalar';
AO.QFA.Setpoint.ChannelNames = getname_sps('QFA', 'Setpoint', AO.QFA.DeviceList);
AO.QFA.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QFA.Setpoint.Physics2HWFcn = @k2amp;
AO.QFA.Setpoint.HW2PhysicsParams = AO.QFA.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QFA.Setpoint.Physics2HWParams = AO.QFA.Monitor.Physics2HWParams;
%AO.QFA.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QFA.Setpoint.Physics2HWFcn = @at2sps;
AO.QFA.Setpoint.Units = 'Hardware';
AO.QFA.Setpoint.HWUnits = 'Ampere';
AO.QFA.Setpoint.PhysicsUnits = '1/Meter^2';


% QF31
AO.QF31_MPW.FamilyName = 'QF31_MPW';
AO.QF31_MPW.MemberOf   = {'PlotFamily'; 'QF31_MPW'; 'QUAD'; 'Magnet'};
AO.QF31_MPW.DeviceList = [[1 1]];
AO.QF31_MPW.ElementList = (1:size(AO.QF31_MPW.DeviceList,1))';
AO.QF31_MPW.Status = ones(size(AO.QF31_MPW.DeviceList,1),1);

AO.QF31_MPW.Monitor.Mode = 'Simulator';
AO.QF31_MPW.Monitor.DataType = 'Scalar';
AO.QF31_MPW.Monitor.ChannelNames = getname_sps('QF31_MPW', 'Monitor', AO.QF31_MPW.DeviceList);
AO.QF31_MPW.Monitor.HW2PhysicsFcn = @amp2k;
AO.QF31_MPW.Monitor.Physics2HWFcn = @k2amp;
AO.QF31_MPW.Monitor.HW2PhysicsParams = {[2.372120E-02]}; %% Changed G-I curve 6.506781e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QF31_MPW.Monitor.Physics2HWParams = {[2.372120E-02]}; %% Changed 1 ./ AO.QF31_MPW.Monitor.HW2PhysicsParams;
AO.QF31_MPW.Monitor.Units = 'Hardware';
AO.QF31_MPW.Monitor.HWUnits = 'Ampere';
AO.QF31_MPW.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF31_MPW.Setpoint.MemberOf = {'MachineConfig'};
AO.QF31_MPW.Setpoint.Mode = 'Simulator';
AO.QF31_MPW.Setpoint.DataType = 'Scalar';
AO.QF31_MPW.Setpoint.ChannelNames = getname_sps('QF31_MPW', 'Setpoint', AO.QF31_MPW.DeviceList);
AO.QF31_MPW.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QF31_MPW.Setpoint.Physics2HWFcn = @k2amp;
AO.QF31_MPW.Setpoint.HW2PhysicsParams = AO.QF31_MPW.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QF31_MPW.Setpoint.Physics2HWParams = AO.QF31_MPW.Monitor.Physics2HWParams;
%AO.QF31_MPW.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF31_MPW.Setpoint.Physics2HWFcn = @at2sps;
AO.QF31_MPW.Setpoint.Units = 'Hardware';
AO.QF31_MPW.Setpoint.HWUnits = 'Ampere';
AO.QF31_MPW.Setpoint.PhysicsUnits = '1/Meter^2';


% QF38
AO.QF38_MPW.FamilyName = 'QF38_MPW';
AO.QF38_MPW.MemberOf   = {'PlotFamily'; 'QF38_MPW'; 'QUAD'; 'Magnet'};
AO.QF38_MPW.DeviceList = [[1 1]];
AO.QF38_MPW.ElementList = (1:size(AO.QF38_MPW.DeviceList,1))';
AO.QF38_MPW.Status = ones(size(AO.QF38_MPW.DeviceList,1),1);

AO.QF38_MPW.Monitor.Mode = 'Simulator';
AO.QF38_MPW.Monitor.DataType = 'Scalar';
AO.QF38_MPW.Monitor.ChannelNames = getname_sps('QF38_MPW', 'Monitor', AO.QF38_MPW.DeviceList);
AO.QF38_MPW.Monitor.HW2PhysicsFcn = @amp2k;
AO.QF38_MPW.Monitor.Physics2HWFcn = @k2amp;
AO.QF38_MPW.Monitor.HW2PhysicsParams = {[2.372120E-02]}; %% Changed G-I curve 6.506781e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QF38_MPW.Monitor.Physics2HWParams = {[2.372120E-02]}; %% Changed 1 ./ AO.QF38_MPW.Monitor.HW2PhysicsParams;
AO.QF38_MPW.Monitor.Units = 'Hardware';
AO.QF38_MPW.Monitor.HWUnits = 'Ampere';
AO.QF38_MPW.Monitor.PhysicsUnits = '1/Meter^2';

AO.QF38_MPW.Setpoint.MemberOf = {'MachineConfig'};
AO.QF38_MPW.Setpoint.Mode = 'Simulator';
AO.QF38_MPW.Setpoint.DataType = 'Scalar';
AO.QF38_MPW.Setpoint.ChannelNames = getname_sps('QF38_MPW', 'Setpoint', AO.QF38_MPW.DeviceList);
AO.QF38_MPW.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QF38_MPW.Setpoint.Physics2HWFcn = @k2amp;
AO.QF38_MPW.Setpoint.HW2PhysicsParams = AO.QF38_MPW.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QF38_MPW.Setpoint.Physics2HWParams = AO.QF38_MPW.Monitor.Physics2HWParams;
%AO.QF38_MPW.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QF38_MPW.Setpoint.Physics2HWFcn = @at2sps;
AO.QF38_MPW.Setpoint.Units = 'Hardware';
AO.QF38_MPW.Setpoint.HWUnits = 'Ampere';
AO.QF38_MPW.Setpoint.PhysicsUnits = '1/Meter^2';


% QD4 Main Power Supply
AO.QDA.FamilyName = 'QDA';
AO.QDA.MemberOf   = {'PlotFamily'; 'QF'; 'QUAD'; 'Magnet'};
AO.QDA.DeviceList = OnePerSectorList;
AO.QDA.ElementList = (1:size(OnePerSectorList,1))';
AO.QDA.Status = ones(size(OnePerSectorList,1),1);

AO.QDA.Monitor.Mode = 'Simulator';
AO.QDA.Monitor.DataType = 'Scalar';
AO.QDA.Monitor.ChannelNames = getname_sps('QDA', 'Monitor', AO.QDA.DeviceList);
AO.QDA.Monitor.HW2PhysicsFcn = @amp2k;
AO.QDA.Monitor.Physics2HWFcn = @k2amp;
AO.QDA.Monitor.HW2PhysicsParams = {-1.*[-3.638883E-08 1.692212E-05 2.468770E-02 6.989091E-02]};%% Changed G-I curve -6.631929e-3;    % K/Ampere:  HW2Physics*Amps=K
AO.QDA.Monitor.Physics2HWParams = {-1.*[-3.638883E-08 1.692212E-05 2.468770E-02 6.989091E-02]};%% Changed 1 ./ AO.QDA.Monitor.HW2PhysicsParams;
AO.QDA.Monitor.Units = 'Hardware';
AO.QDA.Monitor.HWUnits = 'Ampere';
AO.QDA.Monitor.PhysicsUnits = '1/Meter^2';

AO.QDA.Setpoint.MemberOf = {'MachineConfig'};
AO.QDA.Setpoint.Mode = 'Simulator';
AO.QDA.Setpoint.DataType = 'Scalar';
AO.QDA.Setpoint.ChannelNames = getname_sps('QDA', 'Setpoint', AO.QDA.DeviceList);
AO.QDA.Setpoint.HW2PhysicsFcn = @amp2k;
AO.QDA.Setpoint.Physics2HWFcn = @k2amp;
AO.QDA.Setpoint.HW2PhysicsParams = AO.QDA.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.QDA.Setpoint.Physics2HWParams = AO.QDA.Monitor.Physics2HWParams;
%AO.QDA.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.QDA.Setpoint.Physics2HWFcn = @at2sps;
AO.QDA.Setpoint.Units = 'Hardware';
AO.QDA.Setpoint.HWUnits = 'Ampere';
AO.QDA.Setpoint.PhysicsUnits = '1/Meter^2';


% Sextupoles (SF)
AO.SF.FamilyName = 'SF';
AO.SF.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SF'; 'SEXT'; 'Magnet'};
AO.SF.DeviceList = TwoPerSectorList;
AO.SF.ElementList = (1:size(TwoPerSectorList,1))';
AO.SF.Status = ones(size(TwoPerSectorList,1),1);

AO.SF.Monitor.Mode = 'Simulator';
AO.SF.Monitor.DataType = 'Scalar';
AO.SF.Monitor.ChannelNames = getname_sps('SF', 'Monitor', AO.SF.DeviceList);
AO.SF.Monitor.HW2PhysicsParams = 1.3648334/2;%%1.367376/2;
AO.SF.Monitor.Physics2HWParams = 1 ./ AO.SF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
%AO.SF.Monitor.HW2PhysicsFcn = @sps2at;
%AO.SF.Monitor.Physics2HWFcn = @at2sps;
AO.SF.Monitor.Units = 'Hardware';
AO.SF.Monitor.HWUnits = 'Ampere';
AO.SF.Monitor.PhysicsUnits = '1/Meter^3';

AO.SF.Setpoint.MemberOf = {'MachineConfig';};
AO.SF.Setpoint.Mode = 'Simulator';
AO.SF.Setpoint.DataType = 'Scalar';
AO.SF.Setpoint.ChannelNames = getname_sps('SF', 'Setpoint', AO.SF.DeviceList);
AO.SF.Setpoint.HW2PhysicsParams = AO.SF.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.SF.Setpoint.Physics2HWParams = AO.SF.Monitor.Physics2HWParams;
%AO.SF.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.SF.Setpoint.Physics2HWFcn = @at2sps;
AO.SF.Setpoint.Units = 'Hardware';
AO.SF.Setpoint.HWUnits = 'Ampere';
AO.SF.Setpoint.PhysicsUnits = '1/Meter^3';

% Sextupoles (SD)
AO.SD.FamilyName = 'SD';
AO.SD.MemberOf   = {'PlotFamily'; 'Chromaticity Corrector'; 'SD'; 'SEXT'; 'Magnet'};
AO.SD.DeviceList = TwoPerSectorList;
AO.SD.ElementList = (1:size(TwoPerSectorList,1))';
AO.SD.Status = ones(size(TwoPerSectorList,1),1);

AO.SD.Monitor.Mode = 'Simulator';
AO.SD.Monitor.DataType = 'Scalar';
AO.SD.Monitor.ChannelNames = getname_sps('SD', 'Monitor', AO.SD.DeviceList);
AO.SD.Monitor.HW2PhysicsParams = -1.3461094/2;%%-1.37117/2;    % K/Ampere:  HW2Physics*Amps=K
AO.SD.Monitor.Physics2HWParams = 1 ./ AO.SD.Monitor.HW2PhysicsParams;
%AO.SD.Monitor.HW2PhysicsFcn = @sps2at;
%AO.SD.Monitor.Physics2HWFcn = @at2sps;
AO.SD.Monitor.Units = 'Hardware';
AO.SD.Monitor.HWUnits = 'Ampere';
AO.SD.Monitor.PhysicsUnits = '1/Meter^3';

AO.SD.Setpoint.MemberOf = {'MachineConfig';};
AO.SD.Setpoint.Mode = 'Simulator';
AO.SD.Setpoint.DataType = 'Scalar';
AO.SD.Setpoint.ChannelNames = getname_sps('SD', 'Setpoint', AO.SD.DeviceList);
AO.SD.Setpoint.HW2PhysicsParams = AO.SD.Monitor.HW2PhysicsParams;    % K/Ampere:  HW2Physics*Amps=K
AO.SD.Setpoint.Physics2HWParams = AO.SD.Monitor.Physics2HWParams;
%AO.SD.Setpoint.HW2PhysicsFcn = @sps2at;
%AO.SD.Setpoint.Physics2HWFcn = @at2sps;
AO.SD.Setpoint.Units = 'Hardware';
AO.SD.Setpoint.HWUnits = 'Ampere';
AO.SD.Setpoint.PhysicsUnits = '1/Meter^3';



% BEND
AO.BEND.FamilyName = 'BEND';
AO.BEND.MemberOf   = {'PlotFamily'; 'BEND'; 'Magnet'};
AO.BEND.DeviceList = TwoPerSectorList;
AO.BEND.ElementList = (1:size(TwoPerSectorList,1))';
AO.BEND.Status = ones(size(TwoPerSectorList,1),1);

AO.BEND.Monitor.Mode = 'Simulator';
AO.BEND.Monitor.DataType = 'Scalar';
AO.BEND.Monitor.ChannelNames = getname_sps('BEND', 'Monitor', AO.BEND.DeviceList);
AO.BEND.Monitor.HW2PhysicsFcn = @sps2at;
AO.BEND.Monitor.Physics2HWFcn = @at2sps;
AO.BEND.Monitor.Units = 'Hardware';
AO.BEND.Monitor.HWUnits = 'Ampere';
AO.BEND.Monitor.PhysicsUnits = 'Radian';

AO.BEND.Setpoint.MemberOf = {'MachineConfig';};
AO.BEND.Setpoint.Mode = 'Simulator';
AO.BEND.Setpoint.DataType = 'Scalar';
AO.BEND.Setpoint.ChannelNames = getname_sps('BEND', 'Setpoint', AO.BEND.DeviceList);
AO.BEND.Setpoint.HW2PhysicsFcn = @sps2at;
AO.BEND.Setpoint.Physics2HWFcn = @at2sps;
AO.BEND.Setpoint.Units = 'Hardware';
AO.BEND.Setpoint.HWUnits = 'Ampere';
AO.BEND.Setpoint.PhysicsUnits = 'Radian';


% RF
AO.RF.FamilyName = 'RF';
AO.RF.MemberOf   = {'MachineConfig'; 'RF'};
AO.RF.Status = 1;
AO.RF.DeviceList = [1 1];
AO.RF.ElementList = 1;

AO.RF.Monitor.Mode = 'Simulator'; 
AO.RF.Monitor.DataType = 'Scalar';
AO.RF.Monitor.ChannelNames = getname_sps('RF', 'Monitor', AO.RF.DeviceList);
AO.RF.Monitor.SpecialFunctionGet = 'getrf_sps';
AO.RF.Monitor.HW2PhysicsParams = 1e6;
AO.RF.Monitor.Physics2HWParams = 1/1e6;
AO.RF.Monitor.Units = 'Hardware';
AO.RF.Monitor.HWUnits       = 'MHz';
AO.RF.Monitor.PhysicsUnits  = 'Hz';

AO.RF.Setpoint.Mode = 'Simulator'; 
AO.RF.Setpoint.DataType = 'Scalar';
AO.RF.Setpoint.SpecialFunctionSet = 'setrf_sps';
AO.RF.Setpoint.SpecialFunctionGet = 'getrf_sps';
AO.RF.Setpoint.ChannelNames = getname_sps('RF', 'Setpoint', AO.RF.DeviceList);
AO.RF.Setpoint.HW2PhysicsParams = 1e6;
AO.RF.Setpoint.Physics2HWParams = 1/1e6;
AO.RF.Setpoint.Units = 'Hardware';
AO.RF.Setpoint.HWUnits      = 'MHz';
AO.RF.Setpoint.PhysicsUnits = 'Hz';
AO.RF.Setpoint.Range = [0 125];


% Tune
AO.TUNE.FamilyName = 'TUNE';
AO.TUNE.MemberOf   = {'TUNE'};
AO.TUNE.Status = [1;1;0];
AO.TUNE.Position = 0;
AO.TUNE.DeviceList = [1 1;1 2;1 3];
AO.TUNE.ElementList = [1;2;3];

AO.TUNE.Monitor.Mode = 'Simulator'; 
AO.TUNE.Monitor.DataType = 'Scalar';
%AO.TUNE.Monitor.ChannelNames = getname_sps('TUNE', 'Monitor', AO.RF.DeviceList);
AO.TUNE.Monitor.SpecialFunctionGet = 'gettune_sps';
AO.TUNE.Monitor.HW2PhysicsParams = 1;
AO.TUNE.Monitor.Physics2HWParams = 1;
AO.TUNE.Monitor.Units = 'Hardware';
AO.TUNE.Monitor.HWUnits = 'Tune';
AO.TUNE.Monitor.PhysicsUnits = 'Tune';


% DCCT
AO.DCCT.FamilyName = 'DCCT';
AO.DCCT.MemberOf = {};
AO.DCCT.Status = 1;
AO.DCCT.Position = 0;
AO.DCCT.DeviceList = [1 1];
AO.DCCT.ElementList = 1;
AO.DCCT.Monitor.Mode = 'Simulator';
AO.DCCT.Monitor.DataType = 'Scalar';
AO.DCCT.Monitor.ChannelNames = getname_sps('DCCT', 'Monitor', AO.DCCT.DeviceList);
AO.DCCT.Monitor.HW2PhysicsParams = 1;
AO.DCCT.Monitor.Physics2HWParams = 1;
AO.DCCT.Monitor.Units = 'Hardware';
AO.DCCT.Monitor.HWUnits = 'mAmps';
AO.DCCT.Monitor.PhysicsUnits = 'mAmps';


% Corrector OF MPW
AO.IDsHCM.FamilyName = 'IDsHCM';
AO.IDsHCM.MemberOf = {'IDsHCM'};
AO.IDsHCM.Status = 1;
AO.IDsHCM.Position = 0;
AO.IDsHCM.DeviceList = [1 1;1 2;2 1;2 2;];
AO.IDsHCM.ElementList = [1;2;3;4];

AO.IDsHCM.Monitor.Mode = 'Simulator';
AO.IDsHCM.Monitor.DataType = 'Scalar';
AO.IDsHCM.Monitor.ChannelNames = getname_sps('IDsHCM', 'Monitor', AO.IDsHCM.DeviceList);
AO.IDsHCM.Monitor.HW2PhysicsParams = [9.2252e-5 8.9440e-5 9.2252e-5 9.2252e-5]';
AO.IDsHCM.Monitor.Physics2HWParams = 1./AO.IDsHCM.Monitor.HW2PhysicsParams;
AO.IDsHCM.Monitor.HWUnits      = 'Ampere';
AO.IDsHCM.Monitor.PhysicsUnits = 'Radian';
AO.IDsHCM.Monitor.Units = 'Hardware';

AO.IDsHCM.Setpoint.Mode = 'Simulator';
AO.IDsHCM.Setpoint.DataType = 'Scalar';
AO.IDsHCM.Setpoint.ChannelNames = getname_sps('IDsHCM', 'Setpoint', AO.IDsHCM.DeviceList);
AO.IDsHCM.Setpoint.HW2PhysicsParams = AO.IDsHCM.Monitor.HW2PhysicsParams;
AO.IDsHCM.Setpoint.Physics2HWParams = 1./AO.IDsHCM.Monitor.Physics2HWParams;
AO.IDsHCM.Setpoint.HWUnits      = 'Ampere';
AO.IDsHCM.Setpoint.PhysicsUnits = 'Radian';
AO.IDsHCM.Setpoint.Units = 'Hardware';


% Corrector OF SWLS
AO.IDsVCM.FamilyName = 'IDsVCM';
AO.IDsVCM.MemberOf = {'IDsVCM'};
AO.IDsVCM.Position = 0;
AO.IDsVCM.Status = 1;
AO.IDsVCM.DeviceList = [1 1;1 2;2 1;2 2;];
AO.IDsVCM.ElementList = [1;2;3;4];

AO.IDsVCM.Monitor.Mode = 'Simulator';
AO.IDsVCM.Monitor.DataType = 'Scalar';
AO.IDsVCM.Monitor.ChannelNames = getname_sps('IDsVCM', 'Monitor', AO.IDsVCM.DeviceList);
AO.IDsVCM.Monitor.HW2PhysicsParams = [9.2252e-5 8.9440e-5 9.2252e-5 9.2252e-5]';
AO.IDsVCM.Monitor.Physics2HWParams = 1./AO.IDsVCM.Monitor.HW2PhysicsParams;
AO.IDsVCM.Monitor.HWUnits      = 'Ampere';
AO.IDsVCM.Monitor.PhysicsUnits = 'Radian';
AO.IDsVCM.Monitor.Units = 'Hardware';

AO.IDsVCM.Setpoint.Mode = 'Simulator';
AO.IDsVCM.Setpoint.DataType = 'Scalar';
AO.IDsVCM.Setpoint.ChannelNames = getname_sps('IDsVCM', 'Setpoint', AO.IDsVCM.DeviceList);
AO.IDsVCM.Setpoint.HW2PhysicsParams = AO.IDsVCM.Monitor.HW2PhysicsParams;
AO.IDsVCM.Setpoint.Physics2HWParams = 1./AO.IDsVCM.Monitor.Physics2HWParams;
AO.IDsVCM.Setpoint.HWUnits      = 'Ampere';
AO.IDsVCM.Setpoint.PhysicsUnits = 'Radian';
AO.IDsVCM.Setpoint.Units = 'Hardware';


% Side Coil of SWLS
AO.IDsSC.FamilyName = 'IDsSC';
AO.IDsSC.MemberOf = {'IDsSC'};
AO.IDsSC.Position = 0;
AO.IDsSC.Status = 1;
AO.IDsSC.DeviceList = [1 1;1 2];
AO.IDsSC.ElementList = [1;2];

AO.IDsSC.Monitor.Mode = 'Simulator';
AO.IDsSC.Monitor.DataType = 'Scalar';
AO.IDsSC.Monitor.ChannelNames = getname_sps('IDsSC', 'Monitor', AO.IDsSC.DeviceList);
AO.IDsSC.Monitor.HW2PhysicsParams = [1e-5 1e-5]';
AO.IDsSC.Monitor.Physics2HWParams = 1./AO.IDsSC.Monitor.HW2PhysicsParams;
AO.IDsSC.Monitor.HWUnits      = 'Ampere';
AO.IDsSC.Monitor.PhysicsUnits = 'Radian';
AO.IDsSC.Monitor.Units = 'Hardware';

AO.IDsSC.Setpoint.Mode = 'Simulator';
AO.IDsSC.Setpoint.DataType = 'Scalar';
AO.IDsSC.Setpoint.ChannelNames = getname_sps('IDsSC', 'Setpoint', AO.IDsSC.DeviceList);
AO.IDsSC.Setpoint.HW2PhysicsParams = AO.IDsSC.Monitor.HW2PhysicsParams;
AO.IDsSC.Setpoint.Physics2HWParams = 1./AO.IDsSC.Monitor.Physics2HWParams;
AO.IDsSC.Setpoint.HWUnits      = 'Ampere';
AO.IDsSC.Setpoint.PhysicsUnits = 'Radian';
AO.IDsSC.Setpoint.Units = 'Hardware';


% Long Coil of MPW
AO.IDsLC.FamilyName = 'IDsLC';
AO.IDsLC.MemberOf = {'IDsLC'};
AO.IDsLC.Position = 0;
AO.IDsLC.Status = 1;
AO.IDsLC.DeviceList = [1 1];
AO.IDsLC.ElementList = [1];

AO.IDsLC.Monitor.Mode = 'Simulator';
AO.IIDsLC.Monitor.DataType = 'Scalar';
AO.IDsLC.Monitor.ChannelNames = getname_sps('IDsLC', 'Monitor', AO.IDsLC.DeviceList);
AO.IDsLC.Monitor.HW2PhysicsParams = [1e-5]';
AO.IDsLC.Monitor.Physics2HWParams = 1./AO.IDsLC.Monitor.HW2PhysicsParams;
AO.IDsLC.Monitor.HWUnits      = 'Ampere';
AO.IDsLC.Monitor.PhysicsUnits = 'Radian';
AO.IDsLC.Monitor.Units = 'Hardware';

AO.IDsLC.Setpoint.Mode = 'Simulator';
AO.IDsLC.Setpoint.DataType = 'Scalar';
AO.IDsLC.Setpoint.ChannelNames = getname_sps('IDsLC', 'Setpoint', AO.IDsLC.DeviceList);
AO.IDsLC.Setpoint.HW2PhysicsParams = AO.IDsLC.Monitor.HW2PhysicsParams;
AO.IDsLC.Setpoint.Physics2HWParams = 1./AO.IDsLC.Monitor.Physics2HWParams;
AO.IDsLC.Setpoint.HWUnits      = 'Ampere';
AO.IDsLC.Setpoint.PhysicsUnits = 'Radian';
AO.IDsLC.Setpoint.Units = 'Hardware';


% Corrector of U60
AO.U60CM.FamilyName = 'U60CM';
AO.U60CM.MemberOf = {'U60CM'};
AO.U60CM.Position = 0;
AO.U60CM.Status = 1;
AO.U60CM.DeviceList = [1 1;1 2;2 1;2 2];
AO.U60CM.ElementList = [1;2;3;4];

AO.U60CM.Monitor.Mode = 'Simulator';
AO.U60CM.Monitor.DataType = 'Scalar';
AO.U60CM.Monitor.ChannelNames = getname_sps('U60CM', 'Monitor', AO.U60CM.DeviceList);
AO.U60CM.Monitor.HW2PhysicsParams = [1e-5 1e-5 1e-5 1e-5]';
AO.U60CM.Monitor.Physics2HWParams = 1./AO.U60CM.Monitor.HW2PhysicsParams;
AO.U60CM.Monitor.HWUnits      = 'Ampere';
AO.U60CM.Monitor.PhysicsUnits = 'Radian';
AO.U60CM.Monitor.Units = 'Hardware';

AO.U60CM.Setpoint.Mode = 'Simulator';
AO.U60CM.Setpoint.DataType = 'Scalar';
AO.U60CM.Setpoint.ChannelNames = getname_sps('U60CM', 'Setpoint', AO.U60CM.DeviceList);
AO.U60CM.Setpoint.HW2PhysicsParams = AO.U60CM.Monitor.HW2PhysicsParams;
AO.U60CM.Setpoint.Physics2HWParams = 1./AO.U60CM.Monitor.Physics2HWParams;
AO.U60CM.Setpoint.HWUnits      = 'Ampere';
AO.U60CM.Setpoint.PhysicsUnits = 'Radian';
AO.U60CM.Setpoint.Units = 'Hardware';


% The operational mode sets the path, filenames, and other important parameters
% Run setoperationalmode after most of the AO is built so that the Units and Mode fields
% can be set in setoperationalmode
setao(AO);
setoperationalmode(OperationalMode);
AO = getao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Range (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Range  = [local_minsp(AO.HCM.FamilyName, AO.HCM.DeviceList) local_maxsp(AO.HCM.FamilyName, AO.HCM.DeviceList)];
AO.VCM.Setpoint.Range  = [local_minsp(AO.VCM.FamilyName, AO.VCM.DeviceList) local_maxsp(AO.VCM.FamilyName, AO.VCM.DeviceList)];
AO.QF.Setpoint.Range   = [local_minsp(AO.QF.FamilyName)   local_maxsp(AO.QF.FamilyName)];
AO.QD.Setpoint.Range   = [local_minsp(AO.QD.FamilyName)   local_maxsp(AO.QD.FamilyName)];
AO.QFA.Setpoint.Range  = [local_minsp(AO.QFA.FamilyName)  local_maxsp(AO.QFA.FamilyName)];
AO.QDA.Setpoint.Range  = [local_minsp(AO.QDA.FamilyName)  local_maxsp(AO.QDA.FamilyName)];
AO.SF.Setpoint.Range   = [local_minsp(AO.SF.FamilyName)   local_maxsp(AO.SF.FamilyName)];
AO.SD.Setpoint.Range   = [local_minsp(AO.SD.FamilyName)   local_maxsp(AO.SD.FamilyName)];
AO.BEND.Setpoint.Range = [local_minsp(AO.BEND.FamilyName) local_maxsp(AO.BEND.FamilyName)];
AO.RF.Setpoint.Range   = [local_minsp(AO.RF.FamilyName)   local_maxsp(AO.RF.FamilyName)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tolerance (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.Tolerance  = gettol(AO.HCM.FamilyName);
AO.VCM.Setpoint.Tolerance  = gettol(AO.VCM.FamilyName);
AO.QF.Setpoint.Tolerance   = gettol(AO.QF.FamilyName);
AO.QD.Setpoint.Tolerance   = gettol(AO.QD.FamilyName);
AO.QFA.Setpoint.Tolerance  = gettol(AO.QF.FamilyName);
AO.QDA.Setpoint.Tolerance  = gettol(AO.QD.FamilyName);
AO.SF.Setpoint.Tolerance   = gettol(AO.SF.FamilyName);
AO.SD.Setpoint.Tolerance   = gettol(AO.SD.FamilyName);
AO.BEND.Setpoint.Tolerance = gettol(AO.BEND.FamilyName);
AO.RF.Setpoint.Tolerance   = gettol(AO.RF.FamilyName);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Response matrix kick size (must be hardware units) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AO.HCM.Setpoint.DeltaRespMat = physics2hw('HCM','Setpoint', .5e-4, AO.HCM.DeviceList, 'NoEnergyScaling');
AO.VCM.Setpoint.DeltaRespMat = physics2hw('VCM','Setpoint', .5e-4, AO.VCM.DeviceList, 'NoEnergyScaling');
AO.QF.Setpoint.DeltaRespMat  = 1;
AO.QD.Setpoint.DeltaRespMat  = 1;
AO.QFA.Setpoint.DeltaRespMat = 1;
AO.QDA.Setpoint.DeltaRespMat = 1;
AO.SF.Setpoint.DeltaRespMat  = 2;
AO.SD.Setpoint.DeltaRespMat  = 2;

setao(AO);




function [Amps] = local_minsp(Family, List)
%   local_minsp = local_minsp(Family, List {entire list});
%
%   Inputs:  Family must be a string (ex. 'HCM', 'VCM')
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
        Amps(i,1) = -33;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = -25;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QFA')
        Amps(i,1) = 0;
    elseif strcmp(Family,'QDA')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 0;
    elseif strcmp(Family,'SD')        
        Amps(i,1) = 0;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 0;
    elseif strcmp(Family,'RF')
        Amps(i,1) = 0;
    else
        fprintf('   Min setpoint unknown for %s family, hence set to -Inf.\n', Family);
        Amps(i,1) = -Inf;
    end
end


function [Amps] = local_maxsp(Family, List)
%   Amps = local_maxsp(Family, List {entire list});
%
%   Inputs:  Family must be a string (ex. 'HCM', 'VCM')
%            List or CMelem is the corrector magnet list (DevList or ElemList)
%
%   Output:  local_minsp is maximum strength for that family


% Input checking
if nargin < 1 || nargin > 2
    error('local_maxsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family,0);
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
        Amps(i,1) = 33;
    elseif strcmp(Family,'VCM')
        Amps(i,1) = 25;
    elseif strcmp(Family,'QF')
        Amps(i,1) = 500;
    elseif strcmp(Family,'QD')
        Amps(i,1) = 500;
    elseif strcmp(Family,'QFA')
        Amps(i,1) = 400;
    elseif strcmp(Family,'QDA')
        Amps(i,1) = 400;
    elseif strcmp(Family,'SF')
        Amps(i,1) = 31;
    elseif strcmp(Family,'SD')
        Amps(i,1) = 31;
    elseif strcmp(Family,'BEND')
        Amps(i,1) = 2000;
    elseif strcmp(Family,'RF')
        Amps(i,1) = 150e6;  % 150Mhz
    else
        fprintf('   Max setpoint unknown for %s family, hence set to Inf.\n', Family);
        Amps(i,1) = Inf;
    end
end


function tol = gettol(Family)
%  tol = gettol(Family)
%  tolerance on the SP-AM for that family
%
%  Note: the real tolerance is in gplink
%

% Input checking
if nargin < 1 || nargin > 2
    error('local_maxsp: Must have at least 1 input (''Family'')');
elseif nargin == 1
    List = family2dev(Family,0);
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


if strcmp(Family,'HCM')
    tol = 0.25;
elseif strcmp(Family,'VCM')
    tol = 0.15;
elseif strcmp(Family,'QF')
    tol = 1.0;
elseif strcmp(Family,'QD')
    tol = 2.5;
elseif strcmp(Family,'QFA')
    tol = 2.5;
elseif strcmp(Family,'QDA')
    tol = 2.5;
elseif strcmp(Family,'SQSF')
    tol = 0.25;
elseif strcmp(Family,'SQSD')
    tol = 0.25;
elseif strcmp(Family,'SF')
    tol = 0.15;
elseif strcmp(Family,'SD')
    tol = 0.1;
elseif strcmp(Family,'BEND')
    tol = 0.5;
elseif strcmp(Family,'RF')
    tol = 0.5;
else
    fprintf('   Tolerance unknown for %s family, hence set to zero.\n', Family);
    tol = 0;
end

tol = tol * ones(size(List,1),1);