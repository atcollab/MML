function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)
% 2012-07-10 Modificado para sirius3_lattice_e025 - Afonso


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

% Sort by family first (findcells is linear and slow)
Indices = atindex(THERING);

AO = getao;

family_data = sirius_si_family_data(THERING);


try
    % B1
    AO.B1.AT.ATType = 'BEND';
    AO.B1.AT.ATIndex = buildatindex(AO.B1.FamilyName, Indices.B1);
    AO.B1.Position = findspos(THERING, AO.B1.AT.ATIndex(:,1+floor(size(AO.B1.AT.ATIndex,2)/2)))';
      
catch
    warning('B1 family not found in the model.');
end

try
    % B2
    AO.B2.AT.ATType = 'BEND';
    AO.B2.AT.ATIndex = buildatindex(AO.B2.FamilyName, Indices.B2);
    AO.B2.Position = findspos(THERING, AO.B2.AT.ATIndex(:,1+floor(size(AO.B2.AT.ATIndex,2)/2)))';
      
catch
    warning('B2 family not found in the model.');
end

try
    % BC
    AO.BC.AT.ATType = 'BEND';
    AO.BC.AT.ATIndex = buildatindex(AO.BC.FamilyName, Indices.BC);
    AO.BC.Position = findspos(THERING, AO.BC.AT.ATIndex(:,1+floor(size(AO.BC.AT.ATIndex,2)/2)))';
      
catch
    warning('BC family not found in the model.');
end

try
    % QFA
    AO.QFA.AT.ATType = 'Quad';
    AO.QFA.AT.ATIndex = buildatindex(AO.QFA.FamilyName, Indices.QFA);
    AO.QFA.Position = findspos(THERING, AO.QFA.AT.ATIndex(:,1))';
catch
    warning('QFA family not found in the model.');
end

try
    % QFAFam
    AO.QFAFam.AT.ATType   = 'FamilyPS';
    AO.QFAFam.AT.ATMagnet = 'QFA';
    AO.QFAFam.AT.ATIndex  = buildatindex(AO.QFA.FamilyName, Indices.QFA);
    AO.QFAFam.Position    = findspos(THERING, AO.QFAFam.AT.ATIndex(:,1))';
catch
    warning('QFAFam family not found in the model.');
end

try
    % QFATrim
    AO.QFATrim.AT.ATType   = 'ShuntPS';
    AO.QFATrim.AT.ATMagnet = 'QFA';
    AO.QFATrim.AT.ATIndex  = buildatindex(AO.QFA.FamilyName, Indices.QFA);
    AO.QFATrim.Position    = findspos(THERING, AO.QFATrim.AT.ATIndex(:,1))';
catch
    warning('QFATrim family not found in the model.');
end

try
    % QDA
    AO.QDA.AT.ATType = 'Quad';
    AO.QDA.AT.ATIndex = buildatindex(AO.QDA.FamilyName, Indices.QDA);
    AO.QDA.Position = findspos(THERING, AO.QDA.AT.ATIndex(:,1))';
catch
    warning('QDA family not found in the model.');
end

try
	% QDAFam
	AO.QDAFam.AT.ATType = 'FamilyPS';
    AO.QDAFam.AT.ATMagnet = 'QDA';
	AO.QDAFam.AT.ATIndex = buildatindex(AO.QDA.FamilyName, Indices.QDA);
	AO.QDAFam.Position = findspos(THERING, AO.QDAFam.AT.ATIndex(:,1));
catch
	warning('QDAFam family not found in the model.');
end

try
	% QDATrim
	AO.QDATrim.AT.ATType = 'ShuntPS';
    AO.QDATrim.AT.ATMagnet = 'QDA';
	AO.QDATrim.AT.ATIndex = buildatindex(AO.QDA.FamilyName, Indices.QDA);
	AO.QDATrim.Position = findspos(THERING, AO.QDATrim.AT.ATIndex(:,1));
catch
	warning('QDATrim family not found in the model.');
end

try
    % QFB
    AO.QFB.AT.ATType = 'Quad';
    AO.QFB.AT.ATIndex = buildatindex(AO.QFB.FamilyName, Indices.QFB);
    AO.QFB.Position = findspos(THERING, AO.QFB.AT.ATIndex(:,1))';
catch
    warning('QFB family not found in the model.');
end

