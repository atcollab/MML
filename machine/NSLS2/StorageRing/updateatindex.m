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
    % Closed orbits
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';

    % Turn-by-turn 
    AO.BPMx.TBT.AT = AO.BPMx.AT;
    AO.BPMx.TBT.AT.ATType = 'xTurns';
    AO.BPMy.TBT.AT = AO.BPMy.AT;
    AO.BPMy.TBT.AT.ATType = 'yTurns';
catch
    warning('BPM family not found in the model.');
end

try
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.CH);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.CV);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end

% SKEW QUADRUPOLES
ATType = 'SKEWQUAD';
Family = findmemberof(ATType);
for i = 1:length(Family)
    try
        AO.(Family{i}).AT.ATType = ATType;
        AO.(Family{i}).AT.ATIndex = buildatindex(AO.(Family{i}).FamilyName, Indices.(Family{i}));
        AO.(Family{i}).Position = findspos(THERING, AO.(Family{i}).AT.ATIndex(:,1))';
    catch
        warning('%s family not found in the model.', Family{i});
    end
end


% QUADRUPOLES
ATType = 'QUAD';
Family = findmemberof(ATType);
for i = 1:length(Family)
    try
        AO.(Family{i}).AT.ATType = ATType;
        AO.(Family{i}).AT.ATIndex = buildatindex(AO.(Family{i}).FamilyName, Indices.(Family{i}));
        AO.(Family{i}).Position = findspos(THERING, AO.(Family{i}).AT.ATIndex(:,1))';
    catch
        warning('%s family not found in the model.', Family{i});
    end
end

% SEXTUPOLES
ATType = 'SEXT';
Family = findmemberof(ATType);
for i = 1:length(Family)
    try
        AO.(Family{i}).AT.ATType = ATType;
        AO.(Family{i}).AT.ATIndex = buildatindex(AO.(Family{i}).FamilyName, Indices.(Family{i}));
        AO.(Family{i}).Position = findspos(THERING, AO.(Family{i}).AT.ATIndex(:,1))';
    catch
        warning('%s family not found in the model.', Family{i});
    end
end


% BEND
try
    AO.BEND.AT.ATType = ATType;
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND);
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
    TwissData.beta  = [21.284783438966571 10.110278470803500]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end
