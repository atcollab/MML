function ALSIRLattice
% *******************************
% *                             *
% *    IR Storage Ring at ALS   *
% *  The IDEAL LATTICE updated  *
% *                             *
% *******************************

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 0.7e9;
GLOBVAL.LatticeFile = 'irring_60m';
FAMLIST = cell(0);
disp(' ');
disp('** Loading IR Ring magnet lattice');


L0 = 60.0;	% design length [m]
C0 = 299792458; 				% speed of light [m/s]
HarmNumber = 10;
CAV	= rfcavity('CAV1' , 0 , 5e+4 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');   


%{***** drift space *****}
D1  = drift('D1', 1.45   , 'DriftPass');
D2  = drift('D2', 0.25   , 'DriftPass');
D3  = drift('D3', 0.45   , 'DriftPass');
D4  = drift('D4', 0.642475, 'DriftPass');


D4A = drift('D4A', 0.2,          'DriftPass');
D4B = drift('D4B', 0.642475-0.3, 'DriftPass');
D5A = drift('D5A', 0.2,          'DriftPass');
D5B = drift('D5B', 0.642475-0.3, 'DriftPass');


%** Quadrupoles **
QF1   = quadrupole('QF1' , 0.3,  2.506167, 'StrMPoleSymplectic4RadPass');
QD1   = quadrupole('QD1' , 0.3, -2.246983, 'StrMPoleSymplectic4RadPass');
QF2   = quadrupole('QF2' , 0.3,  3.866080, 'StrMPoleSymplectic4RadPass');

% 
BEND = rbend('BND' , 0.815051,...
       30.0*pi/180, 15.0*pi/180, 15.0*pi/180, 0.0, 'BndMPoleSymplectic4RadPass');


%** Sextupoles ** set strength to 0 chromaticity
SF = sextupole('SF',  0.20, 56.29555/2, 'StrMPoleSymplectic4RadPass');
SD = sextupole('SD',  0.20,-73.16774/2, 'StrMPoleSymplectic4RadPass');

%{**  Superperiod  **}
HSUP1 = [D1  QF1  D2  QD1  D3  BEND  D4A  SD  D4B  D5A  SF  D5B  QF2];
HSUP2 = [D5B  SF  D5A  D4B  SD  D4A  BEND  D3  QD1  D2  QF1  D1];
SUP = [HSUP1 HSUP2];

ELIST=[SUP SUP SUP SUP SUP SUP CAV];
THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Done **');