try
	% QFBFam
	AO.QFBFam.AT.ATType = 'FamilyPS';
    AO.QFBFam.AT.ATMagnet = 'QFB';
	AO.QFBFam.AT.ATIndex = buildatindex(AO.QFB.FamilyName, Indices.QFB);
	AO.QFBFam.Position = findspos(THERING, AO.QFBFam.AT.ATIndex(:,1));
catch
	warning('QFBFam family not found in the model.');
end

try
	% QFBTrim
	AO.QFBTrim.AT.ATType = 'ShuntPS';
    AO.QFBTrim.AT.ATMagnet = 'QFB';
	AO.QFBTrim.AT.ATIndex = buildatindex(AO.QFB.FamilyName, Indices.QFB);
	AO.QFBTrim.Position = findspos(THERING, AO.QFBTrim.AT.ATIndex(:,1));
catch
	warning('QFBTrim family not found in the model.');
end

try
    % QDB2
    AO.QDB2.AT.ATType = 'Quad';
    AO.QDB2.AT.ATIndex = buildatindex(AO.QDB2.FamilyName, Indices.QDB2);
    AO.QDB2.Position = findspos(THERING, AO.QDB2.AT.ATIndex(:,1))';
catch
    warning('QDB2 family not found in the model.');
end

try
	% QDB2Fam
	AO.QDB2Fam.AT.ATType = 'FamilyPS';
    AO.QDB2Fam.AT.ATMagnet = 'QDB2';
	AO.QDB2Fam.AT.ATIndex = buildatindex(AO.QDB2.FamilyName, Indices.QDB2);
	AO.QDB2Fam.Position = findspos(THERING, AO.QDB2Fam.AT.ATIndex(:,1));
catch
	warning('QDB2Fam family not found in the model.');
end

try
	% QDB2Trim
	AO.QDB2Trim.AT.ATType = 'ShuntPS';
    AO.QDB2Trim.AT.ATMagnet = 'QDB2';
	AO.QDB2Trim.AT.ATIndex = buildatindex(AO.QDB2.FamilyName, Indices.QDB2);
	AO.QDB2Trim.Position = findspos(THERING, AO.QDB2Trim.AT.ATIndex(:,1));
catch
	warning('QDB2Trim family not found in the model.');
end

try
    % QDB1
    AO.QDB1.AT.ATType = 'Quad';
    AO.QDB1.AT.ATIndex = buildatindex(AO.QDB1.FamilyName, Indices.QDB1);
    AO.QDB1.Position = findspos(THERING, AO.QDB1.AT.ATIndex(:,1))';
catch
    warning('QDB1 family not found in the model.');
end

try
	% QDB1Fam
	AO.QDB1Fam.AT.ATType = 'FamilyPS';
    AO.QDB1Fam.AT.ATMagnet = 'QDB1';
	AO.QDB1Fam.AT.ATIndex = buildatindex(AO.QDB1.FamilyName, Indices.QDB1);
	AO.QDB1Fam.Position = findspos(THERING, AO.QDB1Fam.AT.ATIndex(:,1));
catch
	warning('QDB1Fam family not found in the model.');
end

try
	% QDB1Trim
	AO.QDB1Trim.AT.ATType = 'ShuntPS';
    AO.QDB1Trim.AT.ATMagnet = 'QDB1';
	AO.QDB1Trim.AT.ATIndex = buildatindex(AO.QDB1.FamilyName, Indices.QDB1);
	AO.QDB1Trim.Position = findspos(THERING, AO.QDB1Trim.AT.ATIndex(:,1));
catch
	warning('QDB1Trim family not found in the model.');
end

try
    % QFP
    AO.QFP.AT.ATType = 'Quad';
    AO.QFP.AT.ATIndex = buildatindex(AO.QFP.FamilyName, Indices.QFP);
    AO.QFP.Position = findspos(THERING, AO.QFP.AT.ATIndex(:,1))';
catch
    warning('QFP family not found in the model.');
end

try
	% QFPFam
	AO.QFPFam.AT.ATType = 'FamilyPS';
    AO.QFPFam.AT.ATMagnet = 'QFP';
	AO.QFPFam.AT.ATIndex = buildatindex(AO.QFP.FamilyName, Indices.QFP);
	AO.QFPFam.Position = findspos(THERING, AO.QFPFam.AT.ATIndex(:,1));
catch
	warning('QFPFam family not found in the model.');
