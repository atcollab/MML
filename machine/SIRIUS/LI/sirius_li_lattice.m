function [r, lattice_title, IniCond] = sirius_li_lattice(optics_mode,operation_mode)
% 2017-02-14 created  Fernando.

%% global parameters
%  =================

% --- system parameters ---
energy = 0.15e9;
lattice_version = 'LI.V01.01';

if ~exist('optics_mode','var'), optics_mode = 'M1'; end
if ~exist('operation_mode','var'), operation_mode = 'injection'; end

lattice_title = [lattice_version '.' optics_mode];
fprintf(['   Loading lattice ' lattice_title ' - ' num2str(energy/1e9) ' GeV' '\n']);

% -- selection of operation_mode --
if strcmp(operation_mode, 'emittance_measurement')
    mode0 = true;
    mode1 = false;
    mode2 = false;
elseif strcmp(operation_mode, 'injection')
    mode0 = false;
    mode1 = true;
    mode2 = false;
elseif strcmp(operation_mode, 'energy_dispersion')
    mode0 = false;
    mode1 = false;
    mode2 = true;
else
    error(['Invalid LI operation mode: ' operation_mode]);
end

% carrega forcas dos imas de acordo com modo de operacao
IniCond = struct('ElemIndex',1,'Spos',0,'ClosedOrbit',[0;0;0;0],'mu',[0,0]);
set_parameters_li;


%% passmethods
%  ===========

bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';

%% elements
%  ========
% --- drifts ---
l100 = drift('l100', 0.1000, 'DriftPass');
l200 = drift('l200', 0.2000, 'DriftPass');
l300 = drift('l300', 0.3000, 'DriftPass');
l500 = drift('l500', 0.5000, 'DriftPass');
l600 = drift('l600', 0.6000, 'DriftPass');
la1  = drift('la1',  0.1150, 'DriftPass');
la2p = drift('la2p', 0.2100, 'DriftPass');
la3p = drift('la3p', 0.1488, 'DriftPass');
la4p = drift('la4p', 0.0512, 'DriftPass');

% --- markers ---
inicio       = marker('start', 'IdentityPass');
fim          = marker('end', 'IdentityPass');
match_start  = marker('match_start', 'IdentityPass');

egun  = marker('EGun', 'IdentityPass');

% --- beam screens ---
scrn   = marker('Scrn', 'IdentityPass');

% --- beam current monitors ---
ict    = marker('ICT', 'IdentityPass');

% --- beam position monitors ---
bpm    = marker('BPM', 'IdentityPass');

% --- linac correctors ---
ch  = corrector('CH',  0, [0 0], 'CorrectorPass');
cv  = corrector('CV',  0, [0 0], 'CorrectorPass');

% --- lens ---
lens = marker('Lens', 'IdentityPass');

% --- dump ---
dump = marker('Dump', 'IdentityPass');

% --- solenoids ---
solnd01 = marker('Slnd01', 'IdentityPass');
solnd02 = marker('Slnd02', 'IdentityPass');
solnd03 = marker('Slnd03', 'IdentityPass');
solnd04 = marker('Slnd04', 'IdentityPass');
solnd05 = marker('Slnd05', 'IdentityPass');
solnd06 = marker('Slnd06', 'IdentityPass');
solnd07 = marker('Slnd07', 'IdentityPass');
solnd08 = marker('Slnd08', 'IdentityPass');
solnd09 = marker('Slnd09', 'IdentityPass');
solnd10 = marker('Slnd10', 'IdentityPass');
solnd11 = marker('Slnd11', 'IdentityPass');
solnd12 = marker('Slnd12', 'IdentityPass');
solnd13 = marker('Slnd13', 'IdentityPass');
solnd14 = marker('Slnd14', 'IdentityPass');
solnd15 = marker('Slnd15', 'IdentityPass');
solnd16 = marker('Slnd16', 'IdentityPass');
solnd17 = marker('Slnd17', 'IdentityPass');
solnd18 = marker('Slnd18', 'IdentityPass');
solnd19 = marker('Slnd19', 'IdentityPass');
solnd20 = marker('Slnd20', 'IdentityPass');
solnd21 = marker('Slnd21', 'IdentityPass');

% --- SHB ---
shb     = marker('SHB', 'IdentityPass');
bun     = marker('Bun', 'IdentityPass');
acc_str = marker('AccStr', 'IdentityPass');



qf2  = quadrupole('QF2',  0.05, qf2_strength, quad_pass_method);   %
qd2  = quadrupole('QD2',  0.10, qd2_strength, quad_pass_method);   % LINAC TRIPLET
qf3  = quadrupole('QF3',  0.05, qf3_strength, quad_pass_method);   %
qd1  = quadrupole('QD1',  0.10, qd1_strength, quad_pass_method);
qf1  = quadrupole('QF1',  0.05, qf1_strength, quad_pass_method);


