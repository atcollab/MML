function varargout = mlsatdeck(varargin)
% MLS - lattice definitions file for mls

% by Dennis Engel

global FAMLIST THERING

Energy = 0.105e9;   % energy [GeV]
L0  = 4.8e+001;	    % design length [m]
C0  = 299792458; 	% speed of light [m/s]
H   = 80;           % Cavity harmonic number
F   = C0*H/L0;
FAMLIST = cell(0);

disp(['   Loading MLS magnet lattice ',mfilename]);

%Aperture (not used)
AP.FamName = 'AP';
AP.Limits  = [-0.05, 0.05, -0.05, 0.05];
AP.PassMethod = 'AperturePass';
AP.Length = 0;

%Cavity
CAVVolt = -0.45;
CAV = rfcavity('RF',0,CAVVolt,F,H,'CavityPass');

%BPM
BPM = marker('BPM','IdentityPass');


%Drift
DLL=3.0;     
DKL=1.25;  
D1L=0.15 ;  
D2L=0.125;   
D3L=0.425 ;   
D4L=0.3   ;  
D5L=0.05   ;
D1 = drift( 'D1', D1L, 'DriftPass');
D2 = drift( 'D2', D2L, 'DriftPass');
D3 = drift( 'D3', D3L, 'DriftPass');
D4 = drift( 'D4', D4L, 'DriftPass');
D5=  drift( 'D5', D5L, 'DriftPass');
DL = drift( 'DL', DLL, 'DriftPass');
DK = drift( 'DK', DKL, 'DriftPass');


%Bend
LB=1.2;
BB = rbend_mls('BEND',LB,(pi/4),(pi/8),(pi/8),0,'BendLinearPass',0.05,0.33);

%Quadrupole
LQ=0.2;

KQ1 =  5.07798;
KQ2 = -3.61889;
KQ3 =  2.971961;
KQ4 = -2.365518;
KQ5 =  3.977360;

% KQ1 =  5.7027;
% KQ2 = -4.4616;
% KQ3 =  2.6952;
% KQ4 = -4.4115;
% KQ5 =  4.9226;

Q1_2 = quadrupole('QF',  LQ, KQ1, 'QuadLinearPass');
Q1_4 = quadrupole('QF',  LQ, KQ1, 'QuadLinearPass');
Q2_2 = quadrupole('QD',  LQ, KQ2, 'QuadLinearPass');
Q2_4 = quadrupole('QD',  LQ, KQ2, 'QuadLinearPass');
Q3   = quadrupole('QFA', LQ, KQ3, 'QuadLinearPass');
Q4   = quadrupole('QD',  LQ, KQ4, 'QuadLinearPass');
Q5   = quadrupole('QF',  LQ, KQ5, 'QuadLinearPass');


%Sextupoles
SS1= 2.560771;
SS2= -2.769296;
SS3= 0.0;
SSL = 0.1;
SF  = sextupole('S1', SSL/2, SS1, 'StrMPoleSymplectic4Pass');
SD  = sextupole('S2', SSL/2, SS2, 'StrMPoleSymplectic4Pass');
HSD = sextupole('S3', SSL/2, SS3, 'StrMPoleSymplectic4Pass');


%Correctors
HS = corrector('HCM', 0.00 , [0 0], 'CorrectorPass');
VS = corrector('VCM', 0.00 , [0 0], 'CorrectorPass');


%Octupole
KOO3L= 0.1; %OKTU
OO1 = octupole('OCTU', KOO3L, 0, 'StrMPoleSymplectic4Pass');


%------------------------------------------------------
%GEOMETRIE
 %S1={ SF SF D5 SF SF D5 SF SF };
 %S2={ SD SD D5 SD SD D5 SD SD };
 %S3={ HSD HSD D5 HSD HSD D5 HSD HSD };
 %S4={ SF SF D5 SF SF D5 SF SF };
 
S1 = [ SF  HS    SF  ];
S2 = [ SD     VS SD  ];
S3 = [ HSD HS VS HSD ];
S4 = [ SF        SF  ];

GRAD3_1=[BPM DL  S3 D1 Q1_4 D1 Q2_4 BPM D3  ];
GRAD3_2=[DL  BPM S3 D1 Q1_4 D1 Q2_4 D3  BPM ];
GRAD2_2=[BPM DK  S3 D1 Q5 D1 Q4 BPM D3  ];
ACH2_2=[BB BPM D3 S2 D4  S1 D1 Q3 BPM D2];
ACH1_2=[BB D3  S2 D4 BPM S4 D1 Q3 D2];
ACH_2=[ACH1_2 OO1 reverse(ACH2_2)];
GRAD1_2=[DL  BPM S3 D1 Q1_2 D1 Q2_2 D3  BPM ];

RI1=[ GRAD1_2 ACH_2 reverse(GRAD2_2)];
RI3=[ GRAD3_2 ACH_2 reverse(GRAD2_2)];

GRAD1_1=[BPM DL  S3 D1 Q1_2 D1 Q2_2 BPM D3  ];
ACH1_1=[BB BPM D3 S2 D4 S4 D1 Q3 BPM D2];
ACH2_1=[BB D3 S2 D4 BPM S1 D1 Q3 D2];
ACH_1 =[ACH1_1 OO1 reverse(ACH2_1)];
GRAD2_1=[DK  BPM S3 D1 Q5 D1 Q4 D3  BPM ];

RI2=[ GRAD2_1 reverse(ACH_1) reverse(GRAD1_1)];
RI4=[ GRAD2_1 reverse(ACH_1) reverse(GRAD3_1)];

RING=[ RI2 RI1 RI4 CAV RI3 ]; 

buildlat(RING);


%---------------------------------------------
%--- debug section 
%---------------------------------------------
%findspos(RING,1:length(RING)+1)
l = 0;
for ii=1:length(THERING)
    %RING{1,ii} %List all Objects
    out{ii,1} = THERING{1,ii}.FamName;
    t = 0;
    for aa=1:ii-1
        t = t + THERING{1,aa}.Length;
    end
    out{ii,2} = t;
    l = THERING{1,ii}.Length + t;
end
%out
disp(['     -> Gesamtlaenge : ',num2str(l), ' m']);

% end automatic generated file mls.m


% Newer AT versions requires 'Energy' to be an AT field
THERING = setcellstruct(THERING, 'Energy', 1:length(THERING), Energy);

clear global FAMLIST 

% LOSSFLAG is not global in AT1.3
evalin('base','clear LOSSFLAG');   % Unfortunately it will come back


