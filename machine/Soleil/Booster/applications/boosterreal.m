function boosterreal
% Booster soleil lattice w/o ID 
% Lattice definition file, include BPM and steerer at right location (Alex)
% Perfect lattice no magnetic errors 
% Controlroom : set linearpass for quad (closed orbit)

% Fevrier 2006
% A. Loulergue

global FAMLIST THERING GLOBVAL

%GLOBVAL.E0 = 2.75e9; % Ring energy
GLOBVAL.E0 = 0.1085e9; % Ring energy
% GLOBVAL.E0 = 0.100e9; % Ring energy

GLOBVAL.LatticeFile = mfilename;
FAMLIST = cell(0);

disp(['** Loading SOLEIL booster magnet lattice ', mfilename]);

L0 = 156.6202003;                % design length [m]
C0 = 2.99792458e8;           % speed of light [m/s]
HarmNumber = 184;

%% Cavity
%              NAME   L     U[V]       f[Hz]          h        method       
CAV = rfcavity('RF' , 0 , 0.844e+6 , HarmNumber*C0/L0, ...
               HarmNumber ,'CavityPass');   
CAV = rfcavity('RF' , 0 , 0.200e+6 , HarmNumber*C0/L0, ...
              HarmNumber ,'CavityPass');   
% CAV = rfcavity('RF' , 0 , 0.204e+6 , HarmNumber*C0/L0, ...
%                HarmNumber ,'ThinCavityPass');   

%% Marker and apertures
   SECT1  =  marker('SECT1', 'IdentityPass');
   SECT2  =  marker('SECT2', 'IdentityPass');
   DEBUT  =  marker('DEBUT', 'IdentityPass');
   FIN    =  marker('FIN', 'IdentityPass');
   
   INJ = aperture('INJ',[-0.035 0.035 -0.125 0.125],'AperturePass');

% BPM   
   BPM    =  marker('BPM', 'IdentityPass');

% DRIFT SPACES
   SD1 = drift('SD1', 3.15955 , 'DriftPass');
   SD2 = drift('SD2',.408000  , 'DriftPass');
   SD3 = drift('SD3',.591550  , 'DriftPass');
   
   SDBP= drift('SDPB',.150000  , 'DriftPass');% Distance qpole BPM
   SDCO= drift('SDCO',.220000  , 'DriftPass');% Distance BPM corr
   SD31= drift('SD31',.221550  , 'DriftPass'); % tient compte BPM et CORR
   SD11= drift('SD11', 2.41955  , 'DriftPass');% tient compte 1 CORR

  
% QUADRUPOLES 
   QPD  =  quadrupole('QPD' , 0.40,-0.9382000E+00  , 'QuadLinearPass');
   QPF  =  quadrupole('QPF' , 0.40, 0.1178000E+01 , 'QuadLinearPass');

% SEXTUPOLES for xix=0.4 and xi_y=1.4
F = 1e8;
Finv = 1/F;
% SXF = 0.383 SXD = -0.525 for correcting natural chromaticities (Alex)
% do not take in account 1. Eddy current when ramping the energy
%                        2. remnant sextupole field at injection field
%                        3. sextupole from geometry of dipole

SXF  =  sextupole('SXF' , Finv,  0.383*F, 'StrMPoleSymplectic4Pass');
SXD  =  sextupole('SXD' , Finv, -0.525*F, 'StrMPoleSymplectic4Pass');

% Slow feedback correctors
 HCOR =  corrector('HCOR',0.0,[0 0],'CorrectorPass');
 VCOR =  corrector('VCOR',0.0,[0 0],'CorrectorPass');
 DEF  =  corrector('DEF',0.0,[0.00 0],'CorrectorPass');

% DIPOLES 
BEND  =  rbend('BEND'  , 2.160,  ...
            0.174533, 0.0872665, 0.0872665 , 0.0,'BendLinearPass');

% Begin Lattice
%  Superperiods  

SUP1  = [ ...
 QPD       DEF       SDBP       SDCO       VCOR       SD11       SDCO       SDBP                      ...
 QPF        SDBP       BPM        SDCO       HCOR       SD31       BEND       SD2            ...    
 ...
 QPD        SDBP       SDCO       VCOR       SD11       SDCO       HCOR       SDBP           ...
 QPF        SD2        BEND       SD31       VCOR       SDCO       BPM        SDBP           ...
 ...
 QPD        SXD        SD2        BEND       SD31       HCOR       SDCO       BPM       SDBP ...
 QPF        SXF        SD2        BEND       SD31       VCOR       SDCO       SDBP           ...
 ...
 QPD        SXD        SD2        BEND       SD31       HCOR       SDCO       SDBP           ...     
 QPF        SXF        SD2        BEND       SD31       VCOR       SDCO       BPM       SDBP ...
 ...
 QPD        SXD        SD2        BEND       SD31       HCOR       SDCO       BPM       SDBP ...       
 QPF        SXF        SD2        BEND       SD31       VCOR       SDCO       SDBP           ...
 ...
 QPD        SXD        SD2        BEND       SD31       HCOR       SDCO       BPM       SDBP ... 
 QPF        SD3        BEND       SD2        SXD                                             ...
 ...
 QPD        SDBP       SDCO       VCOR       SD31       BEND       SD2        SXF            ...
 QPF        SDBP       BPM        SDCO       HCOR       SD31       BEND       SD2       SXD  ...
 ...
 QPD        SDBP       BPM        SDCO       VCOR       SD31       BEND       SD2       SXF            ...               
 QPF        SDBP       SDCO       HCOR       SD31       BEND       SD2        SXD            ...
 ...    
 QPD        SDBP       SDCO       VCOR       SD31       BEND       SD2        SXF            ... 
 QPF        SDBP       BPM        SDCO       HCOR       SD31       BEND       SD2       SXD  ...
 ...
 QPD        SDBP       BPM        SDCO       VCOR       SD31       BEND       SD2            ...     
 QPF        SDBP       SDCO       HCOR       SD11       SDCO       VCOR       SDBP           ...
 ...
 QPD        SD2        BEND       SD31       HCOR       SDCO       BPM        SDBP           ...
 QPF        SD1 ];

ELIST = [DEBUT INJ SECT1 SUP1 SECT2 SUP1 CAV FIN];

buildlat(ELIST);

% Set all magnets to same energy
THERING = setcellstruct(THERING,'Energy',1:length(THERING),GLOBVAL.E0);

evalin('caller','global THERING FAMLIST GLOBVAL');
atsummary;
