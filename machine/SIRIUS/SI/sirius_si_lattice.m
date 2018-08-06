function [r, lattice_title] = sirius_si_lattice(varargin)
% the_ring = sirius_si_lattice       : retorna o modelo atual do anel;
%
% the_ring = sirius_si_lattice(mode) : Ateh o momento, pode ser 'A', 'B' or 'C'(default).
%
% the_ring = sirius_si_lattice(mode,version): mode_version define o ponto de operacao
%              e a otimizacao sextupolar a ser usada. Exemplos: '01', '02'...
% the_ring = sirius_si_lattice(mode,version, energy): energia em eV;
%
% [the_ring, title] = sirius_si_lattice(...): Also return the name of the
%                       lattice.
%
% Todos os inputs comutam e podem ser passados independentemente.
%
% 2012-08-28: nova rede. (xrr)
% 2013-08-08: inseri marcadores de IDs de 2 m nos trechos retos. (xrr)
% 2013-08-12: corretoras rapidas e atualizacao das lentas e dos BPMs (desenho CAD da Liu). (xrr)
% 2013-10-02: adicionei o mode_version como parametro de input. (Fernando)
% 2014-09-17: modificacao das corretoras para apenas uma par integrado de CV e CH rapidas e lentas no mesmo elemento. (Natalia)
% 2014-10-07: atualizados nomes de alguns elementos. (xrr)
% 2015-11-03: agora modelo do BC ?? segmentado
% 2017-02-08: updated dipole B1 and B2 versions, updated FamNames, updated sys multi of fast correctors (xrr)

global THERING;


%% global parameters
%  =================

% --- system parameters ---
energy = 3e9;
mode   = 'S05';
version = '01';
strengths = @set_magnet_strengths;
harmonic_number = 864;

lattice_version = 'SI.V22.02';
% processamento de input (energia e modo de operacao)
for i=1:length(varargin)
    if ischar(varargin{i})
        if any(strcmpi(varargin{i},{'01','02','03'}))
            version = varargin{i};
        elseif any(strcmpi(varargin{i},{'S05','S10'}))
            mode = varargin{i};
        else
            fprintf(['%s was not identified as a valid version or mode.\n',...
                     'Continuing with default setup.'],varargin{i});
        end
    elseif isa(varargin{i},'function_handle')
        strengths = varargin{i};
    else
        energy = varargin{i} * 1e9;
    end;
end

lattice_title = [lattice_version, '_', mode, '.', version];
fprintf(['   Loading lattice ' lattice_title ' - ' num2str(energy/1e9) ' GeV' '\n']);

% carrega forcas dos imas de acordo com modo de operacao
strengths();

%% passmethods
%  ===========
bend_pass_method = 'BndMPoleSymplectic4Pass';
quad_pass_method = 'StrMPoleSymplectic4Pass';
sext_pass_method = 'StrMPoleSymplectic4Pass';


%% elements
%  ========
% marker to define points where momentum acceptance will be calculated
m_accep_fam_name = 'calc_mom_accep';
%MOMACCEP = marker(m_accep_fam_name, 'IdentityPass');  %

% -- drifts --

LKK   = drift('lkk',  1.9150, 'DriftPass');
LPMU  = drift('lpmu', 0.0600, 'DriftPass');
LPMD  = drift('lpmd', 0.4929, 'DriftPass');
LIA   = drift('lia',  1.5179, 'DriftPass');
LIB   = drift('lib',  1.0879, 'DriftPass');
LIP   = drift('lip',  1.0879, 'DriftPass');

