% locosymmetrizelattice
%
% This routine reads the results of a LOCO analysis of the ALS lattice (59 gradient fit parameters
% plus arbitrary number of skew fit parameters - which are not used in the correction)
% and calculates the new quadrupole settings to restore the lattice symmetry. It allows to set
% the results.
%
% Christoph Steier, January 2003

% Revision History:
%
% Christoph Steier, May 2003
% changed nominal k-values from scalar values to a table depending on the bend magnet k-value.
% This is necessary since the bend magnet k-value is a fitparameter in LOCO but cannot be changed
% in the correction.

GLOBAL_SR_GEV = getenergy;
GLOBAL_ALSDATA_DIRECTORY = getfamilydata('Directory', 'DataRoot');
GLOBAL_SR_MODE_TITLE = getfamilydata('OperationalMode');

QFnom = [];
QDnom = [];
QFAnom = [];
QDAnom = [];
QF = [];
QD = [];
QDA = [];
QFA = [];
QFAtemp = [];
QFAsp2 = [];
QFnew = [];
QDnew = [];
QFAnew = [];
QDAnew = [];
QFAnew2 = [];

dispflag =  questdlg(str2mat('Which Lattice?'),sprintf('%.1f GeV lattice correction',GLOBAL_SR_GEV),'zero dispersion','distributed dispersion','nuy = 9.20','distributed dispersion');

if strcmp(dispflag,'distributed dispersion')
   disp('Using k-values for distributed dispersion lattice');
   kQF=		[2.215786	2.213483	2.211167];
   kQFS=	[2.196193	2.193814	2.191423];
   kQD=		[-2.373118	-2.356502	-2.339833];
   kQDS=	[-2.333062	-2.316356	-2.299600];
   kQFA=	[2.953626	2.954337	2.955047];
   kQFAS=	[3.120245	3.121515	3.122783];
   kQDA=	[-1.776475	-1.783112	-1.789750];
   kBEND=	[-0.7752	-0.7782		-0.7812];
elseif strcmp(dispflag,'zero dispersion')
   disp('Using k-values for zero dispersion lattice');
   kQF=		[2.251004	2.248699	2.246381];
   kQFS=	[2.231503	2.229118	2.226720];
   kQD=		[-2.377738	-2.361143	-2.344497];
   kQDS=	[-2.340959	-2.324256	-2.307502];
   kQFA=	[2.885429	2.886233	2.887035];
   kQFAS=	[3.050846	3.052208	3.053567];
   kQDA=	[-1.793550	-1.800245	-1.806938];
   kBEND=	[-0.7752	-0.7782		-0.7812];
elseif strcmp(dispflag,'nuy = 9.20')
   disp('Using k-values for distributed dispersion lattice, nuy = 9.20');
   kQF=	[2.238359		2.237111	2.234898];
   kQFS=	[2.221083    2.219784	2.217484];
   kQD=	[-2.520238	   -2.511045	-2.494778];
   kQDS=	[-2.492566	   -2.483259	-2.466793];
   kQFA=	[2.953949	    2.954352	2.955062];
   kQFAS=	[3.120093	 3.120815	3.122088];
   kQDA=	[-1.775702	   -1.779475	-1.786132];
   kBEND=	[-0.7765	-0.7782		-0.7812];
else
   error('Unknown lattice option');
end


olddir = pwd;

cd(GLOBAL_ALSDATA_DIRECTORY);

FileName = menu(sprintf('%s\n\nSymmetrize based on current setpoints of which lattice?',GLOBAL_SR_MODE_TITLE),'Production lattice','Injection lattice','Load from file','Exit');

if FileName == 1
    fprintf('  Using production lattice.\n');
    FileName = getfamilydata('OpsData', 'LatticeFile');
    DirectoryName = getfamilydata('Directory', 'OpsData');
    latticefilename = FileName;
    latticefilepath = DirectoryName;

elseif FileName == 2
    fprintf('  Using injection lattice.\n');
    FileName = getfamilydata('OpsData', 'InjectionFile');
    DirectoryName = getfamilydata('Directory', 'OpsData');
    latticefilename = FileName;
    latticefilepath = DirectoryName;

elseif FileName == 3
   [latticefilename, latticefilepath] = uigetfile('*.mat', 'Lattice filename.');
   if FileName==0
      error('  No filename selected.');
   end
   
