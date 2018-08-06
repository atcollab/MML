function [the_ring, lattice_title] = sirius_bo_lattice(varargin)
%maquina com simetria 50, formada por dipolos e quadrupolos com sextupolos
%integrados. 15/08/2012 - Fernando.
% modelode segmentado dos dipolos. 10/04/2014
% mudanca de padrao para baixa energia.
%
% 2015-09-03 novo modelo QD: Leff = 100.74 mm - Ximenes.
% 2015-09-08 novo modelo QF: Leff = 227.46 mm - Ximenes.
% 2015-09-14 novos modelos de corretoras com Leff = 150.18 mm - Ximenes.
% 2015-11-04 modelos com comprimentos multiplos de milímetros - Ximenes.
% 2015-11-04 E02.02 - segmented model of B corrected (last element had 5 mm, instead of 50 mm) see 'VERSIONS.txt' in Release/machine/SIRIUS

%%% HEADER SECTION %%%

global THERING

energy = 0.15e9; % eV

lattice_version = 'BO.E02.02';
for i=1:length(varargin)
	energy = varargin{i} * 1e9;
end
mode = 'M';
version = '0';

harmonic_number = 828;
rf_voltage = sirius_bo_rf_voltage(energy);
%if energy == 0.15e9, rf_voltage = 150e3; else rf_voltage = 950e3; end

lattice_title = [lattice_version '.' mode version];
fprintf(['   Loading lattice ' lattice_title ' - ' num2str(energy/1e9) ' GeV' '\n']);

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';

% loads magnet strengths
set_magnets_strength_booster;

% a segmented model for the dipole has been created from the
% approved fieldmap. The segmented model has a longer length 
% and the difference has to be accomodated.

% loads dipole segmented model:
b_len_hdedge   = 1.152; % [m]
[B, b_len_seg] = sirius_bo_b_segmented_model('b', bend_pass_method);
lenDif         = (b_len_seg - b_len_hdedge)/2.0;

L01340  = drift('l01340', 0.1340, 'DriftPass');
L01615  = drift('l01615', 0.1615, 'DriftPass');
L01725  = drift('l01725', 0.1725, 'DriftPass');
L02410  = drift('l02410', 0.2410, 'DriftPass');
L03365  = drift('l03365', 0.3365, 'DriftPass');
L03600  = drift('l03600', 0.3600, 'DriftPass');
L05550  = drift('l05550', 0.5550, 'DriftPass');
L07250  = drift('l07250', 0.7250, 'DriftPass');
L10000  = drift('l10000', 1.0000, 'DriftPass');
L10960  = drift('l10960', 1.0960, 'DriftPass');
L11325  = drift('l11325', 1.1325, 'DriftPass');
L12960  = drift('l12960', 1.2960, 'DriftPass');
L14110  = drift('l14110', 1.4110, 'DriftPass');
L14710  = drift('l14710', 1.4710, 'DriftPass');
L17710  = drift('l17710', 1.7710, 'DriftPass');
L17935  = drift('l17935', 1.7935, 'DriftPass');
L17955  = drift('l17955', 1.7955, 'DriftPass');
L18210  = drift('l18210', 1.8210, 'DriftPass');
L18935  = drift('l18935', 1.8935, 'DriftPass');
L21325  = drift('l21325', 2.1325, 'DriftPass');

% drifts affected by the dipole modelling:

D02250 = drift('d02250',  0.2250-lenDif, 'DriftPass');
D02475 = drift('d02475',  0.2475-lenDif, 'DriftPass');
D02495 = drift('d02495',  0.2495-lenDif, 'DriftPass');
D21460 = drift('d21460',  2.1460-lenDif, 'DriftPass');

STR  = marker('start',   'IdentityPass');     % start of the model
FIM  = marker('end',     'IdentityPass');     % end of the model
GIR  = marker('girder',  'IdentityPass');
SIN  = marker('sept_in', 'IdentityPass');
SEX  = marker('sept_ex', 'IdentityPass');
BPM  = marker('bpm',     'IdentityPass');