% --- bending magnets ---
deg_2_rad = (pi/180);


if mode0, ang=0.0; elseif mode1, ang=15; else ang = 45; end
% -- spec --
dip_nam =  'Spect';
dip_len =  0.45003;
dip_ang =  -ang * deg_2_rad;
dip_K   =  0.0;
dip_S   =  0.00;
spech      = rbend_sirius(dip_nam, dip_len/2, dip_ang/2, 0, 0, 0,0,0, [0,0,0], [0,dip_K,dip_S], bend_pass_method);
spec   = [spech, spech];


%% --- lines ---

L1_1   = [inicio, egun, l100, lens, l100, ict, l100, cv, ch, l100, lens];
L1_2   = [l200, shb, l200, lens, l100, scrn, bpm, l100, lens, l100, cv, ch];
L1_Bun = [l300, solnd01, l100, solnd02, l100, solnd03, l100, cv, ch, solnd04, l100, solnd05,...
          l100, solnd06, l100, solnd07, l100, bun, solnd08, l100, solnd09, l100, solnd10,...
          l100, solnd11, l100, solnd12, l100, solnd13, l200];
L1_4   = [l200, solnd14, l100, solnd14, l100, scrn, bpm, l200];
L1_Ac1 = [l300, solnd15, l100, solnd15, l100, solnd16, l100, solnd16, cv, ch,...
          l100, solnd17, l100, solnd17, l100, solnd18, l100, solnd18, acc_str,...
          l100, solnd19, l100, solnd19, l100, solnd20, l100, solnd20,...
          l100, solnd21, l100, solnd21, l200, l600, l600];
L1_6   = [l300];
L1_Ac2 = [l500, l500, cv, ch,l500, acc_str, l500, l500, l500];
L1_8   = [l100, qf1, l100, qd1, l100, qf1, l200, scrn, l200];
L1_Ac3 = [l500, l500, cv, ch, l500, acc_str, l500, l500, l500];
L1_10  = [l300];
L1_Ac4 = [l500, l500, cv, ch,l500, acc_str, l500, l500, l500];
L1_12  = [match_start, la1, qf2, l100, qd2, l100, qf2, l100, qf3];
L1_13  = [la2p, bpm, la3p, ict, la4p, l200, spec];

L1     = [L1_1, L1_2, L1_Bun, L1_4, L1_Ac1, L1_6, L1_Ac2,...
          L1_8, L1_Ac3, L1_10, L1_Ac4, L1_12, L1_13];
L2     = [l500, l500, scrn, l500, dump];
L3     = [l500, l500, scrn, l200, dump];


if mode0
    elist = [L1,L2,fim];
elseif mode1
    elist = [L1,fim];
else
    elist = [L1,L3,fim];
end


%% finalization
the_line = buildlat(elist);
the_line = setcellstruct(the_line, 'Energy', 1:length(the_line), energy);

% shift lattice to start at the marker 'start'
idx = findcells(the_line, 'FamName', 'start');
the_line = [the_line(idx:end) the_line(1:idx-1)];

% checa se ha elementos com comprimentos negativos
lens = getcellstruct(the_line, 'Length', 1:length(the_line));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% Ajusta NumIntSteps
the_line = set_num_integ_steps(the_line);

% Define Camara de Vacuo
the_line = set_vacuum_chamber(the_line);


% pre-carrega passmethods de forma a evitar problema com bibliotecas recem-compiladas
% lnls_preload_passmethods;
r = the_line;


function the_ring = set_vacuum_chamber(the_ring)

% y = +/- y_lim * (1 - (x/x_lim)^n)^(1/n);
% -- default physical apertures --
for i=1:length(the_ring)
    the_ring{i}.VChamber = [0.018, 0.018, 2];
end


function the_ring = set_num_integ_steps(the_ring0)

the_ring = the_ring0;

mags = findcells(the_ring, 'PolynomB');
bends = findcells(the_ring, 'BendingAngle');
quads = setdiff(mags,bends);
ch = findcells(the_ring, 'FamName', 'CH');
cv = findcells(the_ring, 'FamName', 'CV');
kicks = findcells(the_ring, 'XGrid');

dl = 0.035;

bends_len = getcellstruct(the_ring, 'Length', bends);
bends_nis = ceil(bends_len / dl);
bends_nis = max([bends_nis'; 10 * ones(size(bends_nis'))]);
the_ring = setcellstruct(the_ring, 'NumIntSteps', bends, bends_nis);
the_ring = setcellstruct(the_ring, 'NumIntSteps', quads, 10);
the_ring = setcellstruct(the_ring, 'NumIntSteps', ch, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', cv, 5);
the_ring = setcellstruct(the_ring, 'NumIntSteps', kicks, 1);
