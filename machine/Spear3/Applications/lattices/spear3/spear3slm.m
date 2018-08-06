function spear3slm
% spear III Lattice definition file
% to analyze coupling diagnostics and correction with
% skew quadrupoles and Synchrotron Light Monitor

% In spear III skew quadrupoles are  extra windings
% on the sextupole magnets.
% In Accelerator Toolbox the skew-quad term of magnetic field
% is set by PolynomA(1) = Kskew


global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 3e9;	% Design Energy [eV]
GLOBVAL.LatticeFile = 'spear3slm';





FAMLIST = cell(0);

disp(' ');
disp('** Loading SPEAR-III lattice in SPEAR3SLM.m **');
%%AP = marker('AP', 'AperturePass');

L0 = 2.341440127200002e+002;	% design length [m]
C0 =   299792458; 				% speed of light [m/s]
HarmNumber = 372;
CAV	= rfcavity('CAV1' , 1.5 , 0.8e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');   
SLM	= marker('SLM', 'IdentityPass');
BL4	= marker('BL4', 'IdentityPass'); 
BL5	= marker('BL5', 'IdentityPass');
BL6	= marker('BL6', 'IdentityPass');
BL7  	= marker('BL7', 'IdentityPass');
BL9	= marker('BL9', 'IdentityPass');
BL10	= marker('BL10', 'IdentityPass');
BL11	= marker('BL11', 'IdentityPass');
BL12	= marker('BL12', 'IdentityPass');
BL13	= marker('BL13', 'IdentityPass');


AP = marker('AP', 'IdentityPass');


% DRIFT SPACES
DC1   =    drift('DC1' ,1.53667,'DriftPass');
DC2	= 		drift('DC2' ,0.395,'DriftPass');
DC3   =    drift('DC3' ,0.25,'DriftPass');
DC4   =    drift('DC4' ,0.23,'DriftPass');
DC5   =    drift('DC5' ,0.601972,'DriftPass');
DC6   =    drift('DC6' ,0.18,'DriftPass');

DM1	=	drift('DM1' ,3.810000,'DriftPass');
DM2	=	drift('DM2' ,0.39,'DriftPass');
DM3	=	drift('DM3' ,0.28,'DriftPass');
DM4	=	drift('DM4' ,0.25,'DriftPass');
DM5	=	drift('DM5' ,0.25,'DriftPass');
DM6	=	drift('DM6' , 1.11136926 ,'DriftPass');
DM7	=	drift('DM7' ,0.25,'DriftPass');
DM8	=	drift('DM8' ,0.5 ,'DriftPass');
DM9	=	drift('DM9' ,0.41,'DriftPass');
DM10	=	drift('DM10' ,3.27657140,'DriftPass');

DMRF	=	drift('DM10' ,0.81,'DriftPass');




% QUADRUPOLES 

QF		=	quadrupole('QF'  , 0.34, 1.815761626091 ,'StrMPoleSymplectic4RadPass');
QD		=	quadrupole('QD' , 0.15, -1.580407879319 ,'StrMPoleSymplectic4RadPass');
% QFC is the symmetry point of standard cell ACEL
% to reduce the total number of elements
% Use QFC length 0.5  in stead of two QFC 0.25 m long back to back 
QFC	=	quadrupole('QFC' , 0.5, 1.786614951331 ,'StrMPoleSymplectic4RadPass');

QDX 	=	quadrupole('QDX'  , 0.34, -1.437770016116 ,'StrMPoleSymplectic4RadPass');
QFX 	=	quadrupole('QFX'  , 0.6, 1.588310523065 ,'StrMPoleSymplectic4RadPass');

QDY 	=	quadrupole('QDY'  , 0.34, -0.460196515928 ,'StrMPoleSymplectic4RadPass');
QFY 	=	quadrupole('QFY'  , 0.5, 1.514741504629 ,'StrMPoleSymplectic4RadPass');

QDZ 	=	quadrupole('QDZ'  , 0.34, -0.905396617422,'StrMPoleSymplectic4RadPass');
QFZ 	=	quadrupole('QFZ'  , 0.34, 1.479267960323 ,'StrMPoleSymplectic4RadPass');




% SEXTUPOLES


SD		=	sextupole('SD' , 0.25,-18,'StrMPoleSymplectic4RadPass');
SF		=	sextupole('SF'  , 0.21, 16,'StrMPoleSymplectic4RadPass');

SDI	=	sextupole('SDI' , 0.21,-8.5,'StrMPoleSymplectic4RadPass');
SFI	=	sextupole('SFI'  , 0.21, 7.5,'StrMPoleSymplectic4RadPass');


% DIPOLES (COMBINED FUNCTION)

lBB 		= 1.45;
phiBB 	= 0.184799567858;
larcBB 	= lBB*phiBB/(2*sin(phiBB/2));
larcBB	= 1.45206534;

BND		=	rbend('BND' , larcBB, phiBB, phiBB/2, phiBB/2, -0.33,'BndMPoleSymplectic4RadPass');
 

l34 		= 0.75*lBB;
phi34 	= 0.75*phiBB;
larc34 	= l34*phi34/(2*sin(phi34/2));
larc34 	=	1.08837094;

%B34		= rbend('B34'  , larc34,  ...
%		   phi34, phi34/2, phi34/2, -0.33,'BndMPoleSymplectic4RadPass');
         
% three quarter bend with a source point 
% Upstream
sourcepos = 0.8; 	% poostiton of the SLM bend source point from the entance 
						% as a percentage of total arc length
B34U		= rbend('B34U'  , larc34*sourcepos,  ...
            phi34*sourcepos, phi34/2, 0, -0.33,'BndMPoleSymplectic4RadPass');
% Downstream
B34D		= rbend('B34D'  , larc34*(1-sourcepos),  ...
            phi34*(1-sourcepos), 0, phi34/2, -0.33,'BndMPoleSymplectic4RadPass');









% Begin Lattice


ACEL	=  [ DC1 QF DC2 QD DC3 BND DC4 SD DC5 SF DC6 QFC ... 
   			reverse([DC1 QF DC2 QD DC3 BND DC4 SD DC5 SF DC6])];

SEVEN	=	[ACEL ACEL ACEL ACEL ACEL ACEL ACEL];

B34S	=	[ B34U SLM B34D ];  

IR		=	[ DM1 QDX DM2 QFX DM3 QDY DM4 B34S DM5 SDI DM6 SFI DM7 QFY ...
 			 	DM7 SFI DM6 SDI DM5 B34S DM8 QDZ DM9 QFZ DM10]; 
        
IR1	=	[ DM1 QDX DM2 QFX DM3 QDY DM4 reverse(B34S) DM5 SDI DM6...
				SFI DM7 QFY DM7 SFI DM6 SDI DM5 reverse(B34S) ...
				DM8 QDZ DM9 QFZ DM10]; 

        
% Insertion Region with the wirst drift containing 2 RF cavities        
RFIR	=	[ CAV CAV DMRF QDX DM2 QFX DM3 QDY DM4 B34S DM5 SDI DM6 SFI DM7 QFY ...
    				DM7 SFI DM6 SDI DM5 B34S DM8 QDZ DM9 QFZ DM10];
             
RFIR1=	[ CAV CAV DMRF QDX DM2 QFX DM3 QDY DM4 reverse(B34S)...
				DM5 SDI DM6 SFI DM7 QFY DM7 SFI DM6 SDI DM5 ...
         reverse(B34S) DM8 QDZ DM9 QFZ DM10];
     
        
% Only the ID source points
%ELIST	=	[RFIR SEVEN reverse(IR) IR SEVEN reverse(RFIR) ]; 

% SLM source points inside a three quarter bends 
ELIST	=	[RFIR BL13 ACEL  BL12 ACEL BL11 ACEL ACEL BL4 ...
      		ACEL BL5 ACEL BL6 ACEL reverse(IR1) IR ...
   			ACEL BL9 ACEL BL10 ACEL ACEL ACEL ACEL ACEL reverse(RFIR1)]; 





THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end



 
evalin('caller','global THERING FAMLIST GLOBVAL' );
disp('** Done **');








