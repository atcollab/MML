function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)

%
% Adapted by Laurent S. Nadolski

global THERING

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

% Sort by family first (findcells is linear and slow)
Indices = atindex(THERING);

AO = getao;

% BPMS
try
    ifam = 'BPMx';
    AO.(ifam).AT.ATType = 'X';
    AO.(ifam).AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.(ifam).Position = findspos(THERING, AO.(ifam).AT.ATIndex)';

    ifam = 'BPMz';
    AO.(ifam).AT.ATType = 'Z';
    AO.(ifam).AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.(ifam).Position = findspos(THERING, AO.(ifam).AT.ATIndex)';
catch
    warning('BPM family not found in the model.');
end


% CORRECTORS
try
    ifam = 'HCOR';
    % Horizontal correctors are at every AT corrector
    AO.(ifam).AT.ATType = ifam;
    AO.(ifam).AT.ATIndex = buildatindex(AO.(ifam).FamilyName, Indices.COR);
    AO.(ifam).Position = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';

    % Vertical correctors are at every AT corrector
    ifam = 'VCOR';
    AO.(ifam).AT.ATType = ifam;
    AO.(ifam).AT.ATIndex = buildatindex(AO.(ifam).FamilyName, Indices.COR);
    AO.(ifam).Position = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';

    % Fast Horizontal correctors are at every AT corrector
    ifam = 'FHCOR';
    AO.(ifam).AT.ATType = ifam;
    AO.(ifam).AT.ATIndex = buildatindex(AO.(ifam).FamilyName, Indices.COR);
    AO.(ifam).Position = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';

    % Fast vertical correctors are at every AT corrector
    ifam = 'FVCOR';
    AO.(ifam).AT.ATType = ifam;
    AO.(ifam).AT.ATIndex = buildatindex(AO.(ifam).FamilyName, Indices.COR);
    AO.(ifam).Position = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end


% QUADRUPOLES
try
    for k = 1:10,
        ifam = ['Q' num2str(k)];
        AO.(ifam).AT.ATType = 'QUAD';
        AO.(ifam).AT.ATIndex = buildatindex(AO.(ifam).FamilyName, Indices.(ifam));
        AO.(ifam).Position = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';
    end
catch
    warning('%s family not found in the model.',ifam);
end


% SEXTUPOLES
try
    for k = 1:10,
        ifam = ['S' num2str(k)];
        AO.(ifam).AT.ATType = 'SEXT';
        AO.(ifam).AT.ATIndex = buildatindex(AO.(ifam).FamilyName, Indices.(ifam));
        AO.(ifam).Position = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';
    end
catch
    warning('Sextupole families not found in the model.');
end


% BEND

try
    % Combine BEND    
    AO.BEND.AT.ATType = 'BEND';
    ATIndex = Indices.BEND(:);
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, sort(ATIndex));
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end

% RF CAVITY
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
    TwissData.beta  = [13.8467 2.2582]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [.06 0 0 0]';

    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;

catch
    warning('Setting the twiss data parameters in the MML failed.');
end
