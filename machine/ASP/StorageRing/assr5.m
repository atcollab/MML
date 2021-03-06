function assr4(varargin)
% Lattice definition file - generated by dimad2at v1.300000 
%
% Eugene 2004-12-13 Updating the generalised file to realign the family
% names and elements with aspinit. NOTE: aspinit will not work with split
% elements... not without modification of the init file.
%
% Eugene 2005-09-16 Standardise all lattices being used to this. "Custom"
% versions of the lattice files, eg for ML, ID studies etc will take this
% file as a template. The following major changes were made -
%    * All family names in CAPS in line with ALS and SPEAR convention.
%    * Dipole path and gradient updated to reflect numerical studies on
%      measured data. Quadrupole values fitted for a tune of 13.3, 5.2 and
%      zero dispersion given the new dipole gradient fields.
%    * Merged with "aspsr_msrf.m" with independent/individual cavitie(s).
%    * Element positions/lengths should be inline with engineering
%      drawings.
%
% Eugene 2007-01-11 Changed method of defining the elements in the hope of
% simplying it. YET TO DO: CHECK ALL ELEMENT POSITIONS ESPECIALLY THE
% BPMS!!!!!!

global GLOBVAL

GLOBVAL.E0 = 3e9;
GLOBVAL.LatticeFile = mfilename;

L0 = 2.159946602239996e+02; % calculated using findspos %215.9945540689991;% with new dipole path lengths. Designed for 216m.
C0 = 299792458; 	   % speed of light [m/s]
HarmNumber = 360;

disp(' ');
fprintf('*** Loading lattice from %s.m ***\n',GLOBVAL.LatticeFile);

% ===== DEFINE STANDARD ELEMENTS ==== %

% With AT1.3 ringpass and linepass, particles limited by the apperturepass
% will have [x,x',y,y',delta,dl] = [NaN,0,0,0,0,0]. All pass methods will
% check for this and do nothing to particles with these coordinates.
% Ring/linepass will both return particle positions as well as the number
% of turns the particles achieved.
% ap  =   aperture('AP',[-32 17 -16 16]*1e-3,'AperturePass');
ap = struct('FamName','APE','Length',0,'Limits',[-16 17 -16 16]*1e2,'PassMethod','AperturePass');

% Beam position monitors
bpm = atelem('mark','FamName','BPM');

% Drift lengths without BPMs
% D1 SFA D2 QFA D3 SDA D4 Dipole D4 SDB D5 QDA D6 QFB D2 SFB(symmetry point)
d1	=	atelem('drift','FamName','D1','Length',2.698300e+000); % (2.698286 -> to get closer to the design distance of 216m)
d2	=	atelem('drift','FamName','D2','Length',1.900000e-001);
d3	=	atelem('drift','FamName','D3','Length',1.650000e-001);
d4	=	atelem('drift','FamName','D4','Length',2.750000e-001);
d5	=	atelem('drift','FamName','D5','Length',1.550000e-001);
d6	=	atelem('drift','FamName','D6','Length',4.500000e-001);
% Modified drifts around BPM sections. "_u" upstream, and "_d" downstream
bpm1d1_u = d1; bpm1d1_u.Length = d1.Length - 3.942860e-001; % Drifts around BPM1 (upstream)
bpm1d1_d = d1; bpm1d1_d.Length =             3.942860e-001; % Drifts around BPM1 (downstream)
bpm2d4_u = d4; bpm2d4_u.Length = d4.Length - 1.990000e-001; % Drifts around BPM2 (upstream)
bpm2d4_d = d4; bpm2d4_d.Length =             1.990000e-001; % Drifts around BPM2 (downstream)
bpm3d4_u = d4; bpm3d4_u.Length = d4.Length - 6.400000e-002; % Drifts around BPM3 (upstream)
bpm3d4_d = d4; bpm3d4_d.Length =             6.400000e-002; % Drifts around BPM3 (downstream)
bpm4d2_u = d2; bpm4d2_u.Length = d2.Length - 1.030000e-001; % Drifts around BPM4 (upstream)
bpm4d2_d = d2; bpm4d2_d.Length =             1.030000e-001; % Drifts around BPM4 (downstream)
bpm7d1_u = d1; bpm7d1_u.Length =             0.58;          % Drifts around BPM7 (upstream)
bpm7d1_d = d1; bpm7d1_d.Length = d1.Length - 0.58;          % Drifts around BPM7 (downstream)
% Define the position of the bpm. bpm1d1 represents BPM number 1 in the D1
% straight and bpm5d4 represents BPM number 5 in straight d4. bpm7dk and
% bpm7dr repreents BPM number 7 in either the kicker stright or RF
% straight.
bpm1d1 = { bpm1d1_u bpm bpm1d1_d };
bpm2d4 = { bpm2d4_u bpm bpm2d4_d };
bpm3d4 = { bpm3d4_u bpm bpm3d4_d };
bpm4d2 = { bpm4d2_u bpm bpm4d2_d };
bpm5d4 = bpm2d4;
bpm6d4 = bpm3d4;
bpm7d1 = { bpm7d1_u bpm bpm7d1_d };

