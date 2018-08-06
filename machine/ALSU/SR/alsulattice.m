% AT lattice file automatically generated from Tracy file with solution:sol  
% Mon Oct 16 11:17:03 2017

Energy = 2.00e+09;
global FAMLIST THERING GLOBVAL
GLOBVAL.E0 = Energy;
GLOBVAL.LatticeFile = 'ATLatticeFile';
FAMLIST = cell(0);

L0 = 196.50000000;
C0 = 299792458;
HarmNumber = 328;


% Cavity 
% Name        L       U[V]       f(Hz)        h    method
   CAV = rfcavity('CAV', 0, 6.500000e+05, HarmNumber*C0/L0, HarmNumber, 'CavityPass');

%% MARKERs
   SECT1 = marker('SECT1',  'IdentityPass');
   SECT2 = marker('SECT2',  'IdentityPass');
   SECT3 = marker('SECT3',  'IdentityPass');
   SECT4 = marker('SECT4',  'IdentityPass');
   SECT5 = marker('SECT5',  'IdentityPass');
   SECT6 = marker('SECT6',  'IdentityPass');
   SECT7 = marker('SECT7',  'IdentityPass');
   SECT8 = marker('SECT8',  'IdentityPass');
   SECT9 = marker('SECT9',  'IdentityPass');
   SECT10 = marker('SECT10',  'IdentityPass');
   SECT11 = marker('SECT11',  'IdentityPass');
   SECT12 = marker('SECT12',  'IdentityPass');

%% DRIFT SPACES
   D11 = drift('D11',   0.51450000,  'DriftPass');
   D12 = drift('D12',   0.07500000,  'DriftPass');
   D13A = drift('D13A',   0.07500000,  'DriftPass');
   D13B = drift('D13B',   0.07500000,  'DriftPass');
   D13C = drift('D13C',   0.07500000,  'DriftPass');
   D14A = drift('D14A',   0.07500000,  'DriftPass');
   D14B = drift('D14B',   0.07500000,  'DriftPass');
   D15 = drift('D15',   0.22500000,  'DriftPass');
   D33 = drift('D33',   0.07500000,  'DriftPass');
   DQF2 = drift('DQF2',   0.07500000,  'DriftPass');

%% QUADRUPOLES
   QF1 = quadrupole('QF1',   0.18000000,  13.76775000,  'StrMPoleSymplectic4RadPass');
   QD1 = quadrupole('QD1',   0.14000000,  -13.43180000,  'StrMPoleSymplectic4RadPass');

%% DIPOLES
   BEND1 = sbend('BEND1',   0.06800000,  0.01163553, 0.00000000,  0.00000000,   -2.99999900,  'BndMPoleSymplectic4RadPass');
   QF2 = sbend('QF2',   0.19000000,  -0.00159621, 0.00000000,  0.00000000,   10.22397000,  'BndMPoleSymplectic4RadPass');
   QF3 = sbend('QF3',   0.11500000,  -0.00010845, 0.00000000,  0.00000000,   10.54612000,  'BndMPoleSymplectic4RadPass');
   QF4 = sbend('QF4',   0.30500000,  -0.00749382, 0.00000000,  0.00000000,   15.28256000,  'BndMPoleSymplectic4RadPass');
   QF5 = sbend('QF5',   0.30500000,  -0.00749382, 0.00000000,  0.00000000,   15.79571000,  'BndMPoleSymplectic4RadPass');
   QF6 = sbend('QF6',   0.30500000,  -0.00749382, 0.00000000,  0.00000000,   15.76120000,  'BndMPoleSymplectic4RadPass');
   BEND2 = sbend('BEND2',   0.10000000,  0.01272584, 0.00000000,  0.00000000,   -7.05740300,  'BndMPoleSymplectic4RadPass');
   BEND3 = sbend('BEND3',   0.10000000,  0.01313429, 0.00000000,  0.00000000,   -7.05740300,  'BndMPoleSymplectic4RadPass');
   B3M = marker('B3M',  'IdentityPass');

%% SEXTUPOLES
   SF = sextupole('SF',   0.28000000,  781.45580473,  'StrMPoleSymplectic4RadPass');
   SD = sextupole('SD',   0.28000000,  -640.18897216,  'StrMPoleSymplectic4RadPass');
   SHH = sextupole('SHH',   0.07500000,  38.85843000,  'StrMPoleSymplectic4RadPass');
   SHH2 = sextupole('SHH2',   0.07500000,  -578.19240000,  'StrMPoleSymplectic4RadPass');

