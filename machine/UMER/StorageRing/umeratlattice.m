function umeratlattice
% This constructs a single particle simulation of the UMER ring
% everything is stored in the global variable 'THERING'
%
% written by Levon
% updated May 2017
%
% Notes
% All the dipole and quadrupole lengths are effective lengths
% Need to figure out how to properly model earth's field
%

global FAMLIST THERING GLOBVAL

Energy = 9967.08077; % 10kev beam
GLOBVAL.E0 = Energy;
GLOBVAL.LatticeFile = 'umeratlattice';
FAMLIST = cell(0);


fprintf('   Loading UMER magnet lattice\n');
AP =  aperture('AP',  [-0.025, 0.025, -0.025, 0.025],'AperturePass');

L0 = 11.52;	% design length [m]
C0 = 299792458; % speed of light [m/s]

% standard magnet effective lengths
RSV_l_eff = 0.05670; Q_l_eff = 0.04475; rBend_l_eff = 0.03819; SSV_l_eff = 0.03063;

% vcm and bpm
COR =  corrector('VCM',0.05670,[0 0],'CorrectorPass');
SCOR = corrector('VCM',0.03063,[0 0],'CorrectorPass'); % short corrector
BPM  = marker('BPM','IdentityPass');

% Standard cell drifts
DC2l = .08-Q_l_eff/2-rBend_l_eff/2;
DC1 = drift('Drift',.08-RSV_l_eff/2-Q_l_eff/2,'DriftPass'); % drift distance between vcm & quads
DC2 = drift('Drift',.08-Q_l_eff/2-rBend_l_eff/2,'DriftPass'); % drift distance between quad and dipoles
DC3 = drift('Drift',.08-Q_l_eff/2,'DriftPass'); % drift distance between quad and centered BPM
DC4 = drift('Drift',DC2l/2-SSV_l_eff/2,'DriftPass'); % drift distance ssv and dipole/quad

% Standard cell dipoles
% actual dipoles only bend about 70% of this value as earth's field bends
% the rest
BND = rbend('dipole',rBend_l_eff,0.174532952,0.174532952/2,0.174532952/2,0,'BndMPoleSymplectic4Pass'); % 10 degree nominal bends

% Standard cell quadrupoles
KQF = 162.7372; % use current2quadstrength to find values
KQD = -162.7372;
QF = quadrupole('QF',Q_l_eff,KQF,'StrMPoleSymplectic4Pass');
QD = quadrupole('QD',Q_l_eff,KQD,'StrMPoleSymplectic4Pass');

% Standard Cell:
CEL1 = [COR DC1 QD DC2 BND DC2 QF DC3 BPM DC3 QD DC2 BND DC2 QF DC1];

% Standard with no BPM
CEL2 = [COR DC1 QD DC2 BND DC2 QF DC3 DC3 QD DC2 BND DC2 QF DC1];

% extra COR Cell
CEL3 = [COR DC1 QD DC2 BND DC4 SCOR DC4 QF DC3 BPM DC3 QD DC4 SCOR DC4 BND DC2 QF DC1];

%%%

% Y (injection) section magnet lengths and values
KQR1 = 123.1216;
KYQ = -160.3151;
SDR6_l_eff = 0.03063;
YQ_l_eff = 0.05999;
QR_l_eff = 0.05999;
PDRec_l_eff = 0.05006;
drift_Quad_to_SDR6 = .031-Q_l_eff/2-SDR6_l_eff/2;
drift_SDR6_to_YQ = 0.129-SDR6_l_eff/2-YQ_l_eff/2;
drift_YQ_to_PD = .08-YQ_l_eff/2-PDRec_l_eff/2;
drift_PD_to_QR1 = .08-PDRec_l_eff/2-QR_l_eff/2;
drift_QR1_to_end = .08-QR_l_eff/2;

% Y section drifts
DCY1 = drift('drift',drift_Quad_to_SDR6,'DriftPass');
DCY2 = drift('drift',drift_SDR6_to_YQ,'DriftPass');
DCY3 = drift('drift',drift_YQ_to_PD,'DriftPass');
DCY4 = drift('drift',drift_PD_to_QR1,'DriftPass');
DCY5 = drift('drift',drift_QR1_to_end,'DriftPass');

% Y section magnets
COR_SDH6 = corrector('HCM',SDR6_l_eff,[0,0],'CorrectorPass');
PDRec = rbend('dipole',PDRec_l_eff,0.10472,0.10472/2,0.10472/2,0,'BndMPoleSymplectic4Pass');
YQ  = quadrupole('QD',YQ_l_eff,+KYQ,'StrMPoleSymplectic4Pass');
QF1 = quadrupole('QF',QR_l_eff,KQR1,'StrMPoleSymplectic4Pass');

% Y (injection) section Cell
CELY = [COR DC1 QD DC2 BND DC2 QF DCY1 COR_SDH6 DCY2 YQ DCY3 PDRec DCY4 QF1 DCY5];

%%%

% Begin lattice
ELIST = [CEL1 CEL1 CEL1 CEL2 CEL3 CEL3 CEL3 CEL3 CEL3 CEL2 CEL3 CEL1 CEL1 CEL1 CEL1 CEL2 CEL1 CELY];

buildlat(ELIST);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

% misalignments
% add in the misalignments in YQ
if 0
    yq_idx = 296;
    dx = 0.01389; dy=0;
    ds = -0.00123413;
    dtheta_y = -0.174533;
    addsshift(yq_idx, ds);
    addshift(yq_idx,dx,dy);
    addyrot(yq_idx, dtheta_y)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

evalin('caller','global THERING FAMLIST GLOBVAL');









