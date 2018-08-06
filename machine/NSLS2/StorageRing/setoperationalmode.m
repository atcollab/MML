function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%
%  See also aoinit, updateatindex

global THERING

% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ModeCell = {'NSLS-II Model', 'NSLS-II Operations' };

if nargin < 1    
    [ModeNumber, OKFlag] = listdlg('Name','NSLS-II','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
       fprintf('   Operational mode not changed\n');
       return
    end
end


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'NSLS2';              % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 3.0;      % make sure this is the same as bend2gev at the production lattice!
AD.InjectionEnergy = 3.0;
AD.HarmonicNumber = 1320;


% RF Defaults for disperion and chromaticity measurements
% (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-500 -250 0 250 500] * 1e-6;


% Tune processor delay: delay required to wait to have a fresh tune  
% measurement after changing a variable like the RF frequency.
AD.TuneDelay = 0.0;


% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;

% Magnet unit conversion table=
%     Current           dBydx            
%       A                T/m       
d = load('QH1_CalibrationTable.mat');
%d.QH1unit(:,2:2:end) = -1 * d.QH1unit(:,2:2:end);
AD.QH1.MagnetTable = d.QH1unit;

d = load('QH2_CalibrationTable.mat');
AD.QH2.MagnetTable = d.QH2unit;

d = load('QH3_CalibrationTable.mat');
%d.QH3unit(:,2:2:end) = -1 * d.QH3unit(:,2:2:end);
AD.QH3.MagnetTable = d.QH3unit;

d = load('QL1_CalibrationTable.mat');
%d.QL1unit(:,2:2:end) = -1 * d.QL1unit(:,2:2:end);
AD.QL1.MagnetTable = d.QL1unit;

d = load('QL2_CalibrationTable.mat');
AD.QL2.MagnetTable = d.QL2unit;

d = load('QL3_CalibrationTable.mat');
%d.QL3unit(:,2:2:end) = -1 * d.QL3unit(:,2:2:end);
AD.QL3.MagnetTable = d.QL3unit;

d = load('QM1_CalibrationTable.mat');
%d.QM1unit(:,2:2:end) = -1 * d.QM1unit(:,2:2:end);
AD.QM1.MagnetTable = d.QM1unit;

d = load('QM2_CalibrationTable.mat');
AD.QM2.MagnetTable = d.QM2unit;

d = load('SH1_CalibrationTable.mat');
AD.SH1.MagnetTable = d.SH1unit;

d = load('SH3_CalibrationTable.mat');
%d.SH3unit(:,2:2:end) = -1 * d.SH3unit(:,2:2:end);
AD.SH3.MagnetTable = d.SH3unit;

d = load('SH4_CalibrationTable.mat');
%d.SH4unit(:,2:2:end) = -1 * d.SH4unit(:,2:2:end);
AD.SH4.MagnetTable = d.SH4unit;

d = load('SL1_CalibrationTable.mat');
%d.SL1unit(:,2:2:end) = -1 * d.SL1unit(:,2:2:end);
AD.SL1.MagnetTable = d.SL1unit;

d = load('SL2_CalibrationTable.mat');
AD.SL2.MagnetTable = d.SL2unit;

d = load('SL3_CalibrationTable.mat');
%d.SL3unit(:,2:2:end) = -1 * d.SL3unit(:,2:2:end);
AD.SL3.MagnetTable = d.SL3unit;

d = load('SM1_CalibrationTable.mat');
%d.SM1unit = -1 * d.SM1unit(:,2:2:end);
AD.SM1.MagnetTable = d.SM1unit;

d = load('SM2_CalibrationTable.mat');
AD.SM2.MagnetTable = d.SM2unit;

setad(AD);


% BPM Golden orbit
% Could be in the AD or AO
% Set to zero until quadcenters are known
AO = getao;
AO.BPMx.Golden = zeros(size(AO.BPMx.DeviceList,1),1);
AO.BPMy.Golden = zeros(size(AO.BPMy.DeviceList,1),1);
setao(AO);


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% MachineName - String used to build directory structure off DataRoot
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names

switch ModeNumber
    case 1
        % User mode
        AD.OperationalMode = '3.0 GeV';
        ModeName = 'User';
        OpsFileExtension = '';

        % AT lattice
        %AD.ATModel = 'NSLS2lattice';
        %NSLS2lattice;
        %nsls2_tracy_aug2007
        %AD.ATModel = 'nsls2atlat2012Aug';        
        AD.ATModel = 'nsls2atlat2014March';
        %nsls2_tracy_june2008
        %nsls2atlat2012Aug
        nsls2atlat2014March
        % Golden TUNE
        AO = getao;
        AO.TUNE.Golden = [
            0.360
            0.280
            NaN];
        setao(AO);

        % Golden chromaticity is in the AD (must be in Physics units!)
        AD.Chromaticity.Golden = [1.0; 1.0];
    otherwise
        error('Unknown operational mode ');
end

% Using physics units for now. Use hardware units 
% once the amp2k, k2amp are working.
%switch2physics;
switch2hw;

switch2sim;
%switch2online;
% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity off;  
setradiation off;
fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n'); 


% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.000363;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);

fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