%% Begin Lattice
% Superperiod

   SUP = [ D11 D11 D11 D11 D11 SHH D12 QF1 D13A QD1 ...
            D13B SHH2 D13C BEND1 BEND1 BEND1 BEND1 BEND1 D14A SD ...
            D14B QF2 DQF2 SF DQF2 QF3 D15 BEND2 BEND2 BEND2 ...
            BEND2 BEND2 D33 QF4 D33 BEND3 BEND3 BEND3 BEND3 BEND3 ...
            D33 QF5 D33 BEND3 BEND3 BEND3 BEND3 BEND3 D33 QF6 ...
            D33 BEND3 BEND3 BEND3 BEND3 BEND3 B3M D33 QF6 D33 ...
            BEND3 BEND3 BEND3 BEND3 BEND3 D33 QF5 D33 BEND3 BEND3 ...
            BEND3 BEND3 BEND3 D33 QF4 D33 BEND2 BEND2 BEND2 BEND2 ...
            BEND2 D15 QF3 DQF2 SF DQF2 QF2 D14B SD D14A ...
            BEND1 BEND1 BEND1 BEND1 BEND1 D13C SHH2 D13B QD1 D13A ...
            QF1 D12 SHH D11 D11 D11 D11 D11 ];

ELIST = [SECT1 SUP SECT2 SUP SECT3 CAV SUP SECT4  SUP SECT5 SUP SECT6 SUP ...
         SECT7 SUP SECT8 SUP SECT9 SUP SECT10 SUP SECT11 SUP SECT12 SUP];

THERING=cell(size(ELIST));
for i=1:length(THERING)
   THERING{i} = FAMLIST{ELIST(i)}.ElemData;
   FAMLIST{ELIST(i)}.NumKids=FAMLIST{ELIST(i)}.NumKids+1;
   FAMLIST{ELIST(i)}.KidsList = [FAMLIST{ELIST(i)}.KidsList i];
end

% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);


% % compute total length and RF frequency
% L0_tot=0;
% for loop=1:length(THERING)
%    L0_tot=L0_tot+THERING{loop}.Length;
%    THERING{loop}.Energy=GLOBVAL.E0;
% end
% 
% fprintf('\nL0_tot=%.6f m  \nf_RF=%.6f MHz \n\n',L0_tot,HarmNumber*C0/L0_tot/1e6);


%% Turn off the cavity and radiation elements
%cavityoff;
%radiationoff;

setcavity off;
setradiation off;


%% Compute total length and RF frequency
L0_tot = findspos(THERING, length(THERING)+1);
% L0_tot=0;
% for i=1:length(THERING)
%     L0_tot=L0_tot+THERING{i}.Length;
% end
fprintf('   L0 = %.6f m   (ALS was 196.805415 m)\n', L0_tot)
fprintf('   RF = %.6f MHz (ALS was 499.640349 Hz)\n', HarmNumber*C0/L0_tot/1e6)


%% Compute initial tunes before loading errors
[InitialTunes, InitialChro]= tunechrom(THERING,0,[43.37,21.37],'chrom','coupling');
[twissdata,InitialTunes]= twissring(THERING,0,1:length(THERING));
fprintf('Tunes before loading lattice errors: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
fprintf('Chroma before loading lattice errors: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));


% Compute initial tunes before loading errors
% [InitialTunes, InitialChro]= tunechrom(THERING,0,[14.25, 8.2],'chrom','coupling');
% fprintf('Tunes and chromaticities might be slightly incorrect if synchrotron radiation and cavity are on\n');
% fprintf('Tunes: nu_x=%g, nu_y=%g\n',InitialTunes(1),InitialTunes(2));
% fprintf('Chromaticities: xi_x=%g, xi_y=%g\n',InitialChro(1),InitialChro(2));


clear global FAMLIST
%clear global GLOBVAL when GWig... has been changed.

% LOSSFLAG is not global in AT1.3
evalin('base','clear LOSSFLAG');


%evalin('caller','global THERING GLOBVAL');
%evalin('base','global THERING GLOBVAL');