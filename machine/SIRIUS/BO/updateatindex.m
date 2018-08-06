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
    % BEND
    AO.b.AT.ATType = 'BEND';
    AO.b.AT.ATIndex = buildatindex(AO.b.FamilyName, Indices.b);
    AO.b.Position = findspos(THERING, AO.b.AT.ATIndex(:,1));
catch
    warning('B family not found in the model.');
end

try
    % bend_a
    AO.bend_a.AT.ATType = 'BendPS';
    AO.bend_a.AT.ATMagnet = 'b';
    AO.bend_a.AT.ATIndex = buildatindex(AO.b.FamilyName, Indices.b);
    AO.bend_a.Position = findspos(THERING, AO.bend_a.AT.ATIndex(:,1));
catch
    warning('bend_a family not found in the model.');
end

try
    % bend_b
    AO.bend_b.AT.ATType = 'BendPS';
    AO.bend_b.AT.ATMagnet = 'b';
    AO.bend_b.AT.ATIndex = buildatindex(AO.b.FamilyName, Indices.b);
    AO.bend_b.Position = findspos(THERING, AO.bend_b.AT.ATIndex(:,1));
catch
    warning('bend_b family not found in the model.');
end

try
    % QD
    AO.qd.AT.ATType = 'QUAD';
    AO.qd.AT.ATIndex = buildatindex(AO.qd.FamilyName, Indices.qd);
    AO.qd.Position = findspos(THERING, AO.qd.AT.ATIndex(:,1));
catch
    warning('QD family not found in the model.');
end

try
    % QF
    AO.qf.AT.ATType = 'QUAD';
    AO.qf.AT.ATIndex = buildatindex(AO.qf.FamilyName, Indices.qf);
    AO.qf.Position = findspos(THERING, AO.qf.AT.ATIndex(:,1));
catch
    warning('QF family not found in the model.');
end

try
    % SD
    AO.sd.AT.ATType = 'SEXT';
    AO.sd.AT.ATIndex = buildatindex(AO.sd.FamilyName, Indices.sd);
    AO.sd.Position = findspos(THERING, AO.sd.AT.ATIndex(:,1));
catch
    warning('SD family not found in the model.');
end

try
    % SF
    AO.sf.AT.ATType = 'SEXT';
    AO.sf.AT.ATIndex = buildatindex(AO.sf.FamilyName, Indices.sf);
    AO.sf.Position = findspos(THERING, AO.sf.AT.ATIndex(:,1));
catch
    warning('SF family not found in the model.');
end

try
    % BPMx
    AO.bpmx.AT.ATType = 'X';
    AO.bpmx.AT.ATIndex = buildatindex(AO.bpmx.FamilyName, Indices.bpm);
    AO.bpmx.Position = findspos(THERING, AO.bpmx.AT.ATIndex(:,1))';   
catch
    warning('BPMx family not found in the model.');
end

try
    % BPMy
    AO.bpmy.AT.ATType = 'Y';
    AO.bpmy.AT.ATIndex = buildatindex(AO.bpmy.FamilyName, Indices.bpm);
    AO.bpmy.Position = findspos(THERING, AO.bpmy.AT.ATIndex(:,1))';   
catch
    warning('BPMy family not found in the model.');
end

try
    % HCM
    AO.ch.AT.ATType = 'HCM';
    AO.ch.AT.ATIndex = buildatindex(AO.ch.FamilyName, Indices.ch);
    AO.ch.Position = findspos(THERING, AO.ch.AT.ATIndex(:,1))';   
catch
    warning('HCM family not found in the model.');
end

try
    % VCM
    AO.cv.AT.ATType = 'VCM';
    AO.cv.AT.ATIndex = buildatindex(AO.cv.FamilyName, Indices.cv);
    AO.cv.Position = findspos(THERING, AO.cv.AT.ATIndex(:,1))';   
catch
    warning('VCM family not found in the model.');
end



% RF Cavity
try
    AO.rf.AT.ATType = 'RF Cavity';
    AO.rf.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.rf.Position = findspos(THERING, AO.rf.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end


setao(AO);
