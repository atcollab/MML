function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

AO = getao;

AO.BPMx.AT.ATType = 'X';
AO.BPMx.AT.ATIndex = findcells(THERING,'FamName','BPM')';

AO.BPMy.AT.ATType = 'Y';
AO.BPMy.AT.ATIndex = findcells(THERING,'FamName','BPM')';

AO.HCM.AT.ATType = 'HCM';
AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, 'HCOR');

AO.VCM.AT.ATType = 'VCM';
AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, 'VCOR');

AO.QA.AT.ATType = 'QUAD';
AO.QA.AT.ATIndex = buildatindex(AO.QA.FamilyName, 'QA');
AO.QB.AT.ATType = 'QUAD';
AO.QB.AT.ATIndex = buildatindex(AO.QB.FamilyName, 'QB');
AO.QC.AT.ATType = 'QUAD';
AO.QC.AT.ATIndex = buildatindex(AO.QC.FamilyName, 'QC');
AO.QD.AT.ATType = 'QUAD';
AO.QD.AT.ATIndex = buildatindex(AO.QD.FamilyName, 'QD');
AO.QDT.AT.ATType = 'TRIMQUAD';
AO.QDT.AT.ATIndex = buildatindex(AO.QDT.FamilyName, 'QD');

AO.SQ.AT.ATType = 'SKEWQUAD';
AO.SQ.AT.ATIndex = buildatindex(AO.SQ.FamilyName, 'SQ');

AO.SF.AT.ATType = 'SEXT';
AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, 'SF');

AO.SD.AT.ATType = 'SEXT';
AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, 'SD');

AO.BEND.AT.ATType = 'BEND';
AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, 'BEND');

AO.RF.AT.ATType = 'RF';
AO.RF.AT.ATIndex = findcells(THERING,'FamName','RF')';


%%%%%%%%%%%%%%%%%%%
% Get S-positions %
%%%%%%%%%%%%%%%%%%%
AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';
AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';

AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';
AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';

AO.QA.Position = findspos(THERING, AO.QA.AT.ATIndex)';
AO.QB.Position = findspos(THERING, AO.QB.AT.ATIndex)';
AO.QC.Position = findspos(THERING, AO.QC.AT.ATIndex)';
AO.QD.Position = findspos(THERING, AO.QD.AT.ATIndex)';
AO.QDT.Position = findspos(THERING, AO.QDT.AT.ATIndex)';

AO.SQ.Position = findspos(THERING, AO.SQ.AT.ATIndex)';

AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex)';
AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex)';

% RF may not be in the AT model
if isempty(AO.RF.AT.ATIndex)
    AO.RF.Position = 0;
else
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex)';
end


setao(AO);

