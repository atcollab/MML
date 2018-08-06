function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  INPUTS
%  1. ModeNumber = 1. 3.0 GeV, lattice 18.18 8.37
%
%                100. Laurent's Mode
%
%  See also aoinit, updateatindex, soleilinit

% Written by Laurent S. Nadolski


global THERING

% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeNumber = [];
end
if isempty(ModeNumber)
    ModeCell = {'2.7391 GeV, 18.18 8.37', 'Laurent''s Mode'};
    [ModeNumber, OKFlag] = listdlg('Name','ALBA','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    if OKFlag ~= 1
        fprintf('   Operational mode not changed\n');
        return
    elseif ModeNumber == 2
        ModeNumber = 100;  % Laurent
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'ALBA';            % Will already be defined if setpathmml was used
AD.MachineType = 'StorageRing';   % Will already be defined if setpathmml was used
AD.SubMachine  = 'StorageRing';   % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.HarmonicNumber = 448;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.  Setpv will wait
% 2.2 * TuneDelay to be guaranteed a fresh data point.
AD.BPMDelay  = 0.25; % use [N, BPMDelay]=getbpmsaverages (AD.BPMDelay will disappear)
AD.TuneDelay = 0.1;

% The offset and golden orbits are stored at the end of this file


% SP-AM Error level
% AD.ErrorWarningLevel = 0 -> SP-AM errors are Matlab errors {Default}
%                       -1 -> SP-AM errors are Matlab warnings
%                       -2 -> SP-AM errors prompt a dialog box
%                       -3 -> SP-AM errors are ignored (ErrorFlag=-1 is returned)
AD.ErrorWarningLevel = 0;

%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names

if ModeNumber == 1
    % User mode - High Tune, Top Off injection
    AD.OperationalMode = '3.0 GeV, 18.18 8.37';
    AD.Energy = 3.0; % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'a25';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'a25';
    eval(AD.ATModel);  %run model for compiler;

    % Golden TUNE is with the TUNE family
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.18
        0.37
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [1; 1]; 

    % Defaults RF for dispersion and chromaticity measurements (must be in Hardware units)
    AD.DeltaRFDisp = 100e-6;
    AD.DeltaRFChro = [-100 -50 0 50 150] * 1e-6;

    switch2hw;


elseif ModeNumber == 100
    % User mode - High Tune, Top Off injection
    AD.OperationalMode = '2.7391 GeV, 18.2 10.3';
    AD.Energy = 2.7391;     % Make sure this is the same as bend2gev at the production lattice!
    ModeName = 'chasmann_green';
    OpsFileExtension = '_chasmann_green';

    % AT lattice
    AD.ATModel = 'chasman_green';
    chasman_green;

    % Golden TUNE is with the TUNE family
    % 18.20 / 10.30
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.20
        0.30
        NaN];
    setao(AO);

    % Golden chromaticity is in the AD (Physics units)
    AD.Chromaticity.Golden = [2; 2]; 

    setfamilydata(ones(120,1)*1e-5, 'HCOR', 'Setpoint', 'DeltaRespMat');
    setfamilydata(ones(120,1)*1e-5, 'VCOR', 'Setpoint', 'DeltaRespMat');
    % AO.(ifam).Setpoint.DeltaRespMat(:,:) = ones(nb,1)*0.5e-4*1; % 2*25 urad (half used for kicking)
    switch2hw;

else
    error('Operational mode unknown');
end



% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

% Changes to default directories and filenames
% Top Level Directories
AD.Directory.DataRoot       = fullfile(MMLROOT, 'measdata', AD.Machine, 'StorageRing', filesep);
AD.Directory.Lattice        = fullfile(MMLROOT, 'machine', AD.Machine, 'StorageRing', 'Lattices', filesep);
AD.Directory.Orbit          = fullfile(MMLROOT, 'machine', AD.Machine, 'StorageRing', 'Orbit', filesep);

