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
    warning('BPM family not found in the model.');
end

try
    % Horizontal correctors are at every AT corrector
    AO.HCM.AT.ATType = 'HCM';
    AO.HCM.AT.ATIndex = buildatindex(AO.HCM.FamilyName, Indices.HCOR);
    AO.HCM.Position = findspos(THERING, AO.HCM.AT.ATIndex(:,1))';

    % Not all correctors are vertical correctors
    AO.VCM.AT.ATType = 'VCM';
    AO.VCM.AT.ATIndex = buildatindex(AO.VCM.FamilyName, Indices.VCOR);
    AO.VCM.Position = findspos(THERING, AO.VCM.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end

try
    AO.QF1.AT.ATType = 'QUAD';
    AO.QF1.AT.ATIndex = buildatindex(AO.QF1.FamilyName, Indices.QF1);
    AO.QF1.Position = findspos(THERING, AO.QF1.AT.ATIndex(:,1))';

    AO.QD1.AT.ATType = 'QUAD';
    AO.QD1.AT.ATIndex = buildatindex(AO.QD1.FamilyName, Indices.QD1);
    AO.QD1.Position = findspos(THERING, AO.QD1.AT.ATIndex(:,1))';

    AO.QF2.AT.ATType = 'QUAD';
    AO.QF2.AT.ATIndex = buildatindex(AO.QF2.FamilyName, Indices.QF2);
    AO.QF2.Position = findspos(THERING, AO.QF2.AT.ATIndex(:,1))';

    AO.QD2.AT.ATType = 'QUAD';
    AO.QD2.AT.ATIndex = buildatindex(AO.QD2.FamilyName, Indices.QD2);
    AO.QD2.Position = findspos(THERING, AO.QD2.AT.ATIndex(:,1))';
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
%    AO.SkewQuad.AT.ATType = 'SkewQuad';
%    AO.SkewQuad.AT.ATIndex = buildatindex(AO.SkewQuad.FamilyName, Indices.SQ);
%    AO.SkewQuad.Position = findspos(THERING, AO.SkewQuad.AT.ATIndex(:,1))';
catch
    warning('Skew quadrupole family not found in the model.');
end

% try
%     % HDM
%     AO.HDM.AT.ATType = 'BEND';
% %     AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, sort([Indices.BEND]));
%     AO.HDM.AT.ATIndex = buildatindex(AO.HDM.FamilyName, Indices.HDM(:));
%     AO.HDM.Position = findspos(THERING, AO.HDM.AT.ATIndex(:,1))';
% catch
%     warning('HDM family not found in the model.');
% end

try
    % BEND
    AO.BEND.AT.ATType = 'BEND';
    AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, sort([Indices.BEND]));
%     ATIndex = [Indices.BEND(:); Indices.HDM(:)];
%     AO.BEND.AT.ATIndex = buildatindex(AO.BEND.FamilyName, sort(ATIndex));
    AO.BEND.Position = findspos(THERING, AO.BEND.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end

try
    % SWLS
    AO.SWLS.AT.ATType = 'SWLS';
    AO.SWLS.AT.ATIndex = buildatindex(AO.SWLS.FamilyName, sort([Indices.SWLS]));
    AO.SWLS.Position = findspos(THERING, AO.SWLS.AT.ATIndex(:,1))';
catch
    warning('SWLS family not found in the model.');
end

try
    % IASW6
    AO.IASW6.AT.ATType = 'IASW6';
    AO.IASW6.AT.ATIndex = buildatindex(AO.IASW6.FamilyName, sort([Indices.IASW6]));
    AO.IASW6.Position = findspos(THERING, AO.IASW6.AT.ATIndex(:,1))';
catch
    warning('IASW6 family not found in the model.');
end

try
    % W20
    AO.W20.AT.ATType = 'W20';
    AO.W20.AT.ATIndex = buildatindex(AO.W20.FamilyName, sort([Indices.W20]));
    AO.W20.Position = findspos(THERING, AO.W20.AT.ATIndex(:,1))';
catch
    warning('W20 family not found in the model.');
end

try
    % SW6
    AO.SW6.AT.ATType = 'SW6';
    AO.SW6.AT.ATIndex = buildatindex(AO.SW6.FamilyName, sort([Indices.SW6]));
    AO.SW6.Position = findspos(THERING, AO.SW6.AT.ATIndex(:,1))';
catch
    warning('SW6 family not found in the model.');
end

try
    % U9
    AO.U9.AT.ATType = 'U9';
    AO.U9.AT.ATIndex = buildatindex(AO.U9.FamilyName, sort([Indices.U9]));
    AO.U9.Position = findspos(THERING, AO.U9.AT.ATIndex(:,1))';
catch
    warning('U9 family not found in the model.');
end

try
    % U5
    AO.U5.AT.ATType = 'U5';
    AO.U5.AT.ATIndex = buildatindex(AO.U5.FamilyName, sort([Indices.U5]));
    AO.U5.Position = findspos(THERING, AO.U5.AT.ATIndex(:,1))';
catch
    warning('U5 family not found in the model.');
end

try
    % EPU56
    AO.EPU56.AT.ATType = 'EPU56';
    AO.EPU56.AT.ATIndex = buildatindex(AO.EPU56.FamilyName, sort([Indices.EPU56]));
    AO.EPU56.Position = findspos(THERING, AO.EPU56.AT.ATIndex(:,1))';
catch
    warning('EPU56 family not found in the model.');
end

try
    % IASWB
    AO.IASWB.AT.ATType = 'IASWB';
    AO.IASWB.AT.ATIndex = buildatindex(AO.IASWB.FamilyName, sort([Indices.IASWB]));
    AO.IASWB.Position = findspos(THERING, AO.IASWB.AT.ATIndex(:,1))';
catch
    warning('IASWB family not found in the model.');
end

try
    % IASWC
    AO.IASWC.AT.ATType = 'IASWC';
    AO.IASWC.AT.ATIndex = buildatindex(AO.IASWC.FamilyName, sort([Indices.IASWC]));
    AO.IASWC.Position = findspos(THERING, AO.IASWC.AT.ATIndex(:,1))';
catch
    warning('IASWC family not found in the model.');
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
    TwissData.beta  = [11.74 2.814]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [0.1651 0 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end
