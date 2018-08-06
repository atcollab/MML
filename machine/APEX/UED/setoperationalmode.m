function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Switches between the various operational modes
%  setoperationalmode(ModeNumber)
%
%  See also aoinit, updateatindex, mlsinit


%global THERING

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
    %ModeCell = {'MLS Operations', 'MLS Model'};
    %[ModeNumber, OKFlag] = listdlg('Name','MLS','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell, 'ListSize', [450 200]);
    %if OKFlag ~= 1
    %   fprintf('   Operational mode not changed\n');
    %   return
    %end
    %if ModeNumber == 2
    %   ModeNumber = 101;  % Model
    %end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;
AD.Machine = 'APEX';           % Will already be defined if setpathmml was used
AD.SubMachine = 'Gun';         % Will already be defined if setpathmml was used
AD.MachineType = 'Transport';  % Will already be defined if setpathmml was used
AD.OperationalMode = '';       % Gets filled in later
AD.Energy = 0.105;             % make sure this is the same as bend2gev at the production lattice!
AD.InjectionEnergy = 0.105;
AD.HarmonicNumber = [];

% Defaults RF for disperion and chromaticity measurements (must be in Hardware units)
%AD.DeltaRFDisp = 1000e-3;
%AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-3;


% Tune processor delay: delay required to wait
% to have a fresh tune measurement after changing
% a variable like the RF frequency.
AD.TuneDelay = 0.0;


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
    AD.OperationalMode = 'APEX';
    ModeName = 'User';
    OpsFileExtension = '';

    % AT lattice
    %AD.ATModel = 'apexatdeck';
    %apexatdeck;

    % Golden TUNE is with the TUNE family
%     AO = getao;
%     AO.TUNE.Monitor.Golden = [
%         0.26023
%         0.40793
%         NaN];
%     setao(AO);
%     
%     % Golden chromaticity is in the AD (must be in Physics units!)
%     AD.Chromaticity.Golden = [.5; .5];  % ???

    %switch2hw;

    % This is a bit of a cluge to know if the user is on the ALS filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if 0 % isempty(strfind(lower(MMLROOT),'/remote/apex/hlc/matlab'))
        switch2sim;
    else
        switch2online;
        
        % Change defaults for LabCA if using it
        try
            if exist('lcaSetSeverityWarnLevel','file')
                % Retry count
                RetryCountNew = 200;  % 599-old labca, 149-labca_2_1_beta
                RetryCount = lcaGetRetryCount;
                lcaSetRetryCount(RetryCountNew);
                if RetryCount ~= RetryCountNew
                    fprintf('   Setting LabCA retry count to %d (was %d) (LabCA)\n', RetryCountNew, RetryCount);
                end

                % Timeout
                Timeout = lcaGetTimeout;
                TimeoutNew = .1;  % was .005  Default: .05-old labca, .1-labca_2_1_beta
                lcaSetTimeout(TimeoutNew);
                if abs(Timeout - TimeoutNew) > 1e-5
                    fprintf('   Setting LabCA TimeOut to %f (was %f) (LabCA)\n', TimeoutNew, Timeout);
                end
                %fprintf('   LabCA TimeOut = %f\n', Timeout);
                
                % Two calls are needed to for the SeverityWarnLevel (one less than 10, one greater)
                %  3 - Errors on UDF {Default}
                %  4 - Warning for the INVALID UDF (undefined) is turned off
                % 13 - NaN returned if INVALID UDF
                % 14 - A value is still returned on INVALID UDF
                lcaSetSeverityWarnLevel( 4);
                lcaSetSeverityWarnLevel(14);
                fprintf('   Set SeverityWarnLevel to 4 & 14 to avoid annoying UDF warnings/errors (LabCA).\n');
              end
        catch
            fprintf('   Error setting lcaSetSeverityWarnLevel (LabCA).\n');
        end
    end
    
elseif ModeNumber == 101
    % Model mode
    AD.OperationalMode = 'APEX - Model';
    ModeName = 'Model';
    OpsFileExtension = '_Model';

    % AT lattice
    %AD.ATModel = 'apexatdeck';
    %apexatdeck;

    % Golden TUNE is with the TUNE family???
    %AO = getao;
    %AO.TUNE.Monitor.Golden = [
    %    0.260
    %    0.408
    %    NaN];
    %setao(AO);

    % Golden chromaticity is in the AD (must be in Physics units!)
    %AD.Chromaticity.Golden = [.5; .5];  % ???

    %switch2hw;
    %switch2sim;
else
    error('Operational mode unknown');
end



% Set the AD directory path
setad(AD);
MMLROOT = setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;

if 0  % isempty(strfind(lower(MMLROOT),'/remote/apex/hlc/matlab'))
    % Keep the normal middle layer directory structure
    switch2sim;
    
    % Time zone difference from UTC [hours]
    AD.TimeZone = gettimezone;
    
else
    % Change data directory
    if ispc
        AD.Directory.DataRoot = ['\\als-filer\apex\data\', AD.SubMachine, filesep];
    else
        AD.Directory.DataRoot = ['/remote/apex/data/', AD.SubMachine, filesep];
    end
    
    % Data Archive Directories
    AD.Directory.BPMData        = [AD.Directory.DataRoot, 'BPM', filesep];
    AD.Directory.TuneData       = [AD.Directory.DataRoot, 'Tune', filesep];
    AD.Directory.ChroData       = [AD.Directory.DataRoot, 'Chromaticity', filesep];
    AD.Directory.DispData       = [AD.Directory.DataRoot, 'Dispersion', filesep];
    AD.Directory.ConfigData     = [AD.Directory.DataRoot, 'MachineConfig', filesep];
    
    % Response Matrix Directories
    AD.Directory.BPMResponse    = [AD.Directory.DataRoot, 'Response', filesep, 'BPM', filesep];
    AD.Directory.TuneResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Tune', filesep];
    AD.Directory.ChroResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Chromaticity', filesep];
    AD.Directory.DispResponse   = [AD.Directory.DataRoot, 'Response', filesep, 'Dispersion', filesep];
    
    % Time zone difference from UTC [hours]
    try
        AD.TimeZone = gettimezone;
        % Best to base this on a PV
        %AD.TimeZone = gettimezone('llrf1:w1');
        %AD.TimeZone = gettimezone('Gun:Vac:Intlk');
    catch
        AD.TimeZone = -8;
        fprintf('  Time zone difference for UTC error.\n');
        fprintf('  Set to %.1f hours.  This might not be correct for day light savings.\n', AD.TimeZone);
    end
end

AD.Directory.Emittance = [AD.Directory.DataRoot, 'Emittance', filesep];
AD.Directory.Image     = [AD.Directory.DataRoot, 'Image', filesep];
    
AD.Directory = rmfield(AD.Directory,'SkewResponse');
%AD.Directory = rmfield(AD.Directory,'QMS');


% Circumference
AD.Circumference = 10;  % ???  findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
%updateatindex;


% Set the model energy
%setenergymodel(AD.Energy);


% Cavity and radiation
%setcavity off;  
%setradiation off;
%fprintf('   Radiation and cavities are off. Use setradiation / setcavity to modify.\n'); 


% Momentum compaction factor
%MCF = getmcf('Model');
%if isnan(MCF)
%    AD.MCF = 0.035089062542878;
%    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
%else
%    AD.MCF = MCF;
%    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
%end
setad(AD);


%%%%%%%%%%%%%%%%%%%%%%
% Final mode changes %
%%%%%%%%%%%%%%%%%%%%%%
if ModeNumber == 1
elseif ModeNumber == 101
    %setlocodata('Nominal');
    setfamilydata(0,'BPMx','Offset');
    setfamilydata(0,'BPMy','Offset');
    setfamilydata(0,'BPMx','Golden');
    setfamilydata(0,'BPMy','Golden');
else
    %setlocodata('Nominal');
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode);