L011  = drift('l011', 0.011, 'DriftPass');
L041  = drift('l041', 0.041, 'DriftPass');
L044  = drift('l044', 0.044, 'DriftPass');
L048  = drift('l048', 0.048, 'DriftPass');
L066  = drift('l066', 0.066, 'DriftPass');
L074  = drift('l074', 0.074, 'DriftPass');
L075  = drift('l075', 0.075, 'DriftPass');
L081  = drift('l081', 0.081, 'DriftPass');
L082  = drift('l082', 0.082, 'DriftPass');
L100  = drift('l100', 0.100, 'DriftPass');
L110  = drift('l110', 0.110, 'DriftPass');
L112  = drift('l112', 0.112, 'DriftPass');
L120  = drift('l120', 0.120, 'DriftPass');
L125  = drift('l125', 0.125, 'DriftPass');
L127  = drift('l127', 0.127, 'DriftPass');
L133  = drift('l133', 0.133, 'DriftPass');
L134  = drift('l134', 0.134, 'DriftPass');
L135  = drift('l135', 0.135, 'DriftPass');
L140  = drift('l140', 0.140, 'DriftPass');
L150  = drift('l150', 0.150, 'DriftPass');
L170  = drift('l170', 0.170, 'DriftPass');
L192  = drift('l192', 0.192, 'DriftPass');
L200  = drift('l200', 0.200, 'DriftPass');
L205  = drift('l205', 0.205, 'DriftPass');
L216  = drift('l216', 0.216, 'DriftPass');
L230  = drift('l230', 0.230, 'DriftPass');
L237  = drift('l237', 0.237, 'DriftPass');
L240  = drift('l240', 0.240, 'DriftPass');
L260  = drift('l260', 0.260, 'DriftPass');
L325  = drift('l325', 0.325, 'DriftPass');
L336  = drift('l336', 0.336, 'DriftPass');
L419  = drift('l419', 0.419, 'DriftPass');
L474  = drift('l474', 0.474, 'DriftPass');
L500  = drift('l500', 0.500, 'DriftPass');
L715  = drift('l715', 0.715, 'DriftPass');

L146  = drift('l146', 0.146, 'DriftPass');
L354  = drift('l354', 0.354, 'DriftPass');
L009  = drift('l009', 0.009, 'DriftPass');
L465  = drift('l465', 0.465, 'DriftPass');

% -- dipoles --

[BC, ~] = sirius_si_bc_segmented_model(bend_pass_method, m_accep_fam_name);
[B1, ~] = sirius_si_b1_segmented_model(bend_pass_method, m_accep_fam_name);
[B2, ~] = sirius_si_b2_segmented_model(bend_pass_method, m_accep_fam_name);


% -- quadrupoles --

[QFA, ~] = sirius_si_q20_segmented_model('QFA', QFA_strength,  quad_pass_method);
[QDA, ~] = sirius_si_q14_segmented_model('QDA', QDA_strength,  quad_pass_method);
[QDB2,~] = sirius_si_q14_segmented_model('QDB2',QDB2_strength, quad_pass_method);
[QFB, ~] = sirius_si_q30_segmented_model('QFB', QFB_strength,  quad_pass_method);
[QDB1,~] = sirius_si_q14_segmented_model('QDB1',QDB1_strength, quad_pass_method);
[QDP2,~] = sirius_si_q14_segmented_model('QDP2',QDP2_strength, quad_pass_method);
[QFP, ~] = sirius_si_q30_segmented_model('QFP', QFP_strength,  quad_pass_method);
[QDP1,~] = sirius_si_q14_segmented_model('QDP1',QDP1_strength, quad_pass_method);
[Q1,  ~] = sirius_si_q20_segmented_model('Q1',  Q1_strength,  quad_pass_method);
[Q2,  ~] = sirius_si_q20_segmented_model('Q2',  Q2_strength,  quad_pass_method);
[Q3,  ~] = sirius_si_q20_segmented_model('Q3',  Q3_strength,  quad_pass_method);
[Q4,  ~] = sirius_si_q20_segmented_model('Q4',  Q4_strength,  quad_pass_method);