KIN  = quadrupole('injk', 0.500,     0.0,         quad_pass_method);
KEX  = quadrupole('ejek', 0.500,     0.0,         quad_pass_method);

CH   = sextupole ('ch',      0.150,     0.0,         sext_pass_method);
CV   = sextupole ('cv',      0.150,     0.0,         sext_pass_method);
SF  = sirius_bo_sx_segmented_model(energy, 'sf', sext_pass_method, sf_strength * 0.105);
SD  = sirius_bo_sx_segmented_model(energy, 'sd', sext_pass_method, sd_strength * 0.105);
QD  = sirius_bo_qd_segmented_model(energy, 'qd', quad_pass_method, qd_strength * 0.101);
QF  = sirius_bo_qf_segmented_model(energy, 'qf', quad_pass_method, qf_strength * 0.227);

QF0 = [QF(1), FIM, STR, QF(2:end)]; % inserts markers inside QF model

RFC = rfcavity('cav', 0, rf_voltage, 0, harmonic_number, 'CavityPass'); % RF frequency will be set later.

US_SF = [GIR, D21460, BPM, L18935, GIR, SF, L01340];  
US_SS = [D02475, SD, GIR, L17935, BPM, L18935, GIR, SF, L01340];
US_SI = [D02250, CV, GIR, L17710, BPM, L10960, SIN, L07250, GIR, CH, L01615];
US_CS = [D02475, SD, L01725, CV, GIR, L14710, BPM, L18210, GIR, CH, L01615];
US_CC = [D02250, CV, GIR, L17710, BPM, L18210, GIR, CH, L01615];
US_SE = [D02250, CV, GIR, L14110, SEX, L03600, L10000, BPM, L11325, GIR];

DS    = [GIR, L21325, D21460, GIR];
DS_QD = [GIR, L21325, L17955, GIR, QD, D02495];
DS_KE = [GIR, L03365, KEX, L02410, KEX, L05550, L17955, GIR, QD, D02495];
DS_RF = [GIR, L21325, RFC, D21460, GIR];
DS_KI = [GIR, L03365, KIN, L12960, D21460, GIR];
DS_CH = [L01615, CH, GIR, L18210, D21460, GIR];

