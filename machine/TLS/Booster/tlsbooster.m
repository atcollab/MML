function tlsbooster
% TLS booster lattice
% Created by F.H. Tseng 2010/10/07

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 1.5e9; % Energy = 1.5e9;
FAMLIST = cell(0);

% AP       =  aperture('AP',  [-0.0175, 0.0175, -0.01, 0.01],'AperturePass');
 
L0 = 72;		% design length [m]
C0 =   299792458; 	% speed of light [m/s]
HarmNumber = 120;
BRCAVITY = rfcavity('RF', 0.2, 0.8e+6, HarmNumber*C0/L0, HarmNumber,'CavityPass'); 
% BRCAVITY = rfcavity('RF', 0.2, 0.8e+6, 497961880.322446, HarmNumber,'CavityPass'); 

% BPM #24
BPM  =  marker('BPM','IdentityPass');
BRBPM11  = BPM;
BRBPM12  = BPM;
BRBPM21  = BPM;
BRBPM22  = BPM;
BRBPM31  = BPM;
BRBPM32  = BPM;
BRBPM41  = BPM;
BRBPM42  = BPM;
BRBPM51  = BPM;
BRBPM52  = BPM;
BRBPM61  = BPM;
BRBPM62  = BPM;
BRBPM71  = BPM;
BRBPM72  = BPM;
BRBPM81  = BPM;
BRBPM82  = BPM;
BRBPM91  = BPM;
BRBPM92  = BPM;
BRBPM101  = BPM;
BRBPM102  = BPM;
BRBPM111  = BPM;
BRBPM112  = BPM;
BRBPM121  = BPM;
BRBPM122  = BPM;

% Horizontal Corrector #60
HCOR =  corrector('HCOR',0.0,[0 0],'CorrectorPass');
HC1 = HCOR;
HC2 = HCOR;
HC3 = HCOR;
HC4 = HCOR;
HC5 = HCOR;
HC6 = HCOR;
HC7 = HCOR;
HC8 = HCOR;
HC9 = HCOR;
HC10 = HCOR;
HC11 = HCOR;
HC12 = HCOR;

% Vertical Corrector #36
VCOR =  corrector('VCOR',0.0,[0 0],'CorrectorPass');
VC1 = VCOR;
VC2 = VCOR;
VC3 = VCOR;
VC4 = VCOR;
VC5 = VCOR;
VC6 = VCOR;
VC7 = VCOR;
VC8 = VCOR;
VC9 = VCOR;
VC10 = VCOR;
VC11 = VCOR;
VC12 = VCOR;

% Drifts
BRD1 = drift('BRD1' ,0.1705,'DriftPass');
BRD2 = drift('BRD2' ,0.0595,'DriftPass');
BRD3 = drift('BRD3' ,0.1500,'DriftPass');
BRD4 = drift('BRD4' ,1.0200,'DriftPass');
BRD41 = drift('BRD41' ,0.9200,'DriftPass');
BRD5 = drift('BRD5' ,0.5085,'DriftPass');
BRD6 = drift('BRD6' ,0.5115,'DriftPass');
BRD7 = drift('BRD7' ,0.8300,'DriftPass');
BRD8 = drift('BRD8' ,0.1900,'DriftPass');
BRD9 = drift('BRD9' ,0.4605,'DriftPass');
BRD10 = drift('BRD10' ,0.5595,'DriftPass');
BRD11 = drift('BRD11' ,0.7625,'DriftPass');
BRD12 = drift('BRD12' ,0.2575,'DriftPass');
BRD13 = drift('BRD13' ,0.9075,'DriftPass');
BRD14 = drift('BRD14' ,0.1125,'DriftPass');
BRD15 = drift('BRD15' ,0.2300,'DriftPass');
BRD16 = drift('BRD16' ,0.6565,'DriftPass');
BRD17 = drift('BRD17' ,0.3635,'DriftPass');
BRD18 = drift('BRD18' ,0.2280,'DriftPass');
BRD19 = drift('BRD19' ,0.4285,'DriftPass');
BRD20 = drift('BRD20' ,0.9075,'DriftPass');
BRD21 = drift('BRD21' ,0.1125,'DriftPass');
BRD22 = drift('BRD22' ,0.1630,'DriftPass');
BRD23 = drift('BRD23' ,0.8570,'DriftPass');

% Dipoles
BRBML = rbend('BD', 1.2, 0.261799387, 0.261799387, 0, 0, 'BendLinearPass');
BRBMR = rbend('BD', 1.2, 0.261799387, 0, 0.261799387, 0, 'BendLinearPass');