end

try
	% QFPTrim
	AO.QFPTrim.AT.ATType = 'ShuntPS';
    AO.QFPTrim.AT.ATMagnet = 'QFP';
	AO.QFPTrim.AT.ATIndex = buildatindex(AO.QFP.FamilyName, Indices.QFP);
	AO.QFPTrim.Position = findspos(THERING, AO.QFPTrim.AT.ATIndex(:,1));
catch
	warning('QFPTrim family not found in the model.');
end

try
    % QDP2
    AO.QDP2.AT.ATType = 'Quad';
    AO.QDP2.AT.ATIndex = buildatindex(AO.QDP2.FamilyName, Indices.QDP2);
    AO.QDP2.Position = findspos(THERING, AO.QDP2.AT.ATIndex(:,1))';
catch
    warning('QDP2 family not found in the model.');
end

try
	% QDP2Fam
	AO.QDP2Fam.AT.ATType = 'FamilyPS';
    AO.QDP2Fam.AT.ATMagnet = 'QDP2';
	AO.QDP2Fam.AT.ATIndex = buildatindex(AO.QDP2.FamilyName, Indices.QDP2);
	AO.QDP2Fam.Position = findspos(THERING, AO.QDP2Fam.AT.ATIndex(:,1));
catch
	warning('QDP2Fam family not found in the model.');
end

try
	% QDP2Trim
	AO.QDP2Trim.AT.ATType = 'ShuntPS';
    AO.QDP2Trim.AT.ATMagnet = 'QDP2';
	AO.QDP2Trim.AT.ATIndex = buildatindex(AO.QDP2.FamilyName, Indices.QDP2);
	AO.QDP2Trim.Position = findspos(THERING, AO.QDP2Trim.AT.ATIndex(:,1));
catch
	warning('QDP2Trim family not found in the model.');
end

try
    % QDP1
    AO.QDP1.AT.ATType = 'Quad';
    AO.QDP1.AT.ATIndex = buildatindex(AO.QDP1.FamilyName, Indices.QDP1);
    AO.QDP1.Position = findspos(THERING, AO.QDP1.AT.ATIndex(:,1))';
catch
    warning('QDP1 family not found in the model.');
end

try
	% QDP1Fam
	AO.QDP1Fam.AT.ATType = 'FamilyPS';
    AO.QDP1Fam.AT.ATMagnet = 'QDP1';
	AO.QDP1Fam.AT.ATIndex = buildatindex(AO.QDP1.FamilyName, Indices.QDP1);
	AO.QDP1Fam.Position = findspos(THERING, AO.QDP1Fam.AT.ATIndex(:,1));
catch
	warning('QDP1Fam family not found in the model.');
end

try
	% QDP1Trim
	AO.QDP1Trim.AT.ATType = 'ShuntPS';
    AO.QDP1Trim.AT.ATMagnet = 'QDP1';
	AO.QDP1Trim.AT.ATIndex = buildatindex(AO.QDP1.FamilyName, Indices.QDP1);
	AO.QDP1Trim.Position = findspos(THERING, AO.QDP1Trim.AT.ATIndex(:,1));
catch
	warning('QDP1Trim family not found in the model.');
end

try
    % Q1
    AO.Q1.AT.ATType = 'Quad';
    AO.Q1.AT.ATIndex = buildatindex(AO.Q1.FamilyName, Indices.Q1);
    AO.Q1.Position = findspos(THERING, AO.Q1.AT.ATIndex(:,1))';
    % Q2
    AO.Q2.AT.ATType = 'Quad';
    AO.Q2.AT.ATIndex = buildatindex(AO.Q2.FamilyName, Indices.Q2);
    AO.Q2.Position = findspos(THERING, AO.Q2.AT.ATIndex(:,1))';
    % Q3
    AO.Q3.AT.ATType = 'Quad';
    AO.Q3.AT.ATIndex = buildatindex(AO.Q3.FamilyName, Indices.Q3);
    AO.Q3.Position = findspos(THERING, AO.Q3.AT.ATIndex(:,1))';
    % Q4
    AO.Q4.AT.ATType = 'Quad';
    AO.Q4.AT.ATIndex = buildatindex(AO.Q4.FamilyName, Indices.Q4);
    AO.Q4.Position = findspos(THERING, AO.Q4.AT.ATIndex(:,1))';
