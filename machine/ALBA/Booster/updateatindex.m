function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)

global THERING

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

% Sort by family first (findcells is linear and slow)
Indices = atindex(THERING);

AO = getao;



try
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
catch
    fprintf('   BPM family not found in the model.\n');
end

try
    % Horizontal correctors
    AO.HCM.AT.ATType  = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HCM);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';
    
    % Vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.VCM);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';
catch
    fprintf('   COR family not found in the model.\n');
end

try
    AO.QF1.AT.ATType = 'QUAD';
    ATIndex = [Indices.QF1(:)];
    AO.QF1.AT.ATIndex  = sort(ATIndex);
    %AO.QF1.AT.ATIndex = buildatindex(AO.QF1.FamilyName, Indices.QF1);
    AO.QF1.Position = findspos(THERING, AO.QF1.AT.ATIndex)';
catch
    fprintf('   QF1 family not found in the model.\n');
end

try
    AO.QF2.AT.ATType = 'QUAD';
    ATIndex = [Indices.QF2(:)];
    AO.QF2.AT.ATIndex  = sort(ATIndex);
    %AO.QF2.AT.ATIndex = buildatindex(AO.QF2.FamilyName, Indices.QF2);
    AO.QF2.Position = findspos(THERING, AO.QF2.AT.ATIndex)';
catch
    fprintf('   QF2 family not found in the model.\n');
end

try
    AO.QD1.AT.ATType = 'QUAD';
    ATIndex = [Indices.QD1(:)];
    AO.QD1.AT.ATIndex  = sort(ATIndex);
    %AO.QD1.AT.ATIndex = buildatindex(AO.QD1.FamilyName, Indices.QD1);
    AO.QD1.Position = findspos(THERING, AO.QD1.AT.ATIndex)';
catch
    fprintf('   QD1 family not found in the model.\n');
end
try
    AO.QD2.AT.ATType = 'QUAD';
    ATIndex = [Indices.QD2(:)];
    AO.QD2.AT.ATIndex  = sort(ATIndex);
    %AO.QD2.AT.ATIndex = buildatindex(AO.QD2.FamilyName, Indices.QD2);
    AO.QD2.Position = findspos(THERING, AO.QD2.AT.ATIndex)';
catch
    fprintf('   QD2 family not found in the model.\n');
end

try
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, Indices.SF);
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex)';
catch
    fprintf('   SF family not found in the model.\n');
end
try
    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, Indices.SD);
    AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex)';
catch
    fprintf('   SD family not found in the model.\n');
end

try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND);
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex)';
catch
    fprintf('   BEND family not found in the model.\n');
end

try
    %RF Cavity
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex)';
catch
    fprintf('   RF cavity not found in the model.\n');
end


setao(AO);




% Set TwissData at the start of the storage ring
try   
    % BTS twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [11.1966 5.9268]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0.1459 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end