% Data Archive Directories
AD.Directory.BumpData       = fullfile(AD.Directory.DataRoot, 'Bumps', filesep);
AD.Directory.Archiving      = fullfile(AD.Directory.DataRoot, 'ArchivingData', filesep);
AD.Directory.QUAD           = fullfile(AD.Directory.DataRoot, 'QUAD', filesep);

% Default Data File Prefix
AD.Default.QUADArchiveFile     = 'QuadBeta';           %file in AD.Directory.QUAD             betafunction for quadrupoles   
AD.Default.SkewArchiveFile     = 'SkewQuad';           %file in AD.Directory.SkewQuad             SkewQuad data


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);
setad(AD);

% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;

% Set the model energy
setenergymodel(AD.Energy);

% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 8.8e-04;  
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);




%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
% if any(ModeNumber == [1 2])
%     % User mode - 3.00 GeV, Nominal lattice
% 
%     % Tune actuactors
%     MemberOf = getfamilydata('QF1','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QF1','MemberOf');
%     MemberOf = getfamilydata('QF2','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QF2','MemberOf');
%     MemberOf = getfamilydata('QF3','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QF3','MemberOf');
%     MemberOf = getfamilydata('QF4','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QF4','MemberOf');
%     MemberOf = getfamilydata('QF5','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QF5','MemberOf');
%     MemberOf = getfamilydata('QF6','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QF6','MemberOf');
%     MemberOf = getfamilydata('QF7','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QF7','MemberOf');
%     MemberOf = getfamilydata('QD1','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QD1','MemberOf');
%     MemberOf = getfamilydata('QD3','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QD2','MemberOf');
%     MemberOf = getfamilydata('QD3','MemberOf');
%     setfamilydata({MemberOf{:} 'Tune Corrector'}','QD3','MemberOf');
%     
%     % Chromaticity actuators
%     MemberOf = getfamilydata('SD1','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SD1','MemberOf');
%     MemberOf = getfamilydata('SD2','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SD2','MemberOf');
%     MemberOf = getfamilydata('SD3','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SD3','MemberOf');
%     MemberOf = getfamilydata('SD4','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SD4','MemberOf');
%     MemberOf = getfamilydata('SD5','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SD5','MemberOf');
%     MemberOf = getfamilydata('SF1','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SF1','MemberOf');
%     MemberOf = getfamilydata('SF2','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SF2','MemberOf');
%     MemberOf = getfamilydata('SF3','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SF3','MemberOf');
%     MemberOf = getfamilydata('SF4','MemberOf');
%     setfamilydata({MemberOf{:} 'Chromaticity Corrector'}','SF4','MemberOf');
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add LOCO Parameters to AO and AT-Model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     'Nominal'    - Sets nominal gains (1) / rolls (0) to the model.
%     'SetGains'   - Set gains/coupling from a LOCO file.
%     'SetModel'   - Set the model from a LOCO file.  But it only changes
%                    the part of the model that does not get corrected
%                    in 'Symmetrize' (also does a SetGains).
%     'LOCO2Model' - Set the model from a LOCO file (also does a SetGains).
%                    This uses the LOCO AT model!!! And sets all lattice
%                    machines fit in the LOCO run to the model.
%
% Basically, use 'SetGains' or 'SetModel' if the LOCO run was applied to the accelerator
%            use 'LOCO2Model' if the LOCO run was made after the final setup

try
    setlocodata('Nominal');
    %LOCOFile = [getfamilydata('Directory','OpsData'),'LOCO_Production'];
    %setlocodata('SetGains', LOCOFile);
    %setlocodata('SetModel', LOCOFile);
    %setlocodata('LOCO2Model', LOCOFile);
catch
    fprintf('\n%s\n\n', lasterr);
    fprintf('   WARNING: there was a problem calibrating the model based on LOCO file %s.\n', AD.OpsData.LOCOFile);
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

setad(orderfields(AD));
