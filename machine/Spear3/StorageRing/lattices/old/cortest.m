function cortest

clear all

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = 'cortest';
FAMLIST = cell(0);

disp(' ');
disp('** Loading corrector test magnet lattice');
AP   =  aperture('AP', [-0.05, 0.05, -0.05, 0.05],'AperturePass');
COR  =	quadrupole('COR' ,0.20,0.0,'QuadLinearPass');
BPM  =  marker('BPM','IdentityPass');
D1   =  drift('D1' ,1.0,'DriftPass');

ELIST=	[AP COR BPM D1 BPM]; 

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end
evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Finished loading lattice in Accelerator Toolbox **');

%Find Corrector indices, change passmethod add first order multipole field
CORI = findcells(THERING,'FamName','COR');
THERING = setcellstruct(THERING,'PassMethod',CORI,'StrMPoleSymplectic4Pass');
THERING = setcellstruct(THERING,'NumIntSteps',CORI,1);
THERING = setcellstruct(THERING,'MaxOrder',CORI,1);

%add field to first corrector
kick=0.001;
THERING =setcellstruct(THERING,'PolynomA',CORI(1),kick,1);
THERING =setcellstruct(THERING,'PolynomB',CORI(1),kick,1);
THERING(CORI(1));

%pass ray
ri=[0 0 0 0 0 0]';
rf=ringpass(THERING,ri,1);

%get angles (angle should be PolynomA * length)
disp(['corrector kick  : ' num2str(kick)]);
disp(['horizontal angle: ' num2str(rf(2))]);
disp(['vertical angle  : ' num2str(rf(4))]);









