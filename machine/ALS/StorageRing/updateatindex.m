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
spos = findspos(THERING,1:length(THERING));

AO = getao;


% BPMS
try
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = spos(AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = Indices.BPM(:); % findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = spos(AO.BPMy.AT.ATIndex)';
    
    % New BPM family
    i = findrowindex(AO.BPM.DeviceList, AO.BPMx.DeviceList);
    AO.BPM.AT.ATType = 'X';
    AO.BPM.AT.ATIndex = AO.BPMx.AT.ATIndex(i);
    AO.BPM.Position = AO.BPMx.Position(i);
catch
    warning('BPM family not found in the model.');
end


% CORRECTORS
try
    AO.HCM.AT.ATIndex = [];
    AO.VCM.AT.ATIndex = [];

    % Horizontal correctors are at every AT corrector
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.COR);
    AO.HCM.Position = spos(AO.HCM.AT.ATIndex(:,1))';

    % Not all correctors are vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    i = findrowindex(AO.VCM.DeviceList, AO.HCM.DeviceList);
    AO.VCM.AT.ATIndex = AO.HCM.AT.ATIndex(i);
    AO.VCM.Position = spos(AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end

try
    %AO.VCBSC.AT.ATType = 'VCM';
    %AO.VCBSC.AT.ATIndex = buildatindex(AO.VCBSC.FamilyName, Indices.VCBSC);
    AO.VCBSC.Position = spos(Indices.BS(:,1))';
catch
    %warning('VCBSC family not found in the model.');
end


% QUADRUPOLES
try
    AO.QF.AT.ATType = 'QUAD';
    AO.QF.AT.ATIndex = buildatindex(AO.QF.FamilyName, Indices.QF);
    AO.QF.Position = spos(AO.QF.AT.ATIndex(:,1))';

    AO.QD.AT.ATType = 'QUAD';
    AO.QD.AT.ATIndex = buildatindex(AO.QD.FamilyName, Indices.QD);
    AO.QD.Position = spos(AO.QD.AT.ATIndex(:,1))';
catch
    warning('QF or QD family not found in the model.');
end

try
    AO.QFA.AT.ATType = 'QUAD';
    AO.QFA.AT.ATIndex = buildatindex(AO.QFA.FamilyName, Indices.QFA);
    AO.QFA.Position = spos(AO.QFA.AT.ATIndex)';
catch
    warning('QFA family not found in the model.');
end

try
    AO.QDA.AT.ATType = 'QUAD';
    AO.QDA.AT.ATIndex = buildatindex(AO.QDA.FamilyName, Indices.QDA);
    AO.QDA.Position = spos(AO.QDA.AT.ATIndex(:,1))';
catch
    warning('QDA family not found in the model.');
end


% SEXTUPOLES
try
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, Indices.SFF);
    AO.SF.Position = spos(AO.SF.AT.ATIndex(:,1))';

    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, Indices.SDD);
    AO.SD.Position = spos(AO.SD.AT.ATIndex(:,1))';

    AO.SQSF.AT.ATType = 'SkewQuad';
    AO.SQSF.AT.ATIndex = buildatindex(AO.SQSF.FamilyName, Indices.SFF);
    AO.SQSF.Position = spos(AO.SQSF.AT.ATIndex(:,1))';

    AO.SQSD.AT.ATType = 'SkewQuad';
    AO.SQSD.AT.ATIndex = buildatindex(AO.SQSD.FamilyName, Indices.SDD);
    AO.SQSD.Position = spos(AO.SQSD.AT.ATIndex(:,1))';
catch
    warning('Sextupole families not found in the model.');
end


% BEND
try
    AO.BSC.AT.ATType = 'BEND';
    %AO.BSC.AT.ATIndex = Indices.BS(:); %findcells(THERING,'FamName','BS')';
    AO.BSC.AT.ATIndex = buildatindex(AO.BSC.FamilyName, Indices.BS(:));
    AO.BSC.Position = spos(AO.BSC.AT.ATIndex(:,1))';
catch
    Indices.BS = [];
    warning('BS family not found in the model.');
end

try
    % Combine BEND and BSC
    AO.BEND.AT.ATType = 'BEND';
    ATIndex = [Indices.BEND(:); Indices.BS(:)];   %[findcells(THERING,'FamName','BEND')'; findcells(THERING,'FamName','BS')'];
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, sort(ATIndex));
    AO.BEND.Position = spos(AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end


% HCMCHICANE
try
    ATDeviceList = [
        4     1
        4     2
        4     3
        6     1
        6     2
        6     3
        11    1];
    AO.HCMCHICANE.AT.ATType = 'HCM';
    i = findrowindex(AO.HCMCHICANE.DeviceList, ATDeviceList);
    AO.HCMCHICANE.AT.ATIndex = buildatindex(AO.HCMCHICANE.FamilyName, Indices.CHICANE(i));
    AO.HCMCHICANE.Position = spos(AO.HCMCHICANE.AT.ATIndex(:,1))';
catch
    warning('HCMCHICANE family not found in the model.');
end

% HCMCHICANEM
try
    % Motor chicane position (this is not right but it will do for now)
    AO.HCMCHICANEM.Position = [];
    for i = 1:size(AO.HCMCHICANEM.DeviceList,1)
        Sector = sprintf('SECT%d', AO.HCMCHICANEM.DeviceList(i,1));
        AO.HCMCHICANEM.Position(i,1) = spos(Indices.(Sector));
    end
catch
    warning('Trouble with HCMCHICANEM family setup.');
end


% VCMCHICANE
try
    AO.VCMCHICANE.AT.ATType = 'VCM';
    i = findrowindex(AO.VCMCHICANE.DeviceList, AO.HCMCHICANE.DeviceList);
    AO.VCMCHICANE.AT.ATIndex = AO.HCMCHICANE.AT.ATIndex(i);
    AO.VCMCHICANE.AT.ATIndex = buildatindex(AO.VCMCHICANE.FamilyName, Indices.CHICANE);
    AO.VCMCHICANE.Position = findspos(THERING, AO.VCMCHICANE.AT.ATIndex)';
    AO.VCMCHICANE.Position = AO.VCMCHICANE.Position(1:2,1);
catch
    warning('VCMCHICANE family not found in the model.');
end


% RF CAVITY
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = spos(AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end


% Fast Kicker in Sector 2
try
    AO.Kicker.AT.ATType = 'VCM';
    AO.Kicker.AT.ATIndex = Indices.FASTKICKER';
    AO.Kicker.Position = spos(AO.Kicker.AT.ATIndex(:,1))';
catch
    %warning('Sector 2 fast kicker not found in the model.');
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