% Single Dipole
% design -> rbend('BEND',1.726000e+000,2.243995e-001,...
%                     1.121997e-001,1.121997e-001,-3.349992e-001,[method]);
% From numerical studies ->   L: 1.72579121675e+000
%                             K: 0.33295132
%                          Sext: 0.01092687
%                           Oct: 0.15166053
% dipole1 = atelem('bend','FamName','BEND','Length',1.72579121675,'BendingAngle',2.243995e-001,...
%     'EntranceAngle',1.121997e-001,'ExitAngle',1.121997e-001,'K',-0.33295132,...
%     'PolynomB',[0 -0.33295132 0 0],'PolynomA',[0 0 0 0],...
%     'PassMethod','BndMPoleSymplectic4Pass','NumIntSteps',10,'MaxOrder',1);
% dipole2 = dipole1;
% dipole1_arc = [ bpm2d4 {dipole1} bpm3d4 ];
% dipole2_arc = [ bpm5d4 {dipole2} bpm6d4 ];

% Split Dipoles
% scalek = 0.991; % Scaling to estimate the edge effect contribution.
scalek = 1;
% scales = 12.64758043225615; % Scaling to estimate the sextupole component in the edge effect
scales = 1;
leftdrift_u  = atelem('drift','FamName','leftdrift','Length',0.076);
leftdrift_d  = atelem(leftdrift_u,'Length',0.0837626757 - leftdrift_u.Length);
rightdrift_d = atelem('drift','FamName','rightdrift','Length',0.064);
rightdrift_u = atelem(rightdrift_d,'Length',0.0887292346 - rightdrift_d.Length);

% Some defaults
mbend = atelem('bend','PolynomB',[0 0 0 0],'PolynomA',[0 0 0 0],...
    'PassMethod','BndMPoleSymplectic4Pass','NumIntSteps',10,'MaxOrder',3);

