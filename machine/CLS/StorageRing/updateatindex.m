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
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.COR);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';

    % Vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = AO.HCM.AT.ATIndex;
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';
catch
    fprintf('   COR family not found in the model.\n');
end


try
    AO.QFA.AT.ATType = 'QUAD';
    ATIndex = [Indices.QFA(:)];
    AO.QFA.AT.ATIndex  = sort(ATIndex);
    %AO.QFA.AT.ATIndex = buildatindex(AO.QFA.FamilyName, Indices.QFA);
    AO.QFA.Position = findspos(THERING, AO.QFA.AT.ATIndex(:,1))';
catch
    fprintf('   QFA family not found in the model.\n');
end
try
    AO.QFB.AT.ATType = 'QUAD';
    ATIndex = [Indices.QFB(:)];
    AO.QFB.AT.ATIndex  = sort(ATIndex);
    %AO.QFB.AT.ATIndex = buildatindex(AO.QFB.FamilyName, Indices.QFB);
    AO.QFB.Position = findspos(THERING, AO.QFB.AT.ATIndex(:,1))';
catch
    fprintf('   QFB family not found in the model.\n');
end
try
    AO.QFC.AT.ATType = 'QUAD';
    ATIndex = [Indices.QFC(:)];
    AO.QFC.AT.ATIndex  = sort(ATIndex);
    %AO.QFC.AT.ATIndex = buildatindex(AO.QFC.FamilyName, Indices.QFC);
    AO.QFC.Position = findspos(THERING, AO.QFC.AT.ATIndex(:,1))';
catch
    fprintf('   QFC family not found in the model.\n');
end


try
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, Indices.SF);
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex(:,1))';
catch
    fprintf('   SF family not found in the model.\n');
end
try
    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, Indices.SD);
    AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex(:,1))';
catch
    fprintf('   SD family not found in the model.\n');
end


try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND);
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    fprintf('   BEND family not found in the model.\n');
end

try
    %RF Cavity
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    fprintf('   RF cavity not found in the model.\n');
end


setao(AO);

