function varargout = alsn(varargin)
% Lattice definition file
% Christoph Steier 01/10/2003
%

global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = 1.9e9;
GLOBVAL.LatticeFile = 'alsn';
FAMLIST = cell(0);
disp(' ');
disp('** Loading ALS-N lattice in alsn.m **');


L0 = 211.145040;            	% design length [m]
C0 =   299792458; 				% speed of light [m/s]

%%% RF system 

HarmNumber = 352;
CAV	= rfcavity('CAV1' , 0 , 1.5e+6 , HarmNumber*C0/L0, HarmNumber ,'ThinCavityPass');   


%%% correctors and BPMs

COR =  corrector('COR',0.0,[0 0],'CorrectorPass');
BPM =  marker('BPM','IdentityPass');

%% Marker and apertures

   INJ = aperture('INJ',[-0.03 0.03 -0.0025 0.0025],'AperturePass');


% DRIFT SPACES
   L1A = drift('L1A',  1.9/2, 'DriftPass');
   L1B = drift('L1B',  2.9/2, 'DriftPass');
   L2 = drift('L2',  0.2, 'DriftPass');


% QUADRUPOLES 

QF		=	quadrupole('QF'  , 0.3, 2.989288 ,'StrMPoleSymplectic4RadPass');

SF   =  sextupole('SF', 0.2, 54.39004/2, 'StrMPoleSymplectic4RadPass');
SD   =  sextupole('SD', 0.2, -80.68742/2, 'StrMPoleSymplectic4RadPass');


% DIPOLES (COMBINED FUNCTION)
BEND  =  rbend('BEND'  , 0.86514,  ...
            0.1745329, 0.0872665, 0.0872665, -1.358320,'BndMPoleSymplectic4RadPass');

         
% Begin Lattice

%%  Superperiods  

SUP  = [   L1A SF L2 QF L2 SD L2 BEND L2 SD L2 QF L2 SF L1B ...
        L1B SF L2 QF L2 SD L2 BEND L2 SD L2 QF L2 SF L1A];
           
ELIST = [INJ SUP CAV SUP SUP SUP SUP SUP SUP SUP SUP ...
        SUP SUP SUP SUP SUP SUP SUP SUP SUP];

% THERING=cell(size(ELIST));
% for i=1:length(THERING)
%    THERING{i} = FAMLIST{ELIST(i)}.ElemData;
%    FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
%    FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
% end

buildlat(ELIST);



%% compute total length and RF frequency

L0_tot=0;
for i=1:length(THERING)
   L0_tot=L0_tot+THERING{i}.Length;
end

fprintf('\nL0_tot=%.6f m (should be 211.145040 m) \nf_RF=%.6f MHz \n\n',L0_tot,HarmNumber*C0/L0_tot/1e6)

%% Compute initial tunes before loading errors
[InitialTunes, InitialChro]= tunechrom(THERING,0,[17.25, 11.2],'chrom','coupling');

fprintf('Tunes and chromaticities are calculated slightly incorrectly since radiation and cavity are on\n');
fprintf('Tunes before loading lattice errors: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
fprintf('Chroma before loading lattice errors: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));

evalin('caller','global THERING FAMLIST GLOBVAL');
evalin('base','global THERING FAMLIST GLOBVAL');
disp('** Done **');


