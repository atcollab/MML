function setoperationalmode(ModeNumber)
%  setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  ModeNumber = 1. 1.9 GeV, Top Off
%               2. ...
%             101. 1.9 GeV, Model
%
%  See also aoinit, updateatindex, spsinit


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
    ModeNumber = 1;
    %ModeCell = {'SPS Operations', 'SPS Model'};
    %[ModeNumber, OKFlag] = listdlg('Name','SPS','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    %if OKFlag ~= 1
    %    fprintf('   Operational mode not changed\n');
    %    return
    %end
    %if ModeNumber == 2
    %    ModeNumber = 101;  % Model
    %end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeNumber = [];
end
if isempty(ModeNumber)
    ModeNumber = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'CLS';               % Will already be defined if setpathmml was used
AD.SubMachine = 'StorageRing';    % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy        = 2.9;
AD.InjectionEnergy = AD.Energy;
AD.HarmonicNumber = 285;
AD.CLight        = 2.99792458e+08;

% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


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
% MachineName - String used to build directory structure off DataRoot
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
MachineName = lower(AD.Machine);
if ModeNumber == 1
    % User mode
    AD.OperationalMode = '2.9 GeV';
    ModeName = 'User';
    OpsFileExtension = '';

    % AT lattice
    AD.ATModel = 'clsat';
    clsat;

    % Golden TUNE
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.220
        0.310
        NaN];
    setao(AO);
    
    % Golden chromaticity is in the AD (must be in Physics units!)
    AD.Chromaticity.Golden = [1; 1];

    % This is a huge cluge to know if I'm using my PC
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if ~isempty(findstr(lower(MMLROOT),'c:\greg'))
        switch2sim;
    else
        switch2online;
    end
    switch2hw;

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.
    AD.TuneDelay = 0.0;


elseif ModeNumber == 101
    % Model mode
    AD.OperationalMode = 'Model';
    ModeName = 'Model';
    OpsFileExtension = '_Model';

    % AT lattice
    AD.ATModel = 'clsat';
    clsat;

    % Golden TUNE
    AO = getao;
    AO.TUNE.Monitor.Golden = [
        0.220
        0.310
        NaN];
    setao(AO);
    
    % Golden chromaticity is in the AD (must be in Physics units!)
    AD.Chromaticity.Golden = [1; 1];

    switch2sim;
    switch2hw;

    % Tune processor delay: delay required to wait
    % to have a fresh tune measurement after changing
    % a variable like the RF frequency.
    AD.TuneDelay = 0.0;

else
    error('Operational mode unknown');
end



% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

% CLS specific path changes
AD.Default.ChicaneRespFile  = 'ChicaneRespMat'; % File in AD.Directory.BPMResponse    BPM/Chicane response matrice
AD.OpsData.ChicaneRespFile = ['GoldenChicaneResp', OpsFileExtension];
AD.OpsData.RespFiles{length(AD.OpsData.RespFiles)+1} = {[AD.Directory.OpsData, AD.OpsData.ChicaneRespFile]};

% Jeff's orbit GUI
AD.Directory.Orbit         = [MMLROOT, filesep, 'applications', filesep, 'orbit', filesep, 'cls', filesep];

% Beamline
DirectoryName = [MMLROOT, 'machine', filesep, 'CLS', filesep];
AD.Directory.AccCont        =  DirectoryName;
i = findstr(DirectoryName,filesep);
DirectoryName = DirectoryName(1:i(end)-1);
AD.Directory.BLData        = [AD.Directory.DataRoot, 'Beamline', filesep];
AD.Directory.BLResponse    = [AD.Directory.DataRoot, 'Response', filesep, 'Beamline', filesep];
AD.OpsData.BLFile            = 'GoldenBLOrbit';
AD.Default.BLArchiveFile = 'BL';
AD.Default.BLRespFile    = 'BLRespMat';
AD.OpsData.BLRespFile    = ['GoldenBLResp', OpsFileExtension];
AD.OpsData.RespFiles{length(AD.OpsData.RespFiles)+1} = {[AD.Directory.OpsData, AD.OpsData.BLRespFile]};


%Orbit Control and Feedback Files
AD.Restore.GlobalFeedback   = 'CLSRestore.m';
AD.Restore.BeamlineFeedback = 'CLSRestore.m';

AD.TuneDelay = 0.10;        %delay for Tune processor (sec)
setad(AD);



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
evalin('base','clear LOSSFLAG');  % Calculating mcf puts LOSSFLAG in the workspace
if isnan(MCF)
    AD.MCF = 0.0038;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);


%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
if ModeNumber == 1
    AD.OpsData.LOCOFile = [getfamilydata('Directory','OpsData'),'GoldenLOCO'];    
    try
        setlocodata('Nominal');

        % Only do these if there was enough coupling to get the vertical gains correct
        %setlocodata('SetGains', AD.OpsData.LOCOFile);
        %setlocodata('SetModel', AD.OpsData.LOCOFile);
        %setlocodata('LOCO2Model', AD.OpsData.LOCOFile);
    end
    
    % Load offsets from 2004-03-29 - 2004-30-31
    %load Offsets2004-03-30
    clsLoadQcenterData;

    SRmaster;

elseif ModeNumber == 101
    % Model
    setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');
end

setad(AD);

fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);



%load Offsets2004-08-30
%i = findrowindex(Xoffset(:,1:2), ao.BPMx.DeviceList);
%ao.BPMx.Offset(i) = Xoffset(:,3);

%i = findrowindex(Yoffset(:,1:2), ao.BPMy.DeviceList);
%ao.BPMy.Offset(i) = Yoffset(:,3);
% Jeff orbit code needs the CLSPhysicsData.mat file to be up-to-date
% setphysdata('BPMx', 'Offset', getoffset('BPMx'), 'NoArchive');
% setphysdata('BPMy', 'Offset', getoffset('BPMy'), 'NoArchive');
%
% setphysdata('BPMx', 'Golden', getgolden('BPMx'), 'NoArchive');
% setphysdata('BPMy', 'Golden', getgolden('BPMy'), 'NoArchive');
