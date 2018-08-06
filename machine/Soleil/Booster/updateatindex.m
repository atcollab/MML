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
    %% HORIZONTAL CORRECTORS
    ifam = 'HCOR';
    AO.(ifam).AT.ATType  = ifam;
    AO.(ifam).AT.ATIndex = Indices.(ifam)(:);
    AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';

    %% VERTICAL CORRECTORS
    ifam = 'VCOR';
    AO.(ifam).AT.ATType  = ifam;
    AO.(ifam).AT.ATIndex = Indices.(ifam)(:);
    AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end


% QUADRUPOLES
try
    ifam = 'QF';
    AO.(ifam).AT.ATType  = 'QUAD';
    AO.(ifam).AT.ATIndex = Indices.QPF(:);
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex);
    AO.(ifam).AT.ATParameterGroup = mkparamgroup(THERING,AO.(ifam).AT.ATIndex,'K');

    ifam = 'QD';
    AO.(ifam).AT.ATType  = 'QUAD';
    AO.(ifam).AT.ATIndex = Indices.QPD(:);
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex);
    AO.(ifam).AT.ATParameterGroup = mkparamgroup(THERING,AO.(ifam).AT.ATIndex,'K');
catch
    warning('%s family not found in the model.',ifam);
end

% SEXTUPOLES
try
    ifam = 'SF';
    AO.(ifam).AT.ATType  = 'SEXT';
    AO.(ifam).AT.ATIndex = Indices.SXF(:);
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex);
    AO.(ifam).AT.ATParameterGroup = mkparamgroup(THERING,AO.(ifam).AT.ATIndex,'K2');

    ifam = 'SD';
    AO.(ifam).AT.ATType  = 'SEXT';
    AO.(ifam).AT.ATIndex = Indices.SXD(:);
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex);
    AO.(ifam).AT.ATParameterGroup = mkparamgroup(THERING,AO.(ifam).AT.ATIndex,'S');
catch
    warning('%s family not found in the model.', ifam);
end


% BEND

try
    ifam = 'BEND';
    AO.(ifam).AT.ATType  = ifam;
    ATIndex = Indices.(ifam)(:);
    AO.(ifam).AT.ATIndex = buildatindex(AO.(ifam).FamilyName, sort(ATIndex));
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';
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

% Set TwissData at the start of TL1
try
    %warning('to be completed by Alex');
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
