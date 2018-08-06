function MMLROOT = setmmldirectories(MachineName, SubMachineName, ModeName, OpsFileExtension)
%SETMMLDIRECTORIES - Set the directory in the Matlab middle layer
%  setmmldirectories(MachineName, SubMachineName, ModeName, OpsFileExtension)

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Directories which define the data and opsdata tree %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AD = getad;

% MML directory
MMLROOT = getmmlroot;

% DataRoot Location
% Base on normal middle layer directory structure
AD.Directory.DataRoot = [MMLROOT, 'machine', filesep, MachineName, filesep, SubMachineName, 'Data', filesep, ModeName, filesep];


% Operational directory and physdata file
AD.Directory.OpsData    = [MMLROOT, 'machine', filesep, MachineName, filesep, SubMachineName, 'OpsData', filesep, ModeName, filesep];
AD.OpsData.PhysDataFile = [MMLROOT, 'machine', filesep, MachineName, filesep, SubMachineName, 'OpsData', filesep, MachineName, 'physdata.mat'];

%Data Archive Directories
AD.Directory.BPMData        = [AD.Directory.DataRoot, 'BPM',           filesep];
AD.Directory.TuneData       = [AD.Directory.DataRoot, 'Tune',          filesep];
AD.Directory.ChroData       = [AD.Directory.DataRoot, 'Chromaticity',  filesep];
AD.Directory.DispData       = [AD.Directory.DataRoot, 'Dispersion',    filesep];
AD.Directory.ConfigData     = [AD.Directory.DataRoot, 'MachineConfig', filesep];
AD.Directory.QMS            = [AD.Directory.DataRoot, 'QMS',           filesep];

%Response Matrix Directories
AD.Directory.BPMResponse    = [AD.Directory.DataRoot, 'Response', filesep, 'BPM',          filesep];
AD.Directory.TuneResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Tune',         filesep];
AD.Directory.ChroResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Chromaticity', filesep];
AD.Directory.DispResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Dispersion',   filesep];
AD.Directory.SkewResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Skew',         filesep];

%Default Data File Prefix
AD.Default.BPMArchiveFile   = 'BPM';                % File in AD.Directory.BPM               orbit data
AD.Default.TuneArchiveFile  = 'Tune';               % File in AD.Directory.Tune              tune data
AD.Default.ChroArchiveFile  = 'Chro';               % File in AD.Directory.Chromaticity      chromaticity data
AD.Default.DispArchiveFile  = 'Disp';               % File in AD.Directory.Dispersion        dispersion data
AD.Default.CNFArchiveFile   = 'CNF';                % File in AD.Directory.CNF               configuration data

%Default Response Matrix File Prefix
AD.Default.BPMRespFile      = 'BPMRespMat';         % File in AD.Directory.BPMResponse       BPM response matrices
AD.Default.TuneRespFile     = 'TuneRespMat';        % File in AD.Directory.TuneResponse      tune response matrices
AD.Default.ChroRespFile     = 'ChroRespMat';        % File in AD.Directory.ChroResponse      chromaticity response matrices
AD.Default.DispRespFile     = 'DispRespMat';        % File in AD.Directory.DispResponse      dispersion response matrices
AD.Default.SkewRespFile     = 'SkewRespMat';        % File in AD.Directory.SkewResponse      skew quadrupole response matrices

%Operational Files
AD.OpsData.LatticeFile   = ['GoldenConfig',    OpsFileExtension];
AD.OpsData.InjectionFile = ['InjectionConfig', OpsFileExtension];
AD.OpsData.BPMSigmaFile  = ['GoldenBPMSigma',  OpsFileExtension];
AD.OpsData.DispFile      = ['GoldenDisp',      OpsFileExtension];

%Operational Response Files
AD.OpsData.BPMRespFile  = ['GoldenBPMResp',  OpsFileExtension]; 
AD.OpsData.TuneRespFile = ['GoldenTuneResp', OpsFileExtension];
AD.OpsData.ChroRespFile = ['GoldenChroResp', OpsFileExtension];
AD.OpsData.DispRespFile = ['GoldenDispResp', OpsFileExtension];
AD.OpsData.SkewRespFile = ['GoldenSkewResp', OpsFileExtension];
AD.OpsData.RespFiles     = {...
        [AD.Directory.OpsData, AD.OpsData.BPMRespFile], ...
        [AD.Directory.OpsData, AD.OpsData.TuneRespFile], ...
        [AD.Directory.OpsData, AD.OpsData.ChroRespFile], ...
        [AD.Directory.OpsData, AD.OpsData.DispRespFile], ...
        [AD.Directory.OpsData, AD.OpsData.SkewRespFile]};

% Save AD
setad(AD);
