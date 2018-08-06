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
    ifam = ('CH');
    AO.(ifam).AT.ATType  = ifam;
    AO.(ifam).AT.ATIndex = Indices.(ifam)(:);
    AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';

    %% VERTICAL CORRECTORS
    ifam = ('CV');
    AO.(ifam).AT.ATType  = ifam;
    AO.(ifam).AT.ATIndex = Indices.(ifam)(:);
    AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex(AO.(ifam).ElementList);   %not all correctors used
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end


% QUADRUPOLES
try
    ifam = 'QP';
    AO.(ifam).AT.ATType  = 'QUAD';
    AO.(ifam).AT.ATIndex = eval(['Indices.' ifam '(:)']);
    AO.(ifam).AT.ATIndex = AO.(ifam).AT.ATIndex;
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';
catch
    warning('%s family not found in the model.', ifam);
end

% BEND

try
    ifam = ('BEND');
    AO.(ifam).AT.ATType  = ifam;
    ATIndex = Indices.(ifam)(:);
    AO.(ifam).AT.ATIndex = buildatindex(AO.(ifam).FamilyName, sort(ATIndex));
    AO.(ifam).Position   = findspos(THERING, AO.(ifam).AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end

setao(AO);

% Set TwissData at the start of TL1
try
    % BTS twiss parameters at the input
    TwissData.alpha = [0 0]';
    TwissData.beta  = [6.0 6.0]';
    TwissData.mu    = [-1.8 1.5]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';

    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;

catch
    warning('Setting the twiss data parameters in the MML failed.');
end