catch
    warning('Q1 Q2 Q3 Q4 families not found in the model.');
end

try
	% Q1Fam
	AO.Q1Fam.AT.ATType = 'FamilyPS';
    AO.Q1Fam.AT.ATMagnet = 'Q1';
	AO.Q1Fam.AT.ATIndex = buildatindex(AO.Q1.FamilyName, Indices.Q1);
	AO.Q1Fam.Position = findspos(THERING, AO.Q1Fam.AT.ATIndex(:,1));
	% Q2Fam
	AO.Q2Fam.AT.ATType = 'FamilyPS';
    AO.Q2Fam.AT.ATMagnet = 'Q2';
	AO.Q2Fam.AT.ATIndex = buildatindex(AO.Q2.FamilyName, Indices.Q2);
	AO.Q2Fam.Position = findspos(THERING, AO.Q2Fam.AT.ATIndex(:,1));
	% Q3Fam
	AO.Q3Fam.AT.ATType = 'FamilyPS';
    AO.Q3Fam.AT.ATMagnet = 'Q3';
	AO.Q3Fam.AT.ATIndex = buildatindex(AO.Q3.FamilyName, Indices.Q3);
	AO.Q3Fam.Position = findspos(THERING, AO.Q3Fam.AT.ATIndex(:,1));
	% Q4Fam
	AO.Q4Fam.AT.ATType = 'FamilyPS';
    AO.Q4Fam.AT.ATMagnet = 'Q4';
	AO.Q4Fam.AT.ATIndex = buildatindex(AO.Q4.FamilyName, Indices.Q4);
	AO.Q4Fam.Position = findspos(THERING, AO.Q4Fam.AT.ATIndex(:,1));
catch
	warning('Q1Fam Q2Fam Q3Fam Q4Fam families not found in the model.');
end

try
	% Q1Trim
	AO.Q1Trim.AT.ATType = 'ShuntPS';
    AO.Q1Trim.AT.ATMagnet = 'Q1';
	AO.Q1Trim.AT.ATIndex = buildatindex(AO.Q1.FamilyName, Indices.Q1);
	AO.Q1Trim.Position = findspos(THERING, AO.Q1Trim.AT.ATIndex(:,1));
	% Q2Trim
	AO.Q2Trim.AT.ATType = 'ShuntPS';
    AO.Q2Trim.AT.ATMagnet = 'Q2';
	AO.Q2Trim.AT.ATIndex = buildatindex(AO.Q2.FamilyName, Indices.Q2);
	AO.Q2Trim.Position = findspos(THERING, AO.Q2Trim.AT.ATIndex(:,1));
	% Q3Trim
	AO.Q3Trim.AT.ATType = 'ShuntPS';
    AO.Q3Trim.AT.ATMagnet = 'Q3';
	AO.Q3Trim.AT.ATIndex = buildatindex(AO.Q3.FamilyName, Indices.Q3);
	AO.Q3Trim.Position = findspos(THERING, AO.Q3Trim.AT.ATIndex(:,1));
	% Q4Trim
	AO.Q4Trim.AT.ATType = 'ShuntPS';
    AO.Q4Trim.AT.ATMagnet = 'Q4';
	AO.Q4Trim.AT.ATIndex = buildatindex(AO.Q4.FamilyName, Indices.Q4);
	AO.Q4Trim.Position = findspos(THERING, AO.Q4Trim.AT.ATIndex(:,1));
catch
	warning('Q1Trim Q2Trim Q3Trim Q4Trim families not found in the model.');
end

try
    % SDA0
    AO.SDA0.AT.ATType = 'Sext';
    AO.SDA0.AT.ATIndex = buildatindex(AO.SDA0.FamilyName, Indices.SDA0);
    AO.SDA0.Position = findspos(THERING, AO.SDA0.AT.ATIndex(:,1))';
catch
    warning('SDA0 family not found in the model.');
end

try
    % SDB0
    AO.SDB0.AT.ATType = 'Sext';
    AO.SDB0.AT.ATIndex = buildatindex(AO.SDB0.FamilyName, Indices.SDB0);
    AO.SDB0.Position = findspos(THERING, AO.SDB0.AT.ATIndex(:,1))';
catch
    warning('SDB0 family not found in the model.');
end

