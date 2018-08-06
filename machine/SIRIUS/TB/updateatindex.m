function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)
% 2013-12-02 Init (ximenes)


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
    % B
    AO.B.AT.ATType = 'BEND';
    AO.B.AT.ATIndex = buildatindex(AO.B.FamilyName, Indices.B);
    AO.B.Position = findspos(THERING, AO.B.AT.ATIndex(:,1+floor(size(AO.B.AT.ATIndex,2)/2)))';
      
catch
    warning('B family not found in the model.');
end
try
    % InjS
    AO.InjS.AT.ATType = 'Septum';
    AO.InjS.AT.ATIndex = buildatindex(AO.InjS.FamilyName, Indices.InjS);
    AO.InjS.Position = findspos(THERING, AO.InjS.AT.ATIndex(:,1+floor(size(AO.InjS.AT.ATIndex,2)/2)))';
      
catch
    warning('InjS family not found in the model.');
end


try
    % QD1
    AO.QD1.AT.ATType = 'Quad';
    AO.QD1.AT.ATIndex = buildatindex(AO.QD1.FamilyName, Indices.QD1);
    AO.QD1.Position = findspos(THERING, AO.QD1.AT.ATIndex(:,1))';
catch
    warning('QD1 family not found in the model.');
end

try
    % QF1
    AO.QF1.AT.ATType = 'Quad';
    AO.QF1.AT.ATIndex = buildatindex(AO.QF1.FamilyName, Indices.QF1);
    AO.QF1.Position = findspos(THERING, AO.QF1.AT.ATIndex(:,1))';
catch
    warning('QF1 family not found in the model.');
end


try
    % QD2A
    AO.QD2A.AT.ATType = 'Quad';
    AO.QD2A.AT.ATIndex = buildatindex(AO.QD2A.FamilyName, Indices.QD2A);
    AO.QD2A.Position = findspos(THERING, AO.QD2A.AT.ATIndex(:,1))';
catch
    warning('QD2A family not found in the model.');
end

try
    % QF2A
    AO.QF2A.AT.ATType = 'Quad';
    AO.QF2A.AT.ATIndex = buildatindex(AO.QF2A.FamilyName, Indices.QF2A);
    AO.QF2A.Position = findspos(THERING, AO.QF2A.AT.ATIndex(:,1))';
catch
    warning('QF2A family not found in the model.');
end

try
    % QF2B
    AO.QF2B.AT.ATType = 'Quad';
    AO.QF2B.AT.ATIndex = buildatindex(AO.QF2B.FamilyName, Indices.QF2B);
    AO.QF2B.Position = findspos(THERING, AO.QF2B.AT.ATIndex(:,1))';
catch
    warning('QF2B family not found in the model.');
end

try
    % QD2B
    AO.QD2B.AT.ATType = 'Quad';
    AO.QD2B.AT.ATIndex = buildatindex(AO.QD2B.FamilyName, Indices.QD2B);
    AO.QD2B.Position = findspos(THERING, AO.QD2B.AT.ATIndex(:,1))';
catch
    warning('QD2B family not found in the model.');
end

try
    % QF3
    AO.QF3.AT.ATType = 'Quad';
    AO.QF3.AT.ATIndex = buildatindex(AO.QF3.FamilyName, Indices.QF3);
    AO.QF3.Position = findspos(THERING, AO.QF3.AT.ATIndex(:,1))';
catch
    warning('QF3 family not found in the model.');
end

try
    % QD3
    AO.QD3.AT.ATType = 'Quad';
    AO.QD3.AT.ATIndex = buildatindex(AO.QD3.FamilyName, Indices.QD3);
    AO.QD3.Position = findspos(THERING, AO.QD3.AT.ATIndex(:,1))';
catch
    warning('QD3 family not found in the model.');
end

try
    % QF4
    AO.QF4.AT.ATType = 'Quad';
    AO.QF4.AT.ATIndex = buildatindex(AO.QF4.FamilyName, Indices.QF4);
    AO.QF4.Position = findspos(THERING, AO.QF4.AT.ATIndex(:,1))';
catch
    warning('QF4 family not found in the model.');
end

try
    % QD4
    AO.QD4.AT.ATType = 'Quad';
    AO.QD4.AT.ATIndex = buildatindex(AO.QD4.FamilyName, Indices.QD4);
    AO.QD4.Position = findspos(THERING, AO.QD4.AT.ATIndex(:,1))';
catch
    warning('QD4 family not found in the model.');
end

try
    % BPMx
    AO.BPMx.AT.ATType = 'X';
    AO.BPMx.AT.ATIndex = buildatindex(AO.BPMx.FamilyName, Indices.BPM);
    AO.BPMx.Position = findspos(THERING, AO.BPMx.AT.ATIndex(:,1))';   
catch
    warning('BPMx family not found in the model.');
end

try
    % BPMy
    AO.BPMy.AT.ATType = 'Y';
    AO.BPMy.AT.ATIndex = buildatindex(AO.BPMy.FamilyName, Indices.BPM);
    AO.BPMy.Position = findspos(THERING, AO.BPMy.AT.ATIndex(:,1))';   
catch
    warning('BPMy family not found in the model.');
end

try
    % CH
    AO.CH.AT.ATType = 'HCM';
    li = Indices.CH;
    AO.CH.AT.ATIndex = buildatindex(AO.CH.FamilyName, li);
    AO.CH.Position = findspos(THERING, AO.CH.AT.ATIndex(:,1))';   
catch
    warning('CH family not found in the model.');
end


try
    % CV
    AO.CV.AT.ATType = 'VCM';
    li = Indices.CV;
    AO.CV.AT.ATIndex = buildatindex(AO.CV.FamilyName, li);
    AO.CV.Position = findspos(THERING, AO.CV.AT.ATIndex(:,1))';   
catch
    warning('CV family not found in the model.');
end


setao(AO);




