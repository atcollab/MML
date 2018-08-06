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
    AO.BPMx.AT.ATIndex = Indices.bpmhv(:); % findcells(THERING,'FamName','bpmhv')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = Indices.bpmhv(:); % findcells(THERING,'FamName','bpmhv')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
catch
    warning('BPM family not found in the model.');
end

try
    % Horizontal correctors are at every AT corrector
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.corrh);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    % Not all correctors are vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.corrv);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end


% QUADRUPOLES
try
    AO.QFI.AT.ATType = 'QUAD';
    AO.QFI.AT.ATIndex = buildatindex(AO.QFI.FamilyName, Indices.sqfi);
    AO.QFI.Position = findspos(THERING, AO.QFI.AT.ATIndex(:,1))';

    AO.QFO.AT.ATType = 'QUAD';
    AO.QFO.AT.ATIndex = buildatindex(AO.QFO.FamilyName, Indices.sqfo);
    AO.QFO.Position = findspos(THERING, AO.QFO.AT.ATIndex(:,1))';
catch
    warning('QFI or QFO family not found in the model.');
end


% SEXTUPOLES
try
    AO.SFI.AT.ATType = 'SEXT';
    AO.SFI.AT.ATIndex = buildatindex(AO.SFI.FamilyName, Indices.sci);
    AO.SFI.Position = findspos(THERING, AO.SFI.AT.ATIndex(:,1))';

    AO.SFO.AT.ATType = 'SEXT';
    AO.SFO.AT.ATIndex = buildatindex(AO.SFO.FamilyName, Indices.sco);
    AO.SFO.Position = findspos(THERING, AO.SFO.AT.ATIndex(:,1))';
catch
    warning('Sextupole families not found in the model.');
end


% BEND
try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.B(:));
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



% Set TwissData at the start of the storage ring
try   
    % BTS twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [5.6916 2.8372]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end

