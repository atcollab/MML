function setoperationalmode(ModeNumber)
%SETOPERATIONALMODE - Set all the variables associated with an operational mode
%  setoperationalmode(ModeNumber)
%
%  See also aoinit, updateatindex



global THERING


% Check if the AO exists
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Dependent Modes %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1
    ModeNumber = 1;
    %ModeCell = {'User Mode', 'Model'};
    %[ModeNumber, OKFlag] = listdlg('Name','ASP','PromptString','Select the Operational Mode:', 'SelectionMode','single', 'ListString', ModeCell);
    %if OKFlag ~= 1
    %    fprintf('   Operational mode not changed\n');
    %    return
    %end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Accelerator Data Structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AD = getad;    
AD.Machine = 'ASP';               % Will already be defined if setpathmml was used
AD.SubMachine = 'BTS';            % Will already be defined if setpathmml was used
AD.OperationalMode = '';          % Gets filled in later
AD.Energy = 0.1;            % Take case as when model is loated this is set at the default model energy and may set dipoles accordingly.
AD.InjectionEnergy = 0.1;
AD.HarmonicNumber = 217;


% Defaults RF for disperion and chromaticity measurements (must be in Hardware units) ???
AD.DeltaRFDisp = 1000e-6;
AD.DeltaRFChro = [-2000 -1000 0 1000 2000] * 1e-6;


%%%%%%%%%%%%%%%%%%%%%
% Operational Modes %
%%%%%%%%%%%%%%%%%%%%%

% Mode setup variables (mostly path and file names)
% AD.OperationalMode - String used in titles
% ModeName - String used for mode directory name off DataRoot/MachineName
% OpsFileExtension - string add to default file names
if ModeNumber == 1
    % User mode
    AD.OperationalMode = 'BTS';
    ModeName = 'Commissioning';
    OpsFileExtension = '_Comm';
    
    % AT BTS lattice
    AD.ATModel = 'bts';
    bts;
    
    % This is a bit of a cluge to know if the user is on the ASP filer
    % If so, then the MML user probably wants to be online
    MMLROOT = getmmlroot;
    if isempty(findstr(lower(MMLROOT),'SomeDirectoryAtASP'))
        switch2sim;
    else
        switch2online;
    end
    switch2hw;

else
    error('Operational mode unknown');
end


% Set the AD directory path
% Set the AD directory path
setad(AD);
setmmldirectories(AD.Machine, AD.SubMachine, ModeName, OpsFileExtension);
AD = getad;


% Circumference
AD.Circumference = findspos(THERING,length(THERING)+1);


% Updates the AT indices in the MiddleLayer with the present AT lattice
updateatindex;


% Set the model energy
setenergymodel(AD.Energy);


% Cavity and radiation
setcavity on;
setradiation on;  
fprintf('   Radiation and cavities are on. Use setradiation / setcavity to modify.\n'); 


% Momentum compaction factor
MCF = getmcf('Model');
if isnan(MCF)
    AD.MCF = 0.0020;
    fprintf('   Model alpha calculation failed, middlelayer alpha set to  %f\n', AD.MCF);
else
    AD.MCF = MCF;
    fprintf('   Middlelayer alpha set to %f (AT model).\n', AD.MCF);
end
setad(AD);


% Final mode changes
if ModeNumber == 1
    % User mode - 1.9 GeV, High Tune

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Add LOCO Parameters to AO and AT-Model %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LocoFileDirectory = getfamilydata('Directory','OpsData');
    %setlocogains('SetGains',[LocoFileDirectory,'LocoDataSextupolesOn']);
%     setlocogains('Nominal');
% 
% elseif ModeNumber == 2
%     setlocogains('Nominal');
%     setfamilydata(0,'BPMx','Offset');
%     setfamilydata(0,'BPMy','Offset');
%     setfamilydata(0,'BPMx','Golden');
%     setfamilydata(0,'BPMy','Golden');
% 
%     setfamilydata(0,'TuneDelay');
% 
%     %setsp('SQSF', 0, 'Simulator', 'Physics');
%     %setsp('SQSD', 0, 'Simulator', 'Physics');
%     setsp('HCM', 0, 'Simulator', 'Physics');
%     setsp('VCM', 0, 'Simulator', 'Physics');
%     
% elseif ModeNumber == 3
%     setlocogains('Nominal');
%     setfamilydata(0,'BPMx','Offset');
%     setfamilydata(0,'BPMy','Offset');
%     setfamilydata(0,'BPMx','Golden');
%     setfamilydata(0,'BPMy','Golden');
% 
%     setfamilydata(0,'TuneDelay');
% 
%     %setsp('SQSF', 0, 'Simulator', 'Physics');
%     %setsp('SQSD', 0, 'Simulator', 'Physics');
%     setsp('HCM', 0, 'Simulator', 'Physics');
%     setsp('VCM', 0, 'Simulator', 'Physics');    
end


fprintf('   Middlelayer setup for operational mode: %s\n', AD.OperationalMode)


