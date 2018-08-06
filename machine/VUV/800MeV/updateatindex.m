function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

AO = getao;

%BPMS
AO.BPMx.AT.ATType  = 'X';
AO.BPMx.AT.ATIndex = findcells(THERING,'FamName','BPM')';

AO.BPMy.AT.ATType  = 'Y';
AO.BPMy.AT.ATIndex = findcells(THERING,'FamName','BPM')';

%CORRECTORS
AO.HCM.AT.ATType  = 'HCM';
AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, 'HCOR');

AO.VCM.AT.ATType = 'VCM';
AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, 'VCOR');

%QUADRUPOLES
AO.Q1.AT.ATType = 'QUAD';
AO.Q1.AT.ATIndex = buildatindex(AO.Q1.FamilyName, 'Q1');
AO.Q2.AT.ATType = 'QUAD';
AO.Q2.AT.ATIndex = buildatindex(AO.Q2.FamilyName, 'Q2');
AO.Q3.AT.ATType = 'QUAD';
AO.Q3.AT.ATIndex = buildatindex(AO.Q3.FamilyName, 'Q3');
AO.Q4.AT.ATType = 'QUAD';
AO.Q4.AT.ATIndex = buildatindex(AO.Q4.FamilyName, 'Q4');
AO.Q5.AT.ATType = 'QUAD';
AO.Q5.AT.ATIndex = buildatindex(AO.Q5.FamilyName, 'Q5');
AO.Q6.AT.ATType = 'QUAD';
AO.Q6.AT.ATIndex = buildatindex(AO.Q6.FamilyName, 'Q6');
AO.Q7.AT.ATType = 'QUAD';
AO.Q7.AT.ATIndex = buildatindex(AO.Q7.FamilyName, 'Q7');

%SEXTUPOLES
AO.SF.AT.ATType = 'SEXT';
AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, 'SF');

AO.SD.AT.ATType = 'SEXT';
AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, 'SD');

% BEND
AO.BEND.AT.ATType = 'BEND';
AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, 'BEND');

%RF
AO.RF.AT.ATType = 'RF';
AO.RF.AT.ATIndex = findcells(THERING,'FamName','RF')';


%%%%%%%%%%%%%%%%%%%
% Get S-positions %
%%%%%%%%%%%%%%%%%%%
AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';
AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';

AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';
AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';

AO.Q1.Position = findspos(THERING, AO.Q1.AT.ATIndex)';
AO.Q2.Position = findspos(THERING, AO.Q2.AT.ATIndex)';
AO.Q3.Position = findspos(THERING, AO.Q3.AT.ATIndex)';
AO.Q4.Position = findspos(THERING, AO.Q4.AT.ATIndex)';
AO.Q5.Position = findspos(THERING, AO.Q5.AT.ATIndex)';
AO.Q6.Position = findspos(THERING, AO.Q6.AT.ATIndex)';
AO.Q7.Position = findspos(THERING, AO.Q7.AT.ATIndex)';

AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex)';
AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex)';

% RF may not be in the AT model
if isempty(AO.RF.AT.ATIndex)
    AO.RF.Position = 0;
else
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex)';
end


setao(AO);



% Set TwissData at the start of the storage ring
try
    
    % BTS twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [13.3155 6.6688]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0.0455 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;

catch
     warning('Setting the twiss data parameters in the MML failed.');
end