% % -- sextupoles --
SDA0 = sextupole('SDA0', 0.150, SDA0_strength, sext_pass_method); %
SDB0 = sextupole('SDB0', 0.150, SDB0_strength, sext_pass_method); %
SDP0 = sextupole('SDP0', 0.150, SDP0_strength, sext_pass_method); %
SDA1 = sextupole('SDA1', 0.150, SDA1_strength, sext_pass_method); %
SDB1 = sextupole('SDB1', 0.150, SDB1_strength, sext_pass_method); %
SDP1 = sextupole('SDP1', 0.150, SDP1_strength, sext_pass_method); %
SDA2 = sextupole('SDA2', 0.150, SDA2_strength, sext_pass_method); %
SDB2 = sextupole('SDB2', 0.150, SDB2_strength, sext_pass_method); %
SDP2 = sextupole('SDP2', 0.150, SDP2_strength, sext_pass_method); %
SDA3 = sextupole('SDA3', 0.150, SDA3_strength, sext_pass_method); %
SDB3 = sextupole('SDB3', 0.150, SDB3_strength, sext_pass_method); %
SDP3 = sextupole('SDP3', 0.150, SDP3_strength, sext_pass_method); %
SFA0 = sextupole('SFA0', 0.150, SFA0_strength, sext_pass_method); %
SFB0 = sextupole('SFB0', 0.150, SFB0_strength, sext_pass_method); %
SFP0 = sextupole('SFP0', 0.150, SFP0_strength, sext_pass_method); %
SFA1 = sextupole('SFA1', 0.150, SFA1_strength, sext_pass_method); %
SFB1 = sextupole('SFB1', 0.150, SFB1_strength, sext_pass_method); %
SFP1 = sextupole('SFP1', 0.150, SFP1_strength, sext_pass_method); %
SFA2 = sextupole('SFA2', 0.150, SFA2_strength, sext_pass_method); %
SFB2 = sextupole('SFB2', 0.150, SFB2_strength, sext_pass_method); %
SFP2 = sextupole('SFP2', 0.150, SFP2_strength, sext_pass_method); %

% --- slow correctors ---
CV   = sextupole('CV', 0.150, 0.0, sext_pass_method);   % same model as BO correctors

% -- pulsed magnets --
InjDpK = sextupole('InjDpK', 0.400, 0.0, sext_pass_method); % injection kicker
InjNLK = sextupole('InjNLK',  0.450, 0.0, sext_pass_method); % pulsed multipole magnet
VPing  = marker('VPing', 'IdentityPass');                    % Vertical Pinger

% -- BPMs and fast correctors --
FC     = sextupole('FC', 0.100, 0.0, sext_pass_method);
FCQ    = sextupole('FCQ', 0.100, 0.0, sext_pass_method); % uses fast corrector magnet with skew quad coil

% -- rf cavities --
RFC = rfcavity('SRFCav', 0, 3.0e6, 500e6, harmonic_number, 'CavityPass');

% -- lattice markers --
START  = marker('start',    'IdentityPass'); % start of the model
END    = marker('end',      'IdentityPass'); % end of the model
MIA    = marker('mia',      'IdentityPass'); % center of long straight sections (even-numbered)
MIB    = marker('mib',      'IdentityPass'); % center of short straight sections (odd-numbered)
MIP    = marker('mip',      'IdentityPass'); % center of short straight sections (even-numbered)
GIR    = marker('girder',   'IdentityPass'); % marker used to delimitate girders. one marker at begin and another at end of girder.
MIDA   = marker('id_enda',  'IdentityPass'); % marker for the extremities of IDs in long straight sections
MIDB   = marker('id_endb',  'IdentityPass'); % marker for the extremities of IDs in short straight sections
MIDP   = marker('id_endp',  'IdentityPass'); % marker for the extremities of IDs in short straight sections
InjSF  = marker('InjSF',    'IdentityPass'); % end of thin injection septum

% -- diagnostics markers --
BPM    = marker('BPM',    'IdentityPass');
DCCT   = marker('DCCT',   'IdentityPass'); % DCCT to measure beam current
HScrap = marker('HScrap', 'IdentityPass'); % horizontal scraper
VScrap = marker('VScrap', 'IdentityPass'); % vertical scraper
GSL15  = marker('GSL15',  'IdentityPass'); % Generic Stripline (lambda/4)
GSL07  = marker('GSL07',  'IdentityPass'); % Generic Stripline (lambda/8)
BPME   = marker('BPME',   'IdentityPass'); % Extra BPM
BbBP   = marker('BbBP',   'IdentityPass'); % Bunch-by-Bunch Pickup
HBbBS  = marker('HBbBS',  'IdentityPass'); % Horizontal Bunch-by-Bunch Shaker
VBbBS  = marker('VBbBS',  'IdentityPass'); % Vertical Bunch-by-Bunch Shaker
HTuneS = marker('HTuneS', 'IdentityPass'); % Horizontal Tune Shaker
HTuneP = marker('HTuneP', 'IdentityPass'); % Horizontal Tune Pickup
VTuneS = marker('VTuneS', 'IdentityPass'); % Vertical Tune Shaker
VTuneP = marker('VTuneP', 'IdentityPass'); % Vertical Tune Pickup