% SBEND (EntranceAngle = ExitAngle = 0)
b_left01 = atelem(mbend,'FamName','b_left01','Length',0.0695312761,'BendingAngle',0.0001684486,'K',-0.0058550750*scalek,'PolynomB',[0 -0.0058550750*scalek 0.0862147892*scales -1.2289013273]);
b_left02 = atelem(mbend,'FamName','b_left02','Length',0.0695282915,'BendingAngle',0.0007117061,'K',-0.0239389168*scalek,'PolynomB',[0 -0.0239389168*scalek -0.0583359949*scales -0.0632750927]);
b_left03 = atelem(mbend,'FamName','b_left03','Length',0.0695152451,'BendingAngle',0.0032675350,'K',-0.2254325358*scalek,'PolynomB',[0 -0.2254325358*scalek 0.2451727966*scales -0.1103893288]);
b_left04 = atelem(mbend,'FamName','b_left04','Length',0.0694679183,'BendingAngle',0.0087995936,'K',-0.4158165694*scalek,'PolynomB',[0 -0.4158165694*scalek -0.1443627022*scales 0.6681103839]);
b_left05 = atelem(mbend,'FamName','b_left05','Length',0.0694041758,'BendingAngle',0.0092692887,'K',-0.3298403749*scalek,'PolynomB',[0 -0.3298403749*scalek -0.0340207205*scales 0.3349521492]);
b_centre01 = atelem(mbend,'FamName','b_centre01','Length',0.2820465390,'BendingAngle',0.0367531161,'K',-0.3315842393*scalek,'PolynomB',[0 -0.3315842393*scalek 0.0083655817*scales 0.2965845308]);
b_centre02 = atelem(mbend,'FamName','b_centre02','Length',0.2815037989,'BendingAngle',0.0354072994,'K',-0.3306516396*scalek,'PolynomB',[0 -0.3306516396*scalek 0.0236710994*scales -0.2196079070]);
b_centre03 = atelem(mbend,'FamName','b_centre03','Length',0.2813281018,'BendingAngle',0.0349189639,'K',-0.3300962629*scalek,'PolynomB',[0 -0.3300962629*scalek 0.0101400673*scales -0.5218735605]);
b_centre04 = atelem(mbend,'FamName','b_centre04','Length',0.2814996751,'BendingAngle',0.0353946664,'K',-0.3302155286*scalek,'PolynomB',[0 -0.3302155286*scalek 0.0236248098*scales -0.2148826863]);
b_centre05 = atelem(mbend,'FamName','b_centre05','Length',0.2820380879,'BendingAngle',0.0367421671,'K',-0.3312220213*scalek,'PolynomB',[0 -0.3312220213*scalek 0.0103909753*scales 0.2969171603]);
b_right01 = atelem(mbend,'FamName','b_right01','Length',0.0694014448,'BendingAngle',0.0092683157,'K',-0.3292611055*scalek,'PolynomB',[0 -0.3292611055*scalek -0.0291322494*scales 0.3681905186]);
b_right02 = atelem(mbend,'FamName','b_right02','Length',0.0694650575,'BendingAngle',0.0090036557,'K',-0.3961176951*scalek,'PolynomB',[0 -0.3961176951*scalek -0.1539214712*scales 0.9528854933]);
b_right03 = atelem(mbend,'FamName','b_right03','Length',0.0695141539,'BendingAngle',0.0037120061,'K',-0.2701751814*scalek,'PolynomB',[0 -0.2701751814*scalek 0.3742213022*scales 0.7022676128]);
b_right04 = atelem(mbend,'FamName','b_right04','Length',0.0695280819,'BendingAngle',0.0007962279,'K',-0.0288159660*scalek,'PolynomB',[0 -0.0288159660*scalek -0.0571472318*scales 0.2460706289]);
b_right05 = atelem(mbend,'FamName','b_right05','Length',0.0695312501,'BendingAngle',0.0001902235,'K',-0.0028161106*scalek,'PolynomB',[0 -0.0028161106*scalek -0.1077402629*scales 0.7697020810]);