% Quadrupoles
BRQF = quadrupole('QF',0.3, 2.19295, 'QuadLinearPass');
BRQD = quadrupole('QD',0.3, -1.208561, 'QuadLinearPass');

BRSFQ = quadrupole('SFQ',0.05, 0, 'QuadLinearPass');
BRSDQ = quadrupole('SDQ',0.05, 0, 'QuadLinearPass');

% Sextupoles
BRSF  =  marker('BRSF','IdentityPass');
BRSD  =  marker('BRSD','IdentityPass');

BRINJKIC  =  marker('BRINJKIC','IdentityPass');
BREXTKIC  =  marker('BREXTKIC','IdentityPass');
BRVIEWER  =  marker('BRVIEWER','IdentityPass');
BRVIEWWR  =  marker('BRVIEWWR','IdentityPass');
BRSPL1  =  marker('BRSPL1','IdentityPass');
BRSPL2  =  marker('BRSPL2','IdentityPass');
BRBUMP1  =  marker('BRBUMP1','IdentityPass');
BRBUMP2  =  marker('BRBUMP2','IdentityPass');
BRBUMP3  =  marker('BRBUMP3','IdentityPass');
BRDCCT  =  marker('BRDCCT','IdentityPass');
ESPTI  =  marker('ESPTI','IdentityPass');

SEC1 = [BRBMR,BRD1,BRBPM11,HC1,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD4,BRD4,...
BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC1,BRBPM12,BRD1,BRBML];
SEC2 = [BRBMR,BRD1,BRBPM21,HC2,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD4,BRINJKIC,...
BRD5,BRVIEWER,BRD6,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC2,BRBPM22,BRD1,BRBML];
SEC3 = [BRBMR,BRD1,BRBPM31,HC3,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD41,BRCAVITY,...
BRD41,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC3,BRBPM32,BRD1,BRBML];
SEC4 = [BRBMR,BRD1,BRBPM41,HC4,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD7,BRSPL1,...
BRD8,BRD9,BRVIEWER,BRD10,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC4,BRBPM42,BRD1,BRBML];
SEC5 = [BRBMR,BRD1,BRBPM51,HC5,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD11,BRSPL2,...
BRD12,BRD4,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC5,BRBPM52,BRD1,BRBML];
SEC6 = [BRBMR,BRD1,BRBPM61,HC6,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD13,...
BRVIEWER,BRD14,BRD4,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC6,BRBPM62,BRD1,BRBML];
SEC7 = [BRBMR,BRD1,BRBPM71,HC7,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD4,BRD4,BRSDQ,BRSD,...
BRSDQ,BRD3,BRQD,BRD2,VC7,BRBPM72,BRD1,BRBML];
SEC8 = [BRBMR,BRD1,BRBPM81,HC8,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD4,...
BREXTKIC,BRD16,BRBUMP1,BRD17,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC8,BRBPM82,BRD1,BRBML];
SEC9 = [BRBMR,BRD1,BRBPM91,HC9,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD22,ESPTI,...
BRD23,BRD16,BRBUMP2,BRD17,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC9,BRBPM92,BRD1,BRBML];
SEC10 = [BRBMR,BRD1,BRBPM101,HC10,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD4,BRD18,...
BRDCCT,BRD19,BRBUMP3,BRD17,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC10,BRBPM102,BRD1,BRBML];
SEC11 = [BRBMR,BRD1,BRBPM111,HC11,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD20,...
BRVIEWER,BRD21,BRD4,BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC11,BRBPM112,BRD1,BRBML];
SEC12 = [BRBMR,BRD1,BRBPM121,HC12,BRD2,BRQF,BRD3,BRSFQ,BRSF,BRSFQ,BRD4,BRD4,...
BRSDQ,BRSD,BRSDQ,BRD3,BRQD,BRD2,VC12,BRBPM122,BRD1,BRBML];

BOOSTER = [SEC1,SEC2,SEC3,SEC4,SEC5,SEC6,SEC7,SEC8,SEC9,SEC10,SEC11,SEC12];

buildlat(BOOSTER);

% Newer AT versions requires 'Energy' to be an AT field
%THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), GLOBVAL.E0);

% Compute total length and RF frequency
L0_tot=0;
for i=1:length(THERING)
    L0_tot=L0_tot+THERING{i}.Length;
end
fprintf('   Model booster circumference is %.6f meters\n', L0_tot)

findspos(THERING,1:length(THERING)+1);

%atsummary;

if nargout
    varargout{1} = THERING;
end


clear global FAMLIST 

% LOSSFLAG is not global in AT1.3
evalin('base','clear LOSSFLAG');   % Unfortunately it will come back