%% transport lines
M1A      = [GIR,L134,GIR,QDA,L150,SDA0,L066,FC,L074,QFA,L150,SFA0,L135,BPM,GIR];                 % high beta xxM1 girder (with fasc corrector)
M1B      = [GIR,L134,GIR,QDB1,L150,SDB0,L240,QFB,L150,SFB0,L041,FC,L044,QDB2,L140,BPM,GIR];      % low beta xxM1 girder
M1P      = [GIR,L134,GIR,QDP1,L150,SDP0,L240,QFP,L150,SFP0,L041,FC,L044,QDP2,L140,BPM,GIR];      % low beta xxM1 girder
M2A      = fliplr(M1A);                                                                               % high beta xxM2 girder (with fast correctors)
M2B      = fliplr(M1B);                                                                               % low beta xxM2 girder
M2P      = fliplr(M1P);                                                                               % low beta xxM2 girder

M1B_BbBP = [GIR,L134,GIR,QDB1,L150,SDB0,L120,BbBP,L120,QFB,L150,SFB0,L041,FC,L044,QDB2,L140,BPM,GIR];


IDA        = [L500,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,LIA,L500];                              % high beta ID straight section
IDA_INJ    = [L500,HTuneS,LIA,L419,InjSF,L081,L500,L500,END,START,MIA,...
              LKK,InjDpK,LPMU,HScrap,L100,VScrap,L100,InjNLK,LPMD];                                        % high beta INJ straight section and Scrapers
IDA_HBbBS  = [L500,HBbBS,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,LIA,L500];                        % high beta ID straight section
IDA_HTuneP = [L500,HTuneP,LIA,L500,MIDA,L500,L500,MIA,L500,L500,MIDA,L500,LIA,L500];                       % high beta ID straight section

IDB        = [L500,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,LIB,L500];                              % low beta ID straight section
IDB_GSL07  = [L500,GSL07,LIB,L500,MIDB,L500,L500,MIB,L500,L500,MIDB,L500,LIB,L500];                        % low beta ID straight section

IDP        = [L500,LIP,L500,MIDP,L500,L500,MIP,L500,L500,MIDP,L500,LIP,L500];                              % low beta ID straight section
IDP_CAV    = [L500,LIP,L500,L500,L500,MIP,RFC,L500,L500,L500,LIP,L500];                                    % low beta RF cavity straight section
IDP_GSL15  = [L500,GSL15,LIP,L500,MIDP,L500,L500,MIP,L500,L500,MIDP,L500,LIP,L500];                        % low beta ID straight section

C1A      = [GIR,L474,GIR,SDA1,L170,Q1,L135,BPM,L125,SFA1,L230,Q2,L170,SDA2,GIR,L205,GIR,BPM,L011];         % arc sector in between B1-B2 (high beta odd-numbered straight sections)
C1B      = [GIR,L474,GIR,SDB1,L170,Q1,L135,BPM,L125,SFB1,L230,Q2,L170,SDB2,GIR,L205,GIR,BPM,L011];         % arc sector in between B1-B2 (low beta even-numbered straight sections)
C1P      = [GIR,L474,GIR,SDP1,L170,Q1,L135,BPM,L125,SFP1,L230,Q2,L170,SDP2,GIR,L205,GIR,BPM,L011];         % arc sector in between B1-B2 (low beta even-numbered straight sections)