% RBEND
% b_left01 = atelem(mbend,'FamName','b_left01','Length',0.0695312761,'BendingAngle',0.0001700782,'EntranceAngle',0.1121962211,'ExitAngle',-0.1120187381,'K',0.0026580668*scalek,'PolynomB',[0 0.0026580668*scalek -0.0222542890 -0.0307698880]);
% b_left02 = atelem(mbend,'FamName','b_left02','Length',0.0695282915,'BendingAngle',0.0007118132,'EntranceAngle',0.1120187381,'ExitAngle',-0.1112734474,'K',0.0004302895*scalek,'PolynomB',[0 0.0004302895*scalek -0.0824996146 -0.0652385243]);
% b_left03 = atelem(mbend,'FamName','b_left03','Length',0.0695152451,'BendingAngle',0.0032678721,'EntranceAngle',0.1112734474,'ExitAngle',-0.1078414785,'K',-0.1045888695*scalek,'PolynomB',[0 -0.1045888695*scalek -0.0928717833 0.2254072448]);
% b_left04 = atelem(mbend,'FamName','b_left04','Length',0.0694679183,'BendingAngle',0.0088002187,'EntranceAngle',0.1078414785,'ExitAngle',-0.0989182337,'K',-0.3486275471*scalek,'PolynomB',[0 -0.3486275471*scalek -0.0656081148 0.3572852967]);
% b_left05 = atelem(mbend,'FamName','b_left05','Length',0.0694041758,'BendingAngle',0.0092692888,'EntranceAngle',0.0989182337,'ExitAngle',-0.0896518010,'K',-0.3281526271*scalek,'PolynomB',[0 -0.3281526271*scalek -0.0355726539 0.3355904266]);
% b_centre01 = atelem(mbend,'FamName','b_centre01','Length',0.2820465390,'BendingAngle',0.0367531221,'EntranceAngle',0.0896518010,'ExitAngle',-0.0529125655,'K',-0.3312315118*scalek,'PolynomB',[0 -0.3312315118*scalek 0.0081060667 0.2963931827]);
% b_centre02 = atelem(mbend,'FamName','b_centre02','Length',0.2815037989,'BendingAngle',0.0354072962,'EntranceAngle',0.0529125655,'ExitAngle',-0.0175134439,'K',-0.3306429237*scalek,'PolynomB',[0 -0.3306429237*scalek 0.0237264198 -0.2192733272]);
% b_centre03 = atelem(mbend,'FamName','b_centre03','Length',0.2813281018,'BendingAngle',0.0349189640,'EntranceAngle',0.0175134439,'ExitAngle',0.0174054578,'K',-0.3300984023*scalek,'PolynomB',[0 -0.3300984023*scalek 0.0101509428 -0.5218382720]);
% b_centre04 = atelem(mbend,'FamName','b_centre04','Length',0.2814996751,'BendingAngle',0.0353946633,'EntranceAngle',-0.0174054578,'ExitAngle',0.0528080683,'K',-0.3302048119*scalek,'PolynomB',[0 -0.3302048119*scalek 0.0235987043 -0.2144554284]);
% b_centre05 = atelem(mbend,'FamName','b_centre05','Length',0.2820380879,'BendingAngle',0.0367421699,'EntranceAngle',-0.0528080683,'ExitAngle',0.0895641319,'K',-0.3309037380*scalek,'PolynomB',[0 -0.3309037380*scalek 0.0102169077 0.2963545009]);
% b_right01 = atelem(mbend,'FamName','b_right01','Length',0.0694014448,'BendingAngle',0.0092683188,'EntranceAngle',-0.0895641319,'ExitAngle',0.0988345428,'K',-0.3275972520*scalek,'PolynomB',[0 -0.3275972520*scalek -0.0308930090 0.3680490900]);
% b_right02 = atelem(mbend,'FamName','b_right02','Length',0.0694650575,'BendingAngle',0.0090032960,'EntranceAngle',-0.0988345428,'ExitAngle',0.1077882518,'K',-0.3467634133*scalek,'PolynomB',[0 -0.3467634133*scalek -0.0345063628 0.6218385567]);
% b_right03 = atelem(mbend,'FamName','b_right03','Length',0.0695141539,'BendingAngle',0.0037116695,'EntranceAngle',-0.1077882518,'ExitAngle',0.1112699557,'K',-0.1347732139*scalek,'PolynomB',[0 -0.1347732139*scalek 0.0189958278 0.8526578807]);
% b_right04 = atelem(mbend,'FamName','b_right04','Length',0.0695280819,'BendingAngle',0.0007961566,'EntranceAngle',-0.1112699557,'ExitAngle',0.1120205593,'K',-0.0014988960*scalek,'PolynomB',[0 -0.0014988960*scalek -0.0849450391 0.2100836063]);
% b_right05 = atelem(mbend,'FamName','b_right05','Length',0.0695312501,'BendingAngle',0.0001897883,'EntranceAngle',-0.1120205593,'ExitAngle',0.1121997376,'K',0.0026764692*scalek,'PolynomB',[0 0.0026764692*scalek -0.0276971797 0.0360627830]);

dipole1_arc = { leftdrift_u bpm leftdrift_d b_left01 b_left02 b_left03 b_left04 ...
       b_left05 b_centre01 b_centre02 b_centre03 b_centre04 ...
       b_centre05 b_right01 b_right02 b_right03 b_right04 ...
       b_right05 rightdrift_u bpm rightdrift_d };
dipole2_arc = dipole1_arc;

% dipole1_arc = [leftdrift_a bpm leftdrift_b sf1 b_left01 b_left02 b_left03 b_left04 ...
%        b_left05 b_centre01 b_centre02 b_centre03 b_centre04 ...
%        b_centre05 b_right01 b_right02 b_right03 b_right04 ...
%        b_right05 sf2 rightdrift_a bpm rightdrift_b];
% dipole2_arc = dipole1_arc;


quad = atelem('quad','PolynomB',[0 0 0 0],'PolynomA',[0 0 0 0],...
    'NumIntSteps',10,'MaxOrder',1,'PassMethod','QuadLinearPass');

