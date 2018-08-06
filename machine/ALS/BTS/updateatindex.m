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


% BPMS
try
    AO.BPMx.AT.ATType = 'xTurns';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'yTurns';
    AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';

    AO.BPM.Position = AO.BPMx.Position;
catch
    warning('BPM family not found in the model.');
end


% CORRECTORS
try
    % Horizontal correctors are at every AT corrector
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HCM);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    % Not all correctors are vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.VCM);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end


% QUADRUPOLES
try
    AO.Q.AT.ATType = 'QUAD';
    AO.Q.AT.ATIndex = buildatindex(AO.Q.FamilyName, Indices.Q);
    AO.Q.Position = findspos(THERING, AO.Q.AT.ATIndex(:,1))';
catch
    warning('Q family not found in the model.');
end


% BEND
try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, Indices.BEND);
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end


% INJECTION MAGNETS
try
    AO.SRBump.AT.ATType = 'BEND';
    AO.SRBump.AT.ATIndex = [NaN; NaN; Indices.SRBMP3; Indices.SRBMP4];
    AO.SRBump.Position = [37 38 findspos(THERING, [Indices.SRBMP3 Indices.SRBMP4])]';
catch
    warning('SRBump family not found in the model.');
end
try
    AO.Septum.AT.ATType = 'BEND';
    AO.Septum.AT.ATIndex = [Indices.SEN Indices.SEK Indices.SIK Indices.SIN]';
    AO.Septum.Position = findspos(THERING, AO.Septum.AT.ATIndex(:,1))';
catch
    warning('Septum family not found in the model.');
end

% TV
try
    AO.TV.AT.ATType = 'TV';
    AO.TV.AT.ATIndex = buildatindex(AO.TV.FamilyName, Indices.TV);
    AO.TV.Position = findspos(THERING, AO.TV.AT.ATIndex(:,1))';
catch
    warning('BTS TV family not found in the model.');
end

setao(AO);




% Set TwissData at the start of the BTS
try  
    % BTS twiss parameters at the input 
    TwissData.alpha = [-0.32 2.42]';
    TwissData.beta  = [.63 9.6]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [.074 0.018 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;

catch
     warning('Setting the twiss data parameters in the BTS MML failed.');
end