try
    % SDP0
    AO.SDP0.AT.ATType = 'Sext';
    AO.SDP0.AT.ATIndex = buildatindex(AO.SDP0.FamilyName, Indices.SDP0);
    AO.SDP0.Position = findspos(THERING, AO.SDP0.AT.ATIndex(:,1))';
catch
    warning('SDP0 family not found in the model.');
end

try
    % SDA1
    AO.SDA1.AT.ATType = 'Sext';
    AO.SDA1.AT.ATIndex = buildatindex(AO.SDA1.FamilyName, Indices.SDA1);
    AO.SDA1.Position = findspos(THERING, AO.SDA1.AT.ATIndex(:,1))';
catch
    warning('SDA1 family not found in the model.');
end

try
    % SDB1
    AO.SDB1.AT.ATType = 'Sext';
    AO.SDB1.AT.ATIndex = buildatindex(AO.SDB1.FamilyName, Indices.SDB1);
    AO.SDB1.Position = findspos(THERING, AO.SDB1.AT.ATIndex(:,1))';
catch
    warning('SDB1 family not found in the model.');
end

try
    % SDP1
    AO.SDP1.AT.ATType = 'Sext';
    AO.SDP1.AT.ATIndex = buildatindex(AO.SDP1.FamilyName, Indices.SDP1);
    AO.SDP1.Position = findspos(THERING, AO.SDP1.AT.ATIndex(:,1))';
catch
    warning('SDP1 family not found in the model.');
end

try
    % SDA2
    AO.SDA2.AT.ATType = 'Sext';
    AO.SDA2.AT.ATIndex = buildatindex(AO.SDA2.FamilyName, Indices.SDA2);
    AO.SDA2.Position = findspos(THERING, AO.SDA2.AT.ATIndex(:,1))';
catch
    warning('SDA2 family not found in the model.');
end

try
    % SDB2
    AO.SDB2.AT.ATType = 'Sext';
    AO.SDB2.AT.ATIndex = buildatindex(AO.SDB2.FamilyName, Indices.SDB2);
    AO.SDB2.Position = findspos(THERING, AO.SDB2.AT.ATIndex(:,1))';
catch
    warning('SDB2 family not found in the model.');
end

try
    % SDP2
    AO.SDP2.AT.ATType = 'Sext';
    AO.SDP2.AT.ATIndex = buildatindex(AO.SDP2.FamilyName, Indices.SDP2);
    AO.SDP2.Position = findspos(THERING, AO.SDP2.AT.ATIndex(:,1))';
catch
    warning('SDP2 family not found in the model.');
end

try
    % SDA3
    AO.SDA3.AT.ATType = 'Sext';
    AO.SDA3.AT.ATIndex = buildatindex(AO.SDA3.FamilyName, Indices.SDA3);
    AO.SDA3.Position = findspos(THERING, AO.SDA3.AT.ATIndex(:,1))';
catch
    warning('SDA3 family not found in the model.');
end

try
    % SDB3
    AO.SDB3.AT.ATType = 'Sext';
    AO.SDB3.AT.ATIndex = buildatindex(AO.SDB3.FamilyName, Indices.SDB3);
    AO.SDB3.Position = findspos(THERING, AO.SDB3.AT.ATIndex(:,1))';
catch
    warning('SDB3 family not found in the model.');
end

try
    % SDP3
    AO.SDP3.AT.ATType = 'Sext';
    AO.SDP3.AT.ATIndex = buildatindex(AO.SDP3.FamilyName, Indices.SDP3);
    AO.SDP3.Position = findspos(THERING, AO.SDP3.AT.ATIndex(:,1))';
catch
    warning('SDP3 family not found in the model.');
end

try
    % SFA0
    AO.SFA0.AT.ATType = 'Sext';
    AO.SFA0.AT.ATIndex = buildatindex(AO.SFA0.FamilyName, Indices.SFA0);
    AO.SFA0.Position = findspos(THERING, AO.SFA0.AT.ATIndex(:,1))';
catch
    warning('SFA0 family not found in the model.');
end

try
    % SFB0
    AO.SFB0.AT.ATType = 'Sext';
    AO.SFB0.AT.ATIndex = buildatindex(AO.SFB0.FamilyName, Indices.SFB0);
    AO.SFB0.Position = findspos(THERING, AO.SFB0.AT.ATIndex(:,1))';
catch
    warning('SFB0 family not found in the model.');
end

