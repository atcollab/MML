function ALSLattice
% *******************************
% *                             *
% *       ALS Storage Ring      *
% *  The IDEAL LATTICE updated  *
% *                             *
% *******************************

fprintf('   Loading ALS lattice in %s\n', mfilename);

global FAMLIST THERING GLOBVAL
Energy = 1.89086196873342e9;
GLOBVAL.E0 = Energy;
GLOBVAL.LatticeFile = 'als_short';
FAMLIST = cell(0);



L0 = 196.8000096;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 328;
CAV	= rfcavity('CAV1' , 0 , 1.5e+6 , HarmNumber*C0/L0, HarmNumber ,'CavityPass');   


%{***** drift space *****}
D1  = drift('D1', 3.378695 , 'DriftPass');
D2  = drift('D2', 0.4345   , 'DriftPass');
D3  = drift('D3', 0.348698 , 'DriftPass');
D4  = drift('D4', 0.2156993, 'DriftPass');
D5  = drift('D5', 0.3245   , 'DriftPass');
D6  = drift('D6', 0.1245   , 'DriftPass');
D7  = drift('D7', 0.6906981, 'DriftPass');
DS  = drift('DS', 0.1015   , 'DriftPass'); % Half the sextupole length

%** Quadrupoles **
QF    = quadrupole('QF' , 0.344,  2.2474, 'StrMPoleSymplectic4RadPass');
QD    = quadrupole('QD' , 0.187, -2.3368, 'StrMPoleSymplectic4RadPass');
QFA   = quadrupole('QFA', 0.448,  2.8856, 'StrMPoleSymplectic4RadPass');

% 
BEND = rbend('BEND' , 2*0.43257,...
       10.0*pi/180, 5.0*pi/180, 5.0*pi/180, -0.7787, 'BndMPoleSymplectic4RadPass');


%** Sextupoles ** set strength to 0 chromaticity
SF = sextupole('SFF',  0.203,55.8726, 'StrMPoleSymplectic4RadPass');
SD = sextupole('SDD',  0.203,-41.4679, 'StrMPoleSymplectic4RadPass');

%{**  Superperiod  **}
SUP =    [D1  QF  D2  QD D3   BEND D4 SD D5 ...
          QFA D6  SF  D7 BEND D7   SF D6 ...
          QFA D5  SD  D4 BEND D3   QD D2 QF D1];

ELIST=[SUP SUP SUP SUP SUP SUP SUP SUP SUP SUP SUP SUP CAV];
THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end


% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
% L0_tot=0;
% for i=1:length(THERING)
%     L0_tot=L0_tot+THERING{i}.Length;
% end
fprintf('   L0 = %.6f m   (should be 196.805415 m)\n', L0_tot)
fprintf('   RF = %.6f MHz (should be 499.640349 Hz)\n', HarmNumber*C0/L0_tot/1e6)



% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


% New AT does not use FAMLIST
clear global FAMLIST
