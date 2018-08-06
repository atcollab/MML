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
    % Spect
    AO.Spect.AT.ATType = 'BEND';
    AO.Spect.AT.ATIndex = buildatindex(AO.Spect.FamilyName, Indices.Spect);
    AO.Spect.Position = findspos(THERING, AO.Spect.AT.ATIndex(:,1+floor(size(AO.Spect.AT.ATIndex,2)/2)))';
      
catch
    warning('Spect family not found in the model.');
end
try
    % QF2
    AO.QF2.AT.ATType = 'Quad';
    AO.QF2.AT.ATIndex = buildatindex(AO.QF2.FamilyName, Indices.QF2);
    AO.QF2.Position = findspos(THERING, AO.QF2.AT.ATIndex(:,1))';
catch
    warning('QF2 family not found in the model.');
end

try
    % QD2
    AO.QD2.AT.ATType = 'Quad';
    AO.QD2.AT.ATIndex = buildatindex(AO.QD2.FamilyName, Indices.QD2);
    AO.QD2.Position = findspos(THERING, AO.QD2.AT.ATIndex(:,1))';
catch
    warning('QD2 family not found in the model.');
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
    li = [];
    if isfield(Indices, 'CH'), li = [li Indices.CH]; end;
    if isfield(Indices, 'hcm'), li = [li Indices.hcm]; end;
    % Remove linac corrector
    li = sort(li);
    li = li(2:end);
    AO.CH.AT.ATIndex = buildatindex(AO.CH.FamilyName, li);
    AO.CH.Position = findspos(THERING, AO.CH.AT.ATIndex(:,1))';   
catch
    warning('CH family not found in the model.');
end


try
    % CV
    AO.CV.AT.ATType = 'VCM';
    li = [];
    if isfield(Indices, 'CV'), li = [li Indices.CV]; end;
    if isfield(Indices, 'vcm'), li = [li Indices.vcm]; end;
    % Remove linac corrector
    li = sort(li);
    li = li(2:end);
    AO.CV.AT.ATIndex = buildatindex(AO.CV.FamilyName, li);
    AO.CV.Position = findspos(THERING, AO.CV.AT.ATIndex(:,1))';   
catch
    warning('CV family not found in the model.');
end


setao(AO);




