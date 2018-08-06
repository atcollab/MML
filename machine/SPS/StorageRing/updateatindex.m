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


% BPM
try
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
catch
    warning('BPM family not found in the model.');
end

try
    % Horizontal correctors are at every AT corrector
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.CORH);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    % Not all correctors are vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.CORV);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end


% QUADRUPOLES
try
    AO.QF.AT.ATType = 'QUAD';
    AO.QF.AT.ATIndex = buildatindex(AO.QF.FamilyName, Indices.QF);
    AO.QF.Position = findspos(THERING, AO.QF.AT.ATIndex(:,1))';

    AO.QD.AT.ATType = 'QUAD';
    AO.QD.AT.ATIndex = buildatindex(AO.QD.FamilyName, Indices.QD);
    AO.QD.Position = findspos(THERING, AO.QD.AT.ATIndex(:,1))';
    
    
catch
    warning('QF or QD family not found in the model.');
end

try
    AO.QFA.AT.ATType = 'QUAD';
    AO.QFA.AT.ATIndex = buildatindex(AO.QFA.FamilyName, Indices.QFA);
    AO.QFA.Position = findspos(THERING, AO.QFA.AT.ATIndex)';
catch
    warning('QFA family not found in the model.');
end

try
    AO.QDA.AT.ATType = 'QUAD';
    AO.QDA.AT.ATIndex = buildatindex(AO.QDA.FamilyName, Indices.QDA);
    AO.QDA.Position = findspos(THERING, AO.QDA.AT.ATIndex(:,1))';
catch
    warning('QDA family not found in the model.');
end


% SEXTUPOLES
try
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, Indices.SF);
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex(:,1))';

    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, Indices.SD);
    AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex(:,1))';

    %AO.SQSF.AT.ATType = 'SkewQuad';
    %AO.SQSF.AT.ATIndex = buildatindex(AO.SQSF.FamilyName, Indices.SF);
    %AO.SQSF.Position = findspos(THERING, AO.SQSF.AT.ATIndex(:,1))';
    %
    %AO.SQSD.AT.ATType = 'SkewQuad';
    %AO.SQSD.AT.ATIndex = buildatindex(AO.SQSD.FamilyName, Indices.SD);
    %AO.SQSD.Position = findspos(THERING, AO.SQSD.AT.ATIndex(:,1))';
catch
    warning('Sextupole families not found in the model.');
end


% BEND
try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BM(:));
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end


% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end


setao(AO);