try
    % SFP0
    AO.SFP0.AT.ATType = 'Sext';
    AO.SFP0.AT.ATIndex = buildatindex(AO.SFP0.FamilyName, Indices.SFP0);
    AO.SFP0.Position = findspos(THERING, AO.SFP0.AT.ATIndex(:,1))';
catch
    warning('SFP0 family not found in the model.');
end

try
    % SFA1
    AO.SFA1.AT.ATType = 'Sext';
    AO.SFA1.AT.ATIndex = buildatindex(AO.SFA1.FamilyName, Indices.SFA1);
    AO.SFA1.Position = findspos(THERING, AO.SFA1.AT.ATIndex(:,1))';
catch
    warning('SFA1 family not found in the model.');
end

try
    % SFB1
    AO.SFB1.AT.ATType = 'Sext';
    AO.SFB1.AT.ATIndex = buildatindex(AO.SFB1.FamilyName, Indices.SFB1);
    AO.SFB1.Position = findspos(THERING, AO.SFB1.AT.ATIndex(:,1))';
catch
    warning('SFB1 family not found in the model.');
end

try
    % SFP1
    AO.SFP1.AT.ATType = 'Sext';
    AO.SFP1.AT.ATIndex = buildatindex(AO.SFP1.FamilyName, Indices.SFP1);
    AO.SFP1.Position = findspos(THERING, AO.SFP1.AT.ATIndex(:,1))';
catch
    warning('SFP1 family not found in the model.');
end

try
    % SFA2
    AO.SFA2.AT.ATType = 'Sext';
    AO.SFA2.AT.ATIndex = buildatindex(AO.SFA2.FamilyName, Indices.SFA2);
    AO.SFA2.Position = findspos(THERING, AO.SFA2.AT.ATIndex(:,1))';
catch
    warning('SFA2 family not found in the model.');
end

try
    % SFB2
    AO.SFB2.AT.ATType = 'Sext';
    AO.SFB2.AT.ATIndex = buildatindex(AO.SFB2.FamilyName, Indices.SFB2);
    AO.SFB2.Position = findspos(THERING, AO.SFB2.AT.ATIndex(:,1))';
catch
    warning('SFB2 family not found in the model.');
end

try
    % SFP2
    AO.SFP2.AT.ATType = 'Sext';
    AO.SFP2.AT.ATIndex = buildatindex(AO.SFP2.FamilyName, Indices.SFP2);
    AO.SFP2.Position = findspos(THERING, AO.SFP2.AT.ATIndex(:,1))';
catch
    warning('SFP2 family not found in the model.');
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
    AO.CH.AT.ATIndex = family_data.CH.ATIndex;
    AO.CH.Position   = findspos(THERING, AO.CH.AT.ATIndex(:,1))';   
catch
    warning('CH family not found in the model.');
end

try
    % CV
    AO.CV.AT.ATType = 'VCM';
    AO.CV.AT.ATIndex = family_data.CV.ATIndex;
    AO.CV.Position   = findspos(THERING, AO.CV.AT.ATIndex(:,1))';   
catch
    warning('CV family not found in the model.');
end

try
    % FCH
    AO.FCH.AT.ATType = 'HCM';
    AO.FCH.AT.ATIndex = family_data.FCH.ATIndex;
    AO.FCH.Position   = findspos(THERING, AO.FCH.AT.ATIndex(:,1))';   
catch
    warning('FCH family not found in the model.');
end

try
    % FCV
    AO.FCV.AT.ATType = 'VCM';
    AO.FCV.AT.ATIndex = family_data.FCV.ATIndex;
    AO.FCV.Position   = findspos(THERING, AO.FCV.AT.ATIndex(:,1))';   
catch
    warning('FCV family not found in the model.');
end

try
    % QS
    AO.QS.AT.ATType = 'SKEWQUAD';
    AO.QS.AT.ATIndex = family_data.QS.ATIndex;
    AO.QS.Position   = findspos(THERING, AO.QS.AT.ATIndex(:,1))';   
catch
    warning('QS family not found in the model.');
end

% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end

% DCCT
try
    AO.DCCT.AT.ATType = 'DCCT';
    AO.DCCT.AT.ATIndex = findcells(THERING, 'FamName', 'DCCT')';
    AO.DCCT.Position = findspos(THERING, AO.DCCT.AT.ATIndex(:,1))';
catch
    warning('DCCT not found in the model.');
end


setao(AO);