C2A      = [GIR,L336,GIR,SDA3,L170,Q3,L230,SFA2,L260,Q4,L200,CV,GIR,L192,GIR,FCQ,L110,BPM,L075];           % arc sector in between B2-BC (high beta odd-numbered straight sections)
C2B      = [GIR,L336,GIR,SDB3,L170,Q3,L230,SFB2,L260,Q4,L200,CV,GIR,L192,GIR,FCQ,L110,BPM,L075];           % arc sector in between B2-BC (low beta even-numbered straight sections)
C2P      = [GIR,L336,GIR,SDP3,L170,Q3,L230,SFP2,L260,Q4,L200,CV,GIR,L192,GIR,FCQ,L110,BPM,L075];           % arc sector in between B2-BC (low beta even-numbered straight sections)

C3A      = [GIR,L715,GIR,L112,Q4,L133,BPM,L127,SFA2,L048,FC,L082,Q3,L170,SDA3,GIR,L325,GIR,BPM,L011];      % arc sector in between BC-B2 (high beta odd-numbered straight sections)
C3B      = [GIR,L715,GIR,L112,Q4,L133,BPM,L127,SFB2,L048,FC,L082,Q3,L170,SDB3,GIR,L325,GIR,BPM,L011];      % arc sector in between BC-B2 (low beta even-numbered straight sections)
C3P      = [GIR,L715,GIR,L112,Q4,L133,BPM,L127,SFP2,L048,FC,L082,Q3,L170,SDP3,GIR,L325,GIR,BPM,L011];      % arc sector in between BC-B2 (low beta even-numbered straight sections)

C4A        = [GIR,L216,GIR,SDA2,L170,Q2,L230,SFA1,L125,BPM,L135,Q1,L170,SDA1,GIR,L474,GIR];                % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C4A_VBbBS  = [GIR,L216,GIR,SDA2,L170,Q2,L230,SFA1,L125,BPM,L135,Q1,L170,SDA1,L237,VBbBS,GIR,L237,GIR];     % arc sector in between B2-B1 (high beta odd-numbered straight sections)
C4A_BPME   = [GIR,L216,GIR,SDA2,L170,Q2,L230,SFA1,L125,BPM,L135,Q1,L170,SDA1,L237,BPME,GIR,L237,GIR];      % arc sector in between B2-B1 (high beta odd-numbered straight sections)

C4B        = [GIR,L216,GIR,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,GIR,L474,GIR];                % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_DCCT   = [GIR,L216,GIR,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,DCCT,GIR,L237,GIR];      % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_VTuneP = [GIR,L216,GIR,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,VTuneP,GIR,L237,GIR];    % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4B_VPing  = [GIR,L216,GIR,SDB2,L170,Q2,L230,SFB1,L125,BPM,L135,Q1,L170,SDB1,L237,VPing,GIR,L237,GIR];     % arc sector in between B2-B1 (low beta even-numbered straight sections)

C4P        = [GIR,L216,GIR,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,GIR,L474,GIR];                % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4P_DCCT   = [GIR,L216,GIR,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,L237,DCCT,GIR,L237,GIR];      % arc sector in between B2-B1 (low beta even-numbered straight sections)
C4P_VTuneS = [GIR,L216,GIR,SDP2,L170,Q2,L230,SFP1,L125,BPM,L135,Q1,L170,SDP1,L237,VTuneS,GIR,L237,GIR];    % arc sector in between B2-B1 (low beta even-numbered straight sections)

%% GIRDERS

% straight sections
SS_S01 = IDA_INJ;    SS_S02 = IDB;
SS_S03 = IDP_CAV;    SS_S04 = IDB;
SS_S05 = IDA;        SS_S06 = IDB;
SS_S07 = IDP;        SS_S08 = IDB;
SS_S09 = IDA;        SS_S10 = IDB;
SS_S11 = IDP;        SS_S12 = IDB;
SS_S13 = IDA_HBbBS;  SS_S14 = IDB;
SS_S15 = IDP;        SS_S16 = IDB;
SS_S17 = IDA_HTuneP; SS_S18 = IDB;
SS_S19 = IDP_GSL15;  SS_S20 = IDB_GSL07;

