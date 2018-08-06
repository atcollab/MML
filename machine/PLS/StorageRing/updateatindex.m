function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

AO = getao;

try
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = findcells(THERING,'FamName','BPM')';
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex)';

    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = findcells(THERING,'FamName','BPM')';
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex)';
catch
    warning('BPM family not found in the model.');
end

try
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, 'HCM');
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, 'VCM');
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end

try
    AO.Q1.AT.ATType = 'QUAD';
    AO.Q1.AT.ATIndex = buildatindex(AO.Q1.FamilyName, 'Q1');
    AO.Q1.Position = findspos(THERING, AO.Q1.AT.ATIndex(:,1))';

    AO.Q2.AT.ATType = 'QUAD';
    AO.Q2.AT.ATIndex = buildatindex(AO.Q2.FamilyName, 'Q2');
    AO.Q2.Position = findspos(THERING, AO.Q2.AT.ATIndex(:,1))';

    AO.Q3.AT.ATType = 'QUAD';
    AO.Q3.AT.ATIndex = buildatindex(AO.Q3.FamilyName, 'Q3');
    AO.Q3.Position = findspos(THERING, AO.Q3.AT.ATIndex(:,1))';

    AO.Q4.AT.ATType = 'QUAD';
    AO.Q4.AT.ATIndex = buildatindex(AO.Q4.FamilyName, 'Q4');
    AO.Q4.Position = findspos(THERING, AO.Q4.AT.ATIndex(:,1))';

    AO.Q5.AT.ATType = 'QUAD';
    AO.Q5.AT.ATIndex = buildatindex(AO.Q5.FamilyName, 'Q5');
    AO.Q5.Position = findspos(THERING, AO.Q5.AT.ATIndex(:,1))';

    AO.Q6.AT.ATType = 'QUAD';
    AO.Q6.AT.ATIndex = buildatindex(AO.Q6.FamilyName, 'Q6');
    AO.Q6.Position = findspos(THERING, AO.Q6.AT.ATIndex(:,1))';
catch
    warning('QUAD family not found in the model.');
end


try
    AO.SF.AT.ATType = 'SEXT';
    AO.SF.AT.ATIndex = buildatindex(AO.SF.FamilyName, 'SF');
    AO.SF.Position = findspos(THERING, AO.SF.AT.ATIndex(:,1))';

    AO.SD.AT.ATType = 'SEXT';
    AO.SD.AT.ATIndex = buildatindex(AO.SD.FamilyName, 'SD');
    AO.SD.Position = findspos(THERING, AO.SD.AT.ATIndex(:,1))';
catch
    warning('Sextupole families not found in the model.');
end


try
    % Skeq Quad
    % Treat seried power supply as a split magnet in sectors 2,5,8,11
    % Use setpvmodel('SF','SkewQuad', K, DeviceList) to change individual skew quadrupoles in the model
    setao(AO);
    AO.SkewQuad.AT.ATType = 'SkewQuad';
    AO.SkewQuad.AT.ATIndex = [];
    for s = [2 5 8 11]
        iAT = [family2atindex('SD',[s 1]) family2atindex('SF',[s 1]) family2atindex('SF',[s 2]) family2atindex('SD',[s 2])];
        AO.SkewQuad.AT.ATIndex = [AO.SkewQuad.AT.ATIndex; iAT];
    end
    AO.SkewQuad.Position = findspos(THERING, AO.SkewQuad.AT.ATIndex(:,1))';
catch
    warning('SkewQuad family not found in the model.');
end


try
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, 'BEND');
    %AO.BEND.AT.ATIndex = findcells(THERING,'FamName','BEND')';
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end


try
    % RF Cavity
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end


try
    % Kicker
    AO.KICKER.AT.ATType = 'HCM';
    AO.KICKER.AT.ATIndex = buildatindex(AO.KICKER.FamilyName, 'KICKER');
    AO.KICKER.Position = findspos(THERING, AO.KICKER.AT.ATIndex(:,1))';
catch
    warning('KICKER not found in the model.');
end

setao(AO);


% Set TwissData at the start of the storage ring
try
    % Twiss parameters at the input 
    TwissData.alpha = [0 0]';
    TwissData.beta  = [10.0121  4.0304]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end