% Quadrupoles (for design dipole: [QFA,QDA,QFB]=[1.761741,-1.038377,1.533802];
% To match new single dipole values from numerical studies
% tune of 13.3, 5.2 and 0 dispersion in straights.
qfa	= atelem(quad,'FamName','QFA','Length',3.550000e-001,'K', 1.7610967e+000); qfa.PolynomB(2) = qfa.K;
qda	= atelem(quad,'FamName','QDA','Length',1.800000e-001,'K',-1.0715748e+000); qda.PolynomB(2) = qda.K;
qfb	= atelem(quad,'FamName','QFB','Length',3.550000e-001,'K', 1.5406418e+000); qfb.PolynomB(2) = qfb.K;

% To match split dipole values from numerical studies (SBENDS)
% tune of 13.216, 5.3006 and 0 dispersion in straights.
% qfa.K =  1.7610967e+000; qfa.PolynomB(2) = qfa.K;
% qda.K = -1.0715748e+000; qda.PolynomB(2) = qda.K;
% qfb.K =  1.5406418e+000; qfb.PolynomB(2) = qfb.K;

% To match split dipole values from numerical studies (RBENDS)
% tune of 13.216, 5.3006 and 0 dispersion in straights.
%  qfa.K =  1.7521052e+000; qfa.PolynomB(2) = qfa.K;
%  qda.K = -1.0897262e+000; qda.PolynomB(2) = qda.K;
%  qfb.K =  1.5452228e+000; qfb.PolynomB(2) = qfb.K;

% To match split dipole values from numerical studies (RBENDS)
% tune of 13.29, 5.216 and 0 dispersion in straights.
% qfa.K =  1.76190217411609; qfa.PolynomB(2) = qfa.K;
% qda.K = -1.08597141914729; qda.PolynomB(2) = qda.K;
% qfb.K =  1.54443756044807; qfb.PolynomB(2) = qfb.K;

% To match split dipole values from numerical studies (SBENDS)
% tune of 13.29, 5.216 and 0 dispersion in straights.
qfa.K =  1.76272982211693; qfa.PolynomB(2) = qfa.K;
qda.K = -1.06276736743823; qda.PolynomB(2) = qda.K;
qfb.K =  1.53992875479511; qfb.PolynomB(2) = qfb.K;


sext = atelem('sext','Length',2.000000e-001,'PolynomB',[0 0 0 0],'PolynomA',[0 0 0 0],...
    'KickAngle',[0 0],'NumIntSteps',10,'MaxOrder',2,'PassMethod','StrCorrMPoleSymplectic4Pass');

% Sextupoles with built in correctors. Corrector settings given by kick
% angle in radians.
sfa	=	atelem(sext,'FamName','SFA','PolynomB',[0 0  1.400000e+001 0]);
sda	=	atelem(sext,'FamName','SDA','PolynomB',[0 0 -1.400000e+001 0]);
sdb	=	atelem(sext,'FamName','SDB','PolynomB',[0 0 -7.014635e+000 0]);
sfb	=	atelem(sext,'FamName','SFB','PolynomB',[0 0  7.189346e+000 0]);
% sdb	=	atelem(sext,'FamName','SDB','PolynomB',[0 0 -8.16157050824899 0]);
% sfb	=	atelem(sext,'FamName','SFB','PolynomB',[0 0  7.49928624020018 0]);


% RF cavity and the corresponding straight used to position the cavity.
% 4.996540652069698e+008 old freq for 216m for 216.0004 its different. Also
% we are using ThinCavities therefore the drifts have to be set
% accordingly.
cav = struct('FamName','RF','Length',0,'Voltage',0.75e+006,'Frequency',C0/L0*HarmNumber,...
    'HarmNumber',HarmNumber,'PassMethod','CavityPass');
% drifts around the rf cavities and space between them
dRF1 = atelem('drift','FamName','dRF1','Length',d1.Length - 2.55);
dRF2 = atelem('drift','FamName','dRF2','Length',2.55/3);
bpm1d1RF = { dRF1 bpm dRF2 cav dRF2 cav dRF2 };


%fast feedback kicks
ffbh	=	atelem('corr','FamName','FFBH');
ffbv    =   atelem('corr','FamName','FFBV');


% Kickers and the associated drifts to position them. (to be checked)
kick	=	atelem('corr','FamName','KICK');
% Drift spaces to replace D1A for the upstream kickers, ie kickers 1 and 3.
% The measured distance 0.779 is the distance from the center of the kicker
% to the center of the sextupole.
kick1d1_d =	atelem(d1,'Length',0.779 - bpm1d1_d.Length);
kick1d1_u =	atelem(d1,'Length',bpm1d1_u.Length - kick1d1_d.Length);
% Drift spaces to replace D1A for the downstream kickers, ie kickers 2 and 4.
kick2d1_d =	atelem(d1,'Length',1.073 - bpm7d1_u.Length);
kick2d1_u =	atelem(d1,'Length',bpm7d1_d.Length - kick2d1_d.Length);
bpm1d1kick = { kick1d1_u kick kick1d1_d bpm bpm1d1_d };
bpm7d1kick = { bpm7d1_u bpm kick2d1_u kick kick2d1_d };


% wig = multipole('wig',0,[0 0 0 0],[0 0 0 10],'ThinMPolePass');
% wig = wiggler('ID12', 2, 0.1, 1.9, 5, 2, [0; 0; 0; 0; 0; 0;], [0; 0; 0; 0; 0; 0;], 'WigSymplectic4Pass');


% Arrange the elements onto the girders and use markers to define the
% sections for misalignment studies.
g1m1 = atelem('mark','FamName','g1m1');
g1m2 = atelem('mark','FamName','g1m2');
g2m1 = atelem('mark','FamName','g2m1');
g2m2 = atelem('mark','FamName','g2m2');
girder1 = { g1m1 sfa d2 qfa d3 sda g1m2 };
girder2 = [ { g2m1 sdb d5 qda d6 qfb d2 sfb } bpm4d2 { qfb d6 qda d5 sdb g2m2 } ];
girder3 = { g1m1 sda d3 qfa d2 sfa g1m2 };


% Arrange into sectors
% UnitCell
unitcell     = [ bpm1d1 girder1 dipole1_arc girder2 dipole2_arc girder3 bpm7d1 ];

% SECTOR 1
sector01     = unitcell;
sector01kick = [ bpm1d1kick girder1 dipole1_arc girder2 dipole2_arc girder3 bpm7d1kick ];
% SECTOR 2
sector02     = unitcell;
% SECTOR 3
sector03     = unitcell;
% SECTOR 4
sector04     = unitcell;
% SECTOR 5
sector05     = unitcell;
% SECTOR 6
sector06     = unitcell;
sector06RF   = [ bpm1d1RF girder1 dipole1_arc girder2 dipole2_arc girder3 bpm7d1 ];
% SECTOR 7
sector07     = unitcell;
sector07RF   = [ bpm1d1RF girder1 dipole1_arc girder2 dipole2_arc girder3 bpm7d1 ];
% SECTOR 8
sector08     = unitcell;
% SECTOR 9
sector09     = unitcell;
% SECTOR 10
sector10     = unitcell;
% SECTOR 11
sector11     = unitcell;
% SECTOR 12
sector12     = unitcell;
% SECTOR 13
sector13     = unitcell;
% SECTOR 14
sector14     = unitcell;
sector14kick = [ bpm1d1kick girder1 dipole1_arc girder2 dipole2_arc girder3 bpm7d1kick ];


ring     = [{ap} sector01 sector02 sector03 sector04 sector05 sector06 sector07,...
                 sector08 sector09 sector10 sector11 sector12 sector13 sector14];
fullring = [{ap} sector01kick sector02 sector03 sector04 sector05 sector06RF sector07RF,...
                 sector08     sector09 sector10 sector11 sector12 sector13   sector14kick];


% Choose which lattice to load else load "fullring" as the default.
if nargin > 0
    fprintf('Using lattice : %s \n', varargin{1});
    eval(['RING = ' varargin{1} ');']);
else
    % Default lattice to load
    fprintf('Using default lattice : fullring\n');
    RING = fullring;
end

% Set the energy 3GeV
RING = setcellstruct(RING, 'Energy', 1:length(RING), 3e9);

if nargout
    varargout{1} = RING;
else % If no output arguments - greate global variable THERING
    global THERING
    THERING = RING;
    
    if evalin('base','exist(''THERING'')')
        warning('Global variable THERING was overridden');
    else
        evalin('caller','global THERING');
    end
end