% down and upstream straight sections
M1_S01 = M1A;       M2_S01 = M2A;       M1_S02 = M1B;      M2_S02 = M2B;
M1_S03 = M1P;       M2_S03 = M2P;       M1_S04 = M1B;      M2_S04 = M2B;
M1_S05 = M1A;       M2_S05 = M2A;       M1_S06 = M1B;      M2_S06 = M2B;
M1_S07 = M1P;       M2_S07 = M2P;       M1_S08 = M1B;      M2_S08 = M2B;
M1_S09 = M1A;       M2_S09 = M2A;       M1_S10 = M1B;      M2_S10 = M2B;
M1_S11 = M1P;       M2_S11 = M2P;       M1_S12 = M1B_BbBP; M2_S12 = M2B;
M1_S13 = M1A;       M2_S13 = M2A;       M1_S14 = M1B;      M2_S14 = M2B;
M1_S15 = M1P;       M2_S15 = M2P;       M1_S16 = M1B;      M2_S16 = M2B;
M1_S17 = M1A;       M2_S17 = M2A;       M1_S18 = M1B;      M2_S18 = M2B;
M1_S19 = M1P;       M2_S19 = M2P;       M1_S20 = M1B;      M2_S20 = M2B;

% dispersive arcs
C1_S01 = C1A; C2_S01 = C2A;    C3_S01 = C3B; C4_S01 = C4B;
C1_S02 = C1B; C2_S02 = C2B;    C3_S02 = C3P; C4_S02 = C4P;
C1_S03 = C1P; C2_S03 = C2P;    C3_S03 = C3B; C4_S03 = C4B;
C1_S04 = C1B; C2_S04 = C2B;    C3_S04 = C3A; C4_S04 = C4A;
C1_S05 = C1A; C2_S05 = C2A;    C3_S05 = C3B; C4_S05 = C4B;
C1_S06 = C1B; C2_S06 = C2B;    C3_S06 = C3P; C4_S06 = C4P;
C1_S07 = C1P; C2_S07 = C2P;    C3_S07 = C3B; C4_S07 = C4B;
C1_S08 = C1B; C2_S08 = C2B;    C3_S08 = C3A; C4_S08 = C4A;
C1_S09 = C1A; C2_S09 = C2A;    C3_S09 = C3B; C4_S09 = C4B;
C1_S10 = C1B; C2_S10 = C2B;    C3_S10 = C3P; C4_S10 = C4P;
C1_S11 = C1P; C2_S11 = C2P;    C3_S11 = C3B; C4_S11 = C4B;
C1_S12 = C1B; C2_S12 = C2B;    C3_S12 = C3A; C4_S12 = C4A_VBbBS;
C1_S13 = C1A; C2_S13 = C2A;    C3_S13 = C3B; C4_S13 = C4B_DCCT;
C1_S14 = C1B; C2_S14 = C2B;    C3_S14 = C3P; C4_S14 = C4P_DCCT;
C1_S15 = C1P; C2_S15 = C2P;    C3_S15 = C3B; C4_S15 = C4B;
C1_S16 = C1B; C2_S16 = C2B;    C3_S16 = C3A; C4_S16 = C4A_BPME;
C1_S17 = C1A; C2_S17 = C2A;    C3_S17 = C3B; C4_S17 = C4B_VTuneP;
C1_S18 = C1B; C2_S18 = C2B;    C3_S18 = C3P; C4_S18 = C4P_VTuneS;
C1_S19 = C1P; C2_S19 = C2P;    C3_S19 = C3B; C4_S19 = C4B_VPing;
C1_S20 = C1B; C2_S20 = C2B;    C3_S20 = C3A; C4_S20 = C4A;


%% SECTORS # 01..20