elseif FileName == 4
   error('  locosymmetrizelattice canceled.');
else
   error('FileName did not make sense.');
end


if isempty(latticefilename) | (latticefilename == 0)
   error('You have selected an invalid lattice filename');
end

% cd(latticefilepath);
% 
% load(latticefilename);
% 
% ConfigSetpoint = LocoMeasData.MachineConfig;
% QFsp  = ConfigSetpoint.QF.Setpoint.Data;
% QDsp  = ConfigSetpoint.QD.Setpoint.Data;
% QDAsp = ConfigSetpoint.QDA.Setpoint.Data;
% 
% QFAsp2([1:6 9:14 17:22]) = ConfigSetpoint.QFA.Setpoint.Data(1);
% QFAsp2([ 7  8]) = ConfigSetpoint.QFA.Setpoint.Data(7);
% QFAsp2([15 16]) = ConfigSetpoint.QFA.Setpoint.Data(15);
% QFAsp2([23 24]) = ConfigSetpoint.QFA.Setpoint.Data(23);
% QFAsp2=QFAsp2';

cd(olddir);

%gotodata;
%cd 'smatrix/loco'

[locofilename,locofilepath] = uigetfile('*.mat','LOCO results: filename');

if isempty(locofilename) | (locofilename == 0)
   error('You have selected an invalid LOCO results filename');
end

cd(locofilepath);

load(locofilename);

cd(olddir);

% Use LOCO config
ConfigSetpoint = LocoMeasData.MachineConfig;
QFsp  = ConfigSetpoint.QF.Setpoint.Data;
QDsp  = ConfigSetpoint.QD.Setpoint.Data;
QDAsp = ConfigSetpoint.QDA.Setpoint.Data;

QFAsp2([1:6 9:14 17:22]) = ConfigSetpoint.QFA.Setpoint.Data(1);
QFAsp2([ 7  8]) = ConfigSetpoint.QFA.Setpoint.Data(7);
QFAsp2([15 16]) = ConfigSetpoint.QFA.Setpoint.Data(15);
QFAsp2([23 24]) = ConfigSetpoint.QFA.Setpoint.Data(23);
QFAsp2=QFAsp2';


numiter = size(FitParameters,2);

QF = FitParameters(numiter).Values(1:24);
QD = FitParameters(numiter).Values(25:48);

QFAtemp = FitParameters(numiter).Values(49:52);
QFA([1:6 9:14 17:22])=QFAtemp(1);QFA([7:8])=QFAtemp(2);QFA([15:16])=QFAtemp(3);QFA([23:24])=QFAtemp(4);
QFA=QFA';

QDA = FitParameters(numiter).Values(53:58);
BEND = FitParameters(numiter).Values(59);

BPMx = BPMData(numiter).HBPMGain;
BPMy = BPMData(numiter).VBPMGain;
HKick = CMData(numiter).HCMKicks;
VKick = CMData(numiter).VCMKicks;

% interpolate in k-value table to find right k-values for LOCO result for bend
% magnet gradient

QFnom([1:6 9:14 17:22])=interp1(kBEND,kQF,BEND,'linear','extrap');
QFnom([7:8 15:16 23:24])=interp1(kBEND,kQFS,BEND,'linear','extrap');
QDnom([1:6 9:14 17:22])=interp1(kBEND,kQD,BEND,'linear','extrap');
QDnom([7:8 15:16 23:24])=interp1(kBEND,kQDS,BEND,'linear','extrap');
QFAnom([1:6 9:14 17:22])=interp1(kBEND,kQFA,BEND,'linear','extrap');
QFAnom([7:8 15:16 23:24])=interp1(kBEND,kQFAS,BEND,'linear','extrap');
QDAnom([1:6])=interp1(kBEND,kQDA,BEND,'linear','extrap');

% transpose vectors to get same orientation as current setpoints in lattice file

QFnom = QFnom';
QDnom = QDnom';
QFAnom = QFAnom';
QDAnom = QDAnom';

% plot results of comparison with nominal lattice

figure

slabel = sprintf('k(QF) = %6.4f, k(QF_{4,8,12}) = %6.4f',...
   mean(QF([1:6 9:14 17:22])), mean(QF([7:8 15:16 23:24])));

