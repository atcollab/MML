function setgainsandoffsets

AO = getao;

[SP, AM] = getproductionlattice;

% Fields to correct (All => fieldnames(SP);)
Fields = {    
    %'HCM'  % Note: correctors likely have an offset correction already, 
    %'VCM'  %       so don't add a gain without taking that into account
    'QF'
    'QD'
    %'QFA'
    'QDA'
    %'SF'
    %'SD'
    %'SQSF'
    %'SQSD'
    %'BEND'
    };

% Set the monitors gain to match the SP at the production lattice values
for i = 1:length(Fields)
    
    Gain = SP.(Fields{i}).Setpoint.Data ./ AM.(Fields{i}).Monitor.Data;
    
    % Gain (look for magnets that have been removed)
    AO.(Fields{i}).Monitor.Gain = ones(size(AO.(Fields{i}).DeviceList,1),1);
    j = findrowindex(SP.(Fields{i}).Setpoint.DeviceList, AO.(Fields{i}).DeviceList);
    AO.(Fields{i}).Monitor.Gain(j) = Gain;
    
    % Offset is zero (for now)
    AO.(Fields{i}).Monitor.Offset = zeros(size(AO.(Fields{i}).DeviceList,1),1);
end

setao(AO);