S01 = [M1_S01, SS_S01, M2_S01, B1, C1_S01, B2, C2_S01, BC, C3_S01, B2, C4_S01, B1];
S02 = [M1_S02, SS_S02, M2_S02, B1, C1_S02, B2, C2_S02, BC, C3_S02, B2, C4_S02, B1];
S03 = [M1_S03, SS_S03, M2_S03, B1, C1_S03, B2, C2_S03, BC, C3_S03, B2, C4_S03, B1];
S04 = [M1_S04, SS_S04, M2_S04, B1, C1_S04, B2, C2_S04, BC, C3_S04, B2, C4_S04, B1];
S05 = [M1_S05, SS_S05, M2_S05, B1, C1_S05, B2, C2_S05, BC, C3_S05, B2, C4_S05, B1];
S06 = [M1_S06, SS_S06, M2_S06, B1, C1_S06, B2, C2_S06, BC, C3_S06, B2, C4_S06, B1];
S07 = [M1_S07, SS_S07, M2_S07, B1, C1_S07, B2, C2_S07, BC, C3_S07, B2, C4_S07, B1];
S08 = [M1_S08, SS_S08, M2_S08, B1, C1_S08, B2, C2_S08, BC, C3_S08, B2, C4_S08, B1];
S09 = [M1_S09, SS_S09, M2_S09, B1, C1_S09, B2, C2_S09, BC, C3_S09, B2, C4_S09, B1];
S10 = [M1_S10, SS_S10, M2_S10, B1, C1_S10, B2, C2_S10, BC, C3_S10, B2, C4_S10, B1];
S11 = [M1_S11, SS_S11, M2_S11, B1, C1_S11, B2, C2_S11, BC, C3_S11, B2, C4_S11, B1];
S12 = [M1_S12, SS_S12, M2_S12, B1, C1_S12, B2, C2_S12, BC, C3_S12, B2, C4_S12, B1];
S13 = [M1_S13, SS_S13, M2_S13, B1, C1_S13, B2, C2_S13, BC, C3_S13, B2, C4_S13, B1];
S14 = [M1_S14, SS_S14, M2_S14, B1, C1_S14, B2, C2_S14, BC, C3_S14, B2, C4_S14, B1];
S15 = [M1_S15, SS_S15, M2_S15, B1, C1_S15, B2, C2_S15, BC, C3_S15, B2, C4_S15, B1];
S16 = [M1_S16, SS_S16, M2_S16, B1, C1_S16, B2, C2_S16, BC, C3_S16, B2, C4_S16, B1];
S17 = [M1_S17, SS_S17, M2_S17, B1, C1_S17, B2, C2_S17, BC, C3_S17, B2, C4_S17, B1];
S18 = [M1_S18, SS_S18, M2_S18, B1, C1_S18, B2, C2_S18, BC, C3_S18, B2, C4_S18, B1];
S19 = [M1_S19, SS_S19, M2_S19, B1, C1_S19, B2, C2_S19, BC, C3_S19, B2, C4_S19, B1];
S20 = [M1_S20, SS_S20, M2_S20, B1, C1_S20, B2, C2_S20, BC, C3_S20, B2, C4_S20, B1];
anel = [S01,S02,S03,S04,S05,S06,S07,S08,S09,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20];
elist = anel;


%% finalization

THERING = buildlat(elist);
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), energy);

% shift lattice to start at the marker 'inicio'
idx = findcells(THERING, 'FamName', 'start');
if ~isempty(idx)
    THERING = [THERING(idx:end) THERING(1:idx-1)];
end

% checks if there are negative-drift elements
lens = getcellstruct(THERING, 'Length', 1:length(THERING));
if any(lens < 0)
    error(['AT model with negative drift in ' mfilename ' !\n']);
end

% adjusts RF frequency according to lattice length and synchronous condition
%[beta, ~, ~] = lnls_beta_gamma(energy/1e9);
const  = lnls_constants;
L0_tot = findspos(THERING, length(THERING)+1);
%rev_freq    = beta * const.c / L0_tot;
rev_freq    = const.c / L0_tot;
fprintf('   Circumference: %.5f m\n', L0_tot);

rf_idx      = findcells(THERING, 'FamName', 'SRFCav');
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

r = THERING;



function the_ring = set_girders(the_ring)

gir = findcells(the_ring,'FamName','girder');

gir_ini = gir(1:2:end);
gir_end = gir(2:2:end);
if isempty(gir), return; end

for ii=1:length(gir_ini)
    idx = gir_ini(ii):gir_end(ii);
    name_girder = sprintf('%03d',ii);
    the_ring = setcellstruct(the_ring,'Girder',idx,name_girder);
end
%the_ring(gir) = [];