subplot(4,1,1)
bar(QF./QFnom-1)
axis([0 25 -0.015 0.015])
text(2,-.012,slabel);
grid on
title('QF/QF_{nominal}')

slabel = sprintf('k(QD) = %6.4f, k(QD_{4,8,12}) = %6.4f',...
   mean(QD([1:6 9:14 17:22])), mean(QD([7:8 15:16 23:24])));

subplot(4,1,2)
bar(QD./QDnom-1)
axis([0 25 -0.015 0.015])
text(2,-.012,slabel);
grid on
title('QD/QD_{nominal}')

slabel = sprintf('k(QDA) = %6.4f',mean(QDA));

subplot(4,1,3)
bar([7:8 15:16 23:24],QDA./QDAnom-1)
xaxis([0 25])
text(2,-.012,slabel);
grid on
title('QDA./QDA_{nominal}')

slabel = sprintf('k(QFA) = %6.4f, k(QFA_{4,8,12}) = %6.4f, k(BEND) = %6.4f',QFA(1),...
   mean(QFA([7:8 15:16 23:24])),mean(BEND));

subplot(4,1,4)
bar(QFA./QFAnom-1)
axis([0 25 -0.015 0.015])
text(2,-.012,slabel);
grid on
title('QFA/QFA_{nominal}')

orient tall;

figure

subplot(2,1,1)
bar(BPMx/mean(BPMx) - 1)
yaxis([-0.5 0.5]);
grid on
title('Relative Horizontal BPM Gains')

subplot(2,1,2)
bar(BPMy/mean(BPMy) - 1)
yaxis([-0.5 0.5]);
grid on
title('Relative Vertical BPM Gains')

figure

subplot(2,1,1)
bar(HKick')
grid on
title('Horizontal Corrector Kicks')

subplot(2,1,2)
bar(VKick')
grid on
title('Vertical Corrector Kicks')

QFnew = QFsp.*QFnom./QF;
QDnew = QDsp.*QDnom./QD;
QFAnew2 = QFAsp2.*QFAnom./QFA;
QDAnew = QDAsp.*QDAnom./QDA;

QFAnew(1) = QFAnew2(1);
QFAnew(2) = QFAnew2(8);
QFAnew(3) = QFAnew2(16);
QFAnew(4) = QFAnew2(24);
QFAnew=QFAnew';

% Check whether to set calculated new current setpoints to the power supplies

CorrFlag = questdlg(str2mat('Do you want to set corrected quadrupole values?'),sprintf('%.1f GeV symmetry correction',GLOBAL_SR_GEV),'Yes','No','No');

if strcmp(CorrFlag,'Yes')
   fprintf('Applying corrected quadrupole settings!\n');
   
   setsp('QF',QFnew,[],0);
   setsp('QD',QDnew,[],0);
   setsp('QFA',QFAnew,[],0);
   setsp('QDA',QDAnew,[],0);
   
   pause(0.5);
   
   setsp('QF',QFnew,[],2);
   setsp('QD',QDnew,[],2);
   setsp('QFA',QFAnew,[],2);
   setsp('QDA',QDAnew,[],2);
   
   fprintf('Corrected quadrupole currents sent to powersupplies.\n');
   
   KeepFlag = questdlg(str2mat('Do you want to keep new quadrupole values?'),sprintf('%.1f GeV symmetry correction',GLOBAL_SR_GEV),'Yes','No','Yes');
   
   if strcmp(KeepFlag,'No')
      fprintf('Returning to nominal quadrupole settings!\n');
      
      setsp('QF',QFsp,[],0);
      setsp('QD',QDsp,[],0);
      setsp('QFA',QFAsp,[],0);
      setsp('QDA',QDAsp,[],0);
      
      pause(0.5);
      
      setsp('QF',QFsp,[],2);
      setsp('QD',QDsp,[],2);
      setsp('QFA',QFAsp,[],2);
      setsp('QDA',QDAsp,[],2);
      
      fprintf('Nominal quadrupole currents restored.\n');
      
   elseif strcmp(KeepFlag,'Yes')
      fprintf('Keeping new values.\n');
   else
      error('Unknown option');
   end
   
elseif strcmp(CorrFlag,'No')
   fprintf('No changes applied. New settings can be found in variables QFnew, QDnew, ...\n');
else
   error('Unknown option');
end


