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
    
%     AO.KICKER.AT.ATType = 'KICKER';
%     AO.KICKER.AT.ATIndex = buildatindex(AO.KICKER.FamilyName, Indices.KICKER);
%     AO.KICKER.Position = findspos(THERING, AO.KICKER.AT.ATIndex(:,1))';
catch
    warning('Corrector family not found in the model.');
end

try
    AO.QM.AT.ATType = 'QUAD';
    AO.QM.AT.ATIndex = buildatindex(AO.QM.FamilyName, Indices.QM);
    AO.QM.Position = findspos(THERING, AO.QM.AT.ATIndex(:,1))';
    
    AO.SQ.AT.ATType = 'QUAD';
    AO.SQ.AT.ATIndex = buildatindex(AO.SQ.FamilyName, Indices.SQ);
    AO.SQ.Position = findspos(THERING, AO.SQ.AT.ATIndex(:,1))';
catch
    warning('QUAD family not found in the model.');
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
    AO.BM.AT.ATType = 'BEND';
    AO.BM.AT.ATIndex = buildatindex(AO.BM.FamilyName, sort([Indices.BM]));
%     ATIndex = [Indices.BD(:); Indices.HDM(:)];
%     AO.BD.AT.ATIndex = buildatindex(AO.BD.FamilyName, sort(ATIndex));
    AO.BM.Position = findspos(THERING, AO.BM.AT.ATIndex(:,1))';
    
%     AO.SE.AT.ATType = 'BEND';
%     AO.SE.AT.ATIndex = buildatindex(AO.SE.FamilyName, sort([Indices.SE]));
% %     ATIndex = [Indices.SE(:); Indices.HDM(:)];
% %     AO.SE.AT.ATIndex = buildatindex(AO.SE.FamilyName, sort(ATIndex));
%     AO.SE.Position = findspos(THERING, AO.SE.AT.ATIndex(:,1))';
%     
%     AO.SI.AT.ATType = 'BEND';
%     AO.SI.AT.ATIndex = buildatindex(AO.SI.FamilyName, sort([Indices.SI]));
% %     ATIndex = [Indices.SI(:); Indices.HDM(:)];
% %     AO.SI.AT.ATIndex = buildatindex(AO.SI.FamilyName, sort(ATIndex));
%     AO.SI.Position = findspos(THERING, AO.SI.AT.ATIndex(:,1))';
catch
    warning('BEND family not found in the model.');
end

% try
%     % SWLS
%     AO.SWLS.AT.ATType = 'SWLS';
%     AO.SWLS.AT.ATIndex = buildatindex(AO.SWLS.FamilyName, sort([Indices.SWLS]));
%     AO.SWLS.Position = findspos(THERING, AO.SWLS.AT.ATIndex(:,1))';
% catch
%     warning('SWLS family not found in the model.');
% end
% 
% try
%     % IASW6
%     AO.IASW6.AT.ATType = 'IASW6';
%     AO.IASW6.AT.ATIndex = buildatindex(AO.IASW6.FamilyName, sort([Indices.IASW6]));
%     AO.IASW6.Position = findspos(THERING, AO.IASW6.AT.ATIndex(:,1))';
% catch
%     warning('IASW6 family not found in the model.');
% end
% 
% try
%     % W20
%     AO.W20.AT.ATType = 'W20';
%     AO.W20.AT.ATIndex = buildatindex(AO.W20.FamilyName, sort([Indices.W20]));
%     AO.W20.Position = findspos(THERING, AO.W20.AT.ATIndex(:,1))';
% catch
%     warning('W20 family not found in the model.');
% end
% 
% try
%     % SW6
%     AO.SW6.AT.ATType = 'SW6';
%     AO.SW6.AT.ATIndex = buildatindex(AO.SW6.FamilyName, sort([Indices.SW6]));
%     AO.SW6.Position = findspos(THERING, AO.SW6.AT.ATIndex(:,1))';
% catch
%     warning('SW6 family not found in the model.');
% end
% 
% try
%     % U9
%     AO.U9.AT.ATType = 'U9';
%     AO.U9.AT.ATIndex = buildatindex(AO.U9.FamilyName, sort([Indices.U9]));
%     AO.U9.Position = findspos(THERING, AO.U9.AT.ATIndex(:,1))';
% catch
%     warning('U9 family not found in the model.');
% end
% 
% try
%     % U5
%     AO.U5.AT.ATType = 'U5';
%     AO.U5.AT.ATIndex = buildatindex(AO.U5.FamilyName, sort([Indices.U5]));
%     AO.U5.Position = findspos(THERING, AO.U5.AT.ATIndex(:,1))';
% catch
%     warning('U5 family not found in the model.');
% end
% 
% try
%     % EPU56
%     AO.EPU56.AT.ATType = 'EPU56';
%     AO.EPU56.AT.ATIndex = buildatindex(AO.EPU56.FamilyName, sort([Indices.EPU56]));
%     AO.EPU56.Position = findspos(THERING, AO.EPU56.AT.ATIndex(:,1))';
% catch
%     warning('EPU56 family not found in the model.');
% end

% RF Cavity
% try
%     AO.RF.AT.ATType = 'RF Cavity';
%     AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
%     AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
% catch
%     warning('RF cavity not found in the model.');
% end


setao(AO);



% Set TwissData at the start of the storage ring
% try   
%     % BTS twiss parameters at the input 
%     TwissData.alpha = [2.116 -0.870]';
%     TwissData.beta  = [12.150 4.897]';
%     TwissData.mu    = [1.583 1.034]';
%     TwissData.ClosedOrbit = [0 0 0 0]';
%     TwissData.dP = 0;
%     TwissData.dL = 0;
%     TwissData.Dispersion  = [0.546 -0.096 0 0]';
%     
%     setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
% catch
%      warning('Setting the twiss data parameters in the MML failed.');
% end
try   
    % BTS twiss parameters at the input 
    TwissData.alpha = [3.253 -1.074]';
    TwissData.beta  = [8.573 3.070]';
    TwissData.mu    = [0 0]';
    TwissData.ClosedOrbit = [0 0 0 0]';
    TwissData.dP = 0;
    TwissData.dL = 0;
    TwissData.Dispersion  = [1.086 -0.260 0 0]';
    
    setpvmodel('TwissData', '', TwissData);  % Same as, THERING{1}.TwissData = TwissData;
catch
     warning('Setting the twiss data parameters in the MML failed.');
end
