
function boosterlin
% Booster soleil lattice w/o ID 
% Lattice definition file
% Perfect lattice no magnetic errors 
% Compiled by Laurent Nadolski and Amor Nadji
% 09/01/02, ALS
% Controlroom : set linearpass for quad (closed orbit)

global FAMLIST THERING GLOBVAL

GLOBVAL.E0 = 2.75e9; % Ring energy
GLOBVAL.LatticeFile = mfilename;
FAMLIST = cell(0);

disp(['** Loading SOLEIL booster magnet lattice ', mfilename]);

L0 = 156.620;                % design length [m]
C0 = 2.99792458e8;           % speed of light [m/s]
HarmNumber = 184;

%% Cavity
%              NAME   L     U[V]       f[Hz]          h        method       
CAV = rfcavity('RF' , 0 , 0.8e+6 , HarmNumber*C0/L0, ...
               HarmNumber ,'ThinCavityPass');   

%% Marker and apertures
   SECT1  =  marker('SECT1', 'IdentityPass');
   SECT2  =  marker('SECT2', 'IdentityPass');
   DEBUT  =  marker('DEBUT', 'IdentityPass');
   FIN    =  marker('FIN', 'IdentityPass');
   
   INJ = aperture('INJ',[-0.035 0.035 -0.0125 0.0125],'AperturePass');
   INJ = aperture('INJ',[-0.035 0.035 -0.125 0.125],'AperturePass');

% BPM   
   BPM    =  marker('BPM', 'IdentityPass');

% DRIFT SPACES
   SD1 = drift('SD1', 3.15955 , 'DriftPass');
   SD2 = drift('SD2',.408000  , 'DriftPass');
   SD3 = drift('SD3',.591550  , 'DriftPass');
   
% QUADRUPOLES 
   QPD  =  quadrupole('QPD' , 0.40, -.8913750 , 'QuadLinearPass');
   QPF  =  quadrupole('QPF' , 0.40,  1.12364 , 'QuadLinearPass');

% SEXTUPOLES for xix=0.4 and xi_y=1.4
F = 1e8;
Finv = 1/F;
S1  =  sextupole('S1' , Finv,  1.71919*F, 'StrMPoleSymplectic4Pass');
S2  =  sextupole('S2' , Finv, -4.10456*F, 'StrMPoleSymplectic4Pass');


% Slow feedback correctors
% HCOR =  corrector('HCOR',0.0,[0 0],'CorrectorPass');
% VCOR =  corrector('VCOR',0.0,[0 0],'CorrectorPass');
% COR = [HCOR VCOR];
COR =  corrector('COR',0.0,[0 0],'CorrectorPass');


% DIPOLES 
BEND  =  rbend('BEND'  , 2.160,  ...
            0.174533, 0.0872665, 0.0872665 , 0.0,'BendLinearPass');

% Begin Lattice

%%  Superperiods  

SUP1  = [ QPD        SD1        QPF        SD3        BEND       SD2  ...     
 QPD        SD1        QPF        SD2        BEND       SD3  ...     
 QPD        SD2        BEND       SD3        QPF        SD2 ...      
 BEND       SD3        QPD        SD2        BEND       SD3  ...     
 QPF        SD2        BEND       SD3        QPD        SD2  ...     
 BEND       SD3        QPF        SD2        BEND       SD3  ...     
 QPD        SD2        BEND       SD3        QPF        SD3  ...     
 BEND       SD2        QPD        SD3        BEND       SD2  ...     
 QPF        SD3        BEND       SD2        QPD        SD3  ...     
 BEND       SD2        QPF        SD3        BEND       SD2  ...     
 QPD        SD3        BEND       SD2        QPF        SD3 ...      
 BEND       SD2        QPD        SD3        BEND       SD2  ...     
 QPF        SD1        QPD        SD2        BEND       SD3  ...     
 QPF        SD1         ];

SUP2  = [ QPD        SD1        QPF        SD3        BEND       SD2  ...     
 QPD        SD1        QPF        SD2        BEND       SD3  ...     
 QPD        SD2        BEND       SD3        QPF        SD2 ...      
 BEND       SD3        QPD        SD2        BEND       SD3  ...     
 QPF        SD2        BEND       SD3        QPD        SD2  ...     
 BEND       SD3        QPF        SD2        BEND       SD3  ...     
 QPD        SD2        BEND       SD3        QPF        SD3  ...     
 BEND       SD2        QPD        SD3        BEND       SD2  ...     
 QPF        SD3        BEND       SD2        QPD        SD3  ...     
 BEND       SD2        QPF        SD3        BEND       SD2  ...     
 QPD        SD3        BEND       SD2        QPF        SD3 ...      
 BEND       SD2        QPD        SD3        BEND       SD2  ...     
 QPF        SD1        QPD        SD2        BEND       SD3  ...     
 QPF        SD1         ];

ELIST = [DEBUT INJ SECT1 SUP1 SECT2 SUP2 FIN];

buildlat(ELIST);






%% compute total length and RF frequency

L0_tot=0;
for i=1:length(THERING)
   L0_tot=L0_tot+THERING{i}.Length;
end

fprintf('\nL0_tot=%f m (should be %f m) \nf_RF=%f Hz \n\n', L0_tot, ...
    L0,HarmNumber*C0/L0_tot)

%% Compute initial tunes before loading errors
[InitialTunes, InitialChro] = tunechrom(THERING,0,[6.4, 4.4],'chrom','coupling');

% fprintf('A bit false since radiation and cavity on\n');
fprintf('Tunes before loading lattice errors: nu_x=%g, nu_z=%g\n', ...
    InitialTunes(1),InitialTunes(2));
fprintf('Chroma before loading lattice errors: xi_x=%g, xi_z=%g\n', ...
    InitialChro(1)/InitialTunes(1),InitialChro(2)/InitialTunes(2));

evalin('caller','global THERING FAMLIST GLOBVAL');
disp('** Finished loading lattice in Accelerator Toolbox');
