function OutStruct = buildmmlllrf(Family, DeviceList)
% MML Setup for LLRF 
%

Family = 'LLRF';
DeviceList = [1 1; 1 2; 1 3; 1 4; 1 5;];
N = size(DeviceList,1);

%OutStruct = buildmmlfamily(Family, DeviceList);
OutStruct.FamilyName  = Family;
OutStruct.MemberOf    = {'RF'; 'LLRF';};
OutStruct.Status      = ones(N,1);
OutStruct.DeviceList  = DeviceList;
OutStruct.CommonNames  = {};
OutStruct.ElementList = (1:N)';
OutStruct.Position    = (1:N)';

OutStruct.CommonNames{1,1} = 'llrf1';
OutStruct.CommonNames{2,1} = 'llrf1molk1';
OutStruct.CommonNames{3,1} = 'llrf1molk2';
OutStruct.CommonNames{4,1} = 'llrf2molk1';
OutStruct.CommonNames{5,1} = 'llrf2molk2';

Fields = {'w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8'};
for j = 1:length(Fields)
    OutStruct.(Fields{j}).MemberOf = {'RF'; 'LLRF'; 'Monitor'; 'PlotFamily';};
    OutStruct.(Fields{j}).DataType = 'Waveform';
    OutStruct.(Fields{j}).ChannelNames = {};
    OutStruct.(Fields{j}).Mode = 'Online';
    OutStruct.(Fields{j}).Units = 'Hardware';
    OutStruct.(Fields{j}).HW2PhysicsParams = 1;
    OutStruct.(Fields{j}).Physics2HWParams = 1;
    OutStruct.(Fields{j}).HWUnits      = '';
    OutStruct.(Fields{j}).PhysicsUnits = '';
    
    for i = 1:length(OutStruct.CommonNames)
        OutStruct.(Fields{j}).ChannelNames{i,1} = sprintf('%s:%s', OutStruct.CommonNames{i}, Fields{j});
    end
end


% w9 -> 1 to 32???

% OutStruct.Monitor.HWUnits      = 'Amps';
% OutStruct.Monitor.PhysicsUnits = 'Radians';
% OutStruct.Setpoint.HWUnits      = 'Amps';
% OutStruct.Setpoint.PhysicsUnits = 'Radians';
% OutStruct.Setpoint.Range = [-ones(N,1) ones(N,1)] * Range;
% OutStruct.Setpoint.Tolerance = .1 * ones(N,1);

%OutStruct.Setpoint.SpecialFunctionSet = @setrf_apex;
%OutStruct.Setpoint.SpecialFunctionGet = @getrf_apex;

% HW2PhysicsParams = 1;
% Physics2HWParams = 1;
% HWUnits      = '';
% PhysicsUnits = '';
% 
% Output.MemberOf         = MemberOf;
% Output.Mode             = 'Online';     % 'Online' 'Simulator', 'Manual' or 'Special'
% Output.DataType         = 'Scalar';
% %Output.Status           = ones(N,1);
% %Output.DeviceList       = [ones(N,1) (1:N)'];
% %Output.ElementList      = (1:N)';
% Output.ChannelNames     = ChannelNames;
% Output.HW2PhysicsParams = HW2PhysicsParams;
% Output.Physics2HWParams = Physics2HWParams;
% Output.Units            = 'Hardware';
% Output.HWUnits          = HWUnits;
% Output.PhysicsUnits     = PhysicsUnits;