%US_01 = US_SI;        DS_01 = DS_KI;        S01 = [US_01, QFI, FIM, STR, mqf, QFI, DS_01, B];      
US_01 = US_SI;        DS_01 = DS_KI;        S01 = [US_01, QF0,DS_01, B];      
US_02 = US_SF;        DS_02 = DS_QD;        S02 = [US_02, QF, DS_02, B];
US_03 = US_CS;        DS_03 = DS;           S03 = [US_03, QF, DS_03, B];   
US_04 = US_SF;        DS_04 = DS_QD;        S04 = [US_04, QF, DS_04, B];
US_05 = US_CC;        DS_05 = DS_RF;        S05 = [US_05, QF, DS_05, B];      
US_06 = US_SF;        DS_06 = DS_QD;        S06 = [US_06, QF, DS_06, B];
US_07 = US_CC;        DS_07 = DS;           S07 = [US_07, QF, DS_07, B];   
US_08 = US_SS;        DS_08 = DS_QD;        S08 = [US_08, QF, DS_08, B];
US_09 = US_CC;        DS_09 = DS;           S09 = [US_09, QF, DS_09, B];   
US_10 = US_SF;        DS_10 = DS_QD;        S10 = [US_10, QF, DS_10, B];
US_11 = US_CC;        DS_11 = DS;           S11 = [US_11, QF, DS_11, B];   
US_12 = US_SF;        DS_12 = DS_QD;        S12 = [US_12, QF, DS_12, B];
US_13 = US_CS;        DS_13 = DS;           S13 = [US_13, QF, DS_13, B];   
US_14 = US_SF;        DS_14 = DS_QD;        S14 = [US_14, QF, DS_14, B];
US_15 = US_CC;        DS_15 = DS;           S15 = [US_15, QF, DS_15, B];   
US_16 = US_SF;        DS_16 = DS_QD;        S16 = [US_16, QF, DS_16, B];
US_17 = US_CC;        DS_17 = DS;           S17 = [US_17, QF, DS_17, B];   
US_18 = US_SS;        DS_18 = DS_QD;        S18 = [US_18, QF, DS_18, B];
US_19 = US_CC;        DS_19 = DS;           S19 = [US_19, QF, DS_19, B];   
US_20 = US_SF;        DS_20 = DS_QD;        S20 = [US_20, QF, DS_20, B];
US_21 = US_CC;        DS_21 = DS;           S21 = [US_21, QF, DS_21, B];   
US_22 = US_SF;        DS_22 = DS_QD;        S22 = [US_22, QF, DS_22, B];
US_23 = US_CS;        DS_23 = DS;           S23 = [US_23, QF, DS_23, B];   
US_24 = US_SF;        DS_24 = DS_QD;        S24 = [US_24, QF, DS_24, B];
US_25 = US_CC;        DS_25 = DS;           S25 = [US_25, QF, DS_25, B];   
US_26 = US_SF;        DS_26 = DS_QD;        S26 = [US_26, QF, DS_26, B];
US_27 = US_CC;        DS_27 = DS;           S27 = [US_27, QF, DS_27, B];   
US_28 = US_SS;        DS_28 = DS_QD;        S28 = [US_28, QF, DS_28, B];
US_29 = US_CC;        DS_29 = DS;           S29 = [US_29, QF, DS_29, B];   
US_30 = US_SF;        DS_30 = DS_QD;        S30 = [US_30, QF, DS_30, B];
US_31 = US_CC;        DS_31 = DS;           S31 = [US_31, QF, DS_31, B];   
US_32 = US_SF;        DS_32 = DS_QD;        S32 = [US_32, QF, DS_32, B];
US_33 = US_CS;        DS_33 = DS;           S33 = [US_33, QF, DS_33, B];   
US_34 = US_SF;        DS_34 = DS_QD;        S34 = [US_34, QF, DS_34, B];
US_35 = US_CC;        DS_35 = DS;           S35 = [US_35, QF, DS_35, B];   
US_36 = US_SF;        DS_36 = DS_QD;        S36 = [US_36, QF, DS_36, B];
US_37 = US_CC;        DS_37 = DS;           S37 = [US_37, QF, DS_37, B];   
US_38 = US_SS;        DS_38 = DS_QD;        S38 = [US_38, QF, DS_38, B];
US_39 = US_CC;        DS_39 = DS;           S39 = [US_39, QF, DS_39, B];   
US_40 = US_SF;        DS_40 = DS_QD;        S40 = [US_40, QF, DS_40, B];
US_41 = US_CC;        DS_41 = DS;           S41 = [US_41, QF, DS_41, B];   
US_42 = US_SF;        DS_42 = DS_QD;        S42 = [US_42, QF, DS_42, B];
US_43 = US_CS;        DS_43 = DS;           S43 = [US_43, QF, DS_43, B];   
US_44 = US_SF;        DS_44 = DS_QD;        S44 = [US_44, QF, DS_44, B];
US_45 = US_CC;        DS_45 = DS;           S45 = [US_45, QF, DS_45, B];   
US_46 = US_SF;        DS_46 = DS_QD;        S46 = [US_46, QF, DS_46, B];
US_47 = US_CC;        DS_47 = DS;           S47 = [US_47, QF, DS_47, B];   
US_48 = US_SS;        DS_48 = DS_KE;        S48 = [US_48, QF, DS_48, B];
US_49 = US_SE;        DS_49 = DS_CH;        S49 = [US_49, QF, DS_49, B];      
US_50 = US_SF;        DS_50 = DS_QD;        S50 = [US_50, QF, DS_50, B];


elist = [S01,S02,S03,S04,S05,S06,S07,S08,S09,S10,...
         S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,...
         S21,S22,S23,S24,S25,S26,S27,S28,S29,S30,...
         S31,S32,S33,S34,S35,S36,S37,S38,S39,S40,...
         S41,S42,S43,S44,S45,S46,S47,S48,S49,S50];

%% finalization 

THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'start'
idx = findcells(THERING, 'FamName', 'start');
if numel(idx) == 1
    THERING = circshift(THERING, [0,-(idx-1)]);
end

% checks if there are negative-drift elements
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% adjusts RF frequency according to lattice length and synchronous condition
const  = lnls_constants;
%[beta, ~, ~] = lnls_beta_gamma(energy/1e9);
L0_tot = findspos(THERING, length(THERING)+1);
fprintf('   Circumference: %.5f m\n', L0_tot);

%rev_freq     = beta * const.c / L0_tot;
rev_freq     = const.c / L0_tot;
rf_idx       = findcells(THERING, 'FamName', 'cav');
rf_frequency = rev_freq * harmonic_number;
THERING{rf_idx}.Frequency = rf_frequency;
fprintf(['   RF frequency set to ' num2str(rf_frequency/1e6) ' MHz.\n']);

% by default cavities and radiation is set to off 
setcavity('off'); 
setradiation('off');

% sets default NumIntSteps values for elements
THERING = set_num_integ_steps(THERING);

% define vacuum chamber for all elements
THERING = set_vacuum_chamber(THERING);

% defines girders
THERING = set_girders(THERING);

% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
lnls_preload_passmethods;

the_ring = THERING;


function the_ring = set_vacuum_chamber(the_ring)

% y = +/- y_lim * sqrt(1 - (x/x_lim)^n);

bends_vchamber =      [0.0117 0.0117 1];   % n = 100: ~rectangular
other_vchamber =      [0.018  0.018  1];   % n = 1;   circular/eliptica
extraction_vchamber = [0.026  0.018  1];   % n = 1;   circular/eliptica
injection_vchamber  = [0.050  0.018  1];

% default
for i=1:length(the_ring)
    the_ring{i}.VChamber = other_vchamber;
end

% bends
b = [findcells(the_ring, 'FamName', 'b') findcells(the_ring, 'FamName', 'mb')];
for i=b
    the_ring{i}.VChamber = bends_vchamber;
end

% extraction bend
ejek = findcells(the_ring, 'FamName', 'ejek');
sept_ex = findcells(the_ring, 'FamName', 'sept_ex');
b_ex = b((b > ejek(end)) & (b < sept_ex(1)));
for i=b_ex
    the_ring{i}.VChamber = other_vchamber;
end

% sector from extraction bend to extraction septum
for i=b_ex(end):sept_ex(1)
    the_ring{i}.VChamber = extraction_vchamber;
end

% sector from injection point to injection kicker
sept_in = findcells(the_ring, 'FamName', 'sept_in');
injk = findcells(the_ring, 'FamName', 'injk');
for i=sept_in(end):length(the_ring)
    the_ring{i}.VChamber = injection_vchamber;
end
for j=1:injk(1)
    the_ring{j}.VChamber = injection_vchamber;
end


function the_ring = set_girders(the_ring)
idx = findcells(the_ring,'FamName','bpm'); idx = idx(end);
the_ring = circshift(the_ring,[0,-idx]);

gir = findcells(the_ring,'FamName','girder');

gir_ini = gir(1:2:end);
gir_end = gir(2:2:end);
if isempty(gir), return; end

for ii=1:length(gir_ini)
    indcs = gir_ini(ii):gir_end(ii);
    name_girder = sprintf('%03d',ii);
    the_ring = setcellstruct(the_ring,'Girder',indcs,name_girder);
end
the_ring = circshift(the_ring,[0,idx]);
gir = findcells(the_ring,'FamName','girder');
the_ring(gir) = [];

function the_ring = set_num_integ_steps(the_ring)

mags = findcells(the_ring, 'PolynomB');
bends = findcells(the_ring,'BendingAngle');
quad_sext = setdiff(mags,bends);
kicks = findcells(the_ring, 'XGrid');

len_b  = 3e-2;
len_qs = 1.5e-2;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / len_b);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);

quad_sext_len = getcellstruct(the_ring, 'Length', quad_sext);
quad_sext_nis = ceil(quad_sext_len / len_qs);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quad_sext, quad_sext_nis);

the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);



