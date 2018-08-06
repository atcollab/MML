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
    hvbpmlist = findcells(THERING, 'Name', 'BPM');
    hbpmlist = findcells(THERING, 'Name', 'HBPM');
    vbpmlist = findcells(THERING, 'Name', 'VBPM');
    BPMData.BPMIndex = sort([hvbpmlist hbpmlist vbpmlist]);
    BPMData.BPMIndex = BPMData.BPMIndex(:);

    BPMData.HBPMIndex = [];
    listtmp = sort([hvbpmlist hbpmlist]);
    for loop = 1:length(listtmp)
        BPMData.HBPMIndex = [BPMData.HBPMIndex find(listtmp(loop)==BPMData.BPMIndex)];
    end
    BPMData.HBPMIndex = sort(BPMData.HBPMIndex);    % Must match the response matrix

    BPMData.VBPMIndex = [];
    listtmp = sort([hvbpmlist vbpmlist]);
    for loop = 1:length(listtmp)
        BPMData.VBPMIndex = [BPMData.VBPMIndex find(listtmp(loop)==BPMData.BPMIndex)];
    end
    BPMData.VBPMIndex = sort(BPMData.VBPMIndex);    % Must match the response matrix

    AO.BPMx.AT.ATType = 'X';
    %AO.BPMx.AT.ATIndex = findcells(THERING,'Name','BPM')';
    AO.BPMx.AT.ATIndex = BPMData.BPMIndex(BPMData.HBPMIndex);
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    %AO.BPMy.AT.ATIndex = findcells(THERING,'Name','BPM')';
    AO.BPMy.AT.ATIndex = BPMData.BPMIndex(BPMData.VBPMIndex);
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
catch
    warning('BPM family not found in the model.');
end

try
    % Horizontal and vertical correctors
    corrlist = findcells(THERING, 'PassMethod', 'CorrectorPass');
    xcorr = [];
    ycorr = [];
    for loop=1:length(corrlist)
        if (THERING{corrlist(loop)}.FamName(1) == 'X') & ...
                (THERING{corrlist(loop)}.FamName(8) == 'T')
            xcorr = [xcorr corrlist(loop)];
        elseif (THERING{corrlist(loop)}.FamName(1) == 'Y') & ...
                (THERING{corrlist(loop)}.FamName(8) == 'T')
            ycorr = [ycorr corrlist(loop)];
        end
    end

    
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = xcorr(:);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex)';

    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = ycorr(:);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex)';
catch
    warning('COR family not found in the model.');
end


try
    AO.QF.AT.ATType = 'QUAD';
    AO.QF.AT.ATIndex = findcells(THERING,'FamName','QF')';
    AO.QF.Position = findspos(THERING, AO.QF.AT.ATIndex)';

    AO.QD.AT.ATType = 'QUAD';
    AO.QD.AT.ATIndex = findcells(THERING,'FamName','QD')';
    AO.QD.Position = findspos(THERING, AO.QD.AT.ATIndex)';
catch
    warning('QUAD family not found in the model.');
end

try
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, Indices.SF);
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex(:,1))';

    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, Indices.SD);
    AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex(:,1))';
catch
    warning('Sextupole families not found in the model.');
end

try
%     AO.SQSF.AT.ATType = 'SkewQuad';
%     AO.SQSF.AT.ATIndex = buildatindex(AO.SQSF.FamilyName, Indices.SF);
%     AO.SQSF.Position = findspos(THERING, AO.SQSF.AT.ATIndex(:,1))';
% 
%     AO.SQSD.AT.ATType = 'SkewQuad';
%     AO.SQSD.AT.ATIndex = buildatindex(AO.SQSD.FamilyName, Indices.SD);
%     AO.SQSD.Position = findspos(THERING, AO.SQSD.AT.ATIndex(:,1))';
catch
    warning('Skeq quadrupole families not found in the model.');
end

% try
%     AO.QFA.AT.ATType = 'QUAD';
%     AO.QFA.AT.ATIndex = buildatindex(AO.QFA.FamilyName, Indices.QFA);
%     AO.QFA.Position = findspos(THERING, AO.QFA.AT.ATIndex)';
% catch
%     warning('QFA family not found in the model.');
% end
% 
% try
%     AO.QDA.AT.ATType = 'QUAD';
%     AO.QDA.AT.ATIndex = buildatindex(AO.QDA.FamilyName, Indices.QDA);
%     AO.QDA.Position = findspos(THERING, AO.QDA.AT.ATIndex)';
% catch
%     warning('QDA family not found in the model.');
% end

try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = findcells(THERING,'FamName','B')';
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex)';
catch
    warning('BEND family not found in the model.');
end


try
    %RF Cavity - Treat like a split family
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency');
    AO.RF.AT.ATIndex = AO.RF.AT.ATIndex(:)';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex);
    AO.RF.Position = AO.RF.Position(1);
catch
    warning('RF cavity not found in the model.');
end


setao(AO);




% Position at the center of the magnet
% AO.HCM.Position = (findspos(THERING, AO.HCM.AT.ATIndex)+findspos(THERING, AO.HCM.AT.ATIndex+1))'/2;
% AO.VCM.Position = (findspos(THERING, AO.VCM.AT.ATIndex)+findspos(THERING, AO.VCM.AT.ATIndex+1))'/2;
% AO.QF.Position = (findspos(THERING, AO.QF.AT.ATIndex)+findspos(THERING, AO.QF.AT.ATIndex+1))'/2;
% AO.QD.Position = (findspos(THERING, AO.QD.AT.ATIndex)+findspos(THERING, AO.QD.AT.ATIndex+1))'/2;
% AO.QFA.Position = (findspos(THERING, AO.QFA.AT.ATIndex)+findspos(THERING, AO.QFA.AT.ATIndex+1))'/2;
% AO.QDA.Position = (findspos(THERING, AO.QDA.AT.ATIndex)+findspos(THERING, AO.QDA.AT.ATIndex+1))'/2;
% AO.SF.Position = (findspos(THERING, AO.SF.AT.ATIndex(:,1))+findspos(THERING, AO.SF.AT.ATIndex(:,end)+1))'/2;
% AO.SD.Position = (findspos(THERING, AO.SD.AT.ATIndex(:,1))+findspos(THERING, AO.SD.AT.ATIndex(:,end)+1))'/2;
% AO.SQSF.Position = (findspos(THERING, AO.SQSF.AT.ATIndex(:,1))+findspos(THERING, AO.SQSF.AT.ATIndex(:,end)+1))'/2;
% AO.SQSD.Position = (findspos(THERING, AO.SQSD.AT.ATIndex(:,1))+findspos(THERING, AO.SQSD.AT.ATIndex(:,end)+1))'/2;
% AO.BEND.Position = (findspos(THERING, AO.BEND.AT.ATIndex)+findspos(THERING, AO.BEND.AT.ATIndex+1))'/2;
% AO.BSC.Position = (findspos(THERING, AO.BSC.AT.ATIndex)+findspos(THERING, AO.BSC.AT.ATIndex+1))'/2;